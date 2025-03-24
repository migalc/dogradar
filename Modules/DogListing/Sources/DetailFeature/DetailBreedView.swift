//
//  SwiftUIView.swift
//  DogListing
//
//  Created by Miguel Alcantara on 24/03/2025.
//

import DogListingCore
import SwiftUI
import UIComponents

// MARK: - Factory

public struct DetailBreedViewFactory {
    public static func make(
        breed: String,
        getRandomImageForBreedUseCase: any GetRandomImageForBreedUseCaseable
    ) -> some View {
        DetailBreedView(
            viewModel: DetailBreedViewModel(
                breed: breed,
                getRandomImageForBreedUseCase: getRandomImageForBreedUseCase
            )
        )
    }
}

// MARK: - View implementation

public struct DetailBreedView<VM: DetailBreedViewModeling>: View {
    @StateObject public var viewModel: VM
    
    public var body: some View {
        content
            .task { [viewModel] in
                await viewModel.getImage()
            }
            .navigationTitle(viewModel.title)
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .breed(let name, let imageState):
            ScrollView {
                VStack {
                    imageView(for: imageState)
                    labelsView(title: name)
                }
                .padding()
            }
        }
    }

    @ViewBuilder
    func imageView(for state: DetailBreedViewModel.ImageState) -> some View {
        switch state {
        case .loading:
            LoadingView(subtitle: viewModel.loadingSubtitle)
        case .loaded(let url):
            AsyncImage(
                url: url,
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                },
                placeholder: { EmptyView() })
            .clipShape(.rect(cornerRadius: 8))
        case .error(let error):
            Text("Error occurred: \(error.localizedDescription)")
        }
    }

    func labelsView(title: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title)
                Text(viewModel.subtitle)
                    .font(.body)
            }
            Spacer()
        }
    }
}

// MARK: - Preview

final class DetailBreedViewModelStub: DetailBreedViewModeling {
    @Published var state: DetailBreedViewModel.State
    var title: String = "title"
    var subtitle: String = "subtitle"
    var loadingSubtitle: String = "loadingSubtitle"

    init(state: DetailBreedViewModel.State = .breed(name: "name", imageState: .loading),
         stateClosure: ((DetailBreedViewModelStub) -> Void)? = nil) {
        self.state = state
        self.stateClosure = stateClosure
    }

    let stateClosure: ((DetailBreedViewModelStub) -> Void)?
    
    func getImage() async {
        guard let stateClosure else { return }
        stateClosure(self)
    }
}

#Preview("Loading") {
    DetailBreedView(
        viewModel: DetailBreedViewModelStub(
            state: .breed(name: "Tst Name", imageState: .loading)
        )
    )
}

#Preview("Loaded") {
    DetailBreedView(
        viewModel: DetailBreedViewModelStub(
            state:
                    .breed(
                        name: "Tst Name",
                        imageState: .loaded(URL(string: "https://images.dog.ceo/breeds/hound-walker/n02089867_1918.jpg")!)
                    )
        )
    )
}


#Preview("Loaded after delay") {
    DetailBreedView(
        viewModel: DetailBreedViewModelStub(
            stateClosure: { vm in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    vm.state = .breed(
                        name: "Tst Name",
                        imageState: .loaded(URL(string: "https://images.dog.ceo/breeds/hound-walker/n02089867_1918.jpg")!)
                    )
                })
            })
    )
}
