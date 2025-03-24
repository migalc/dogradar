//
//  SwiftUIView.swift
//  DogListing
//
//  Created by Miguel Alcantara on 24/03/2025.
//

import SwiftUI
import UIComponents
import DetailFeature

// MARK: - Factory

public struct ListBreedsViewFactory {
    public static func make(getBreedsUseCase: any GetDogBreedsUseCaseable) -> some View {
        ListBreedsView(viewModel: ListBreedsViewModel(getBreedsUseCase: getBreedsUseCase))
    }
}

// MARK: - View implementation

public struct ListBreedsView<VM: ListBreedsViewModeling>: View {
    @StateObject public var viewModel: VM
    @State private var searchText: String = ""

    public var body: some View {
        NavigationStack {
            content
                .navigationTitle(viewModel.title)
                .navigationBarTitleDisplayMode(.inline)
        }
        .task { [viewModel] in
            await viewModel.getBreeds()
        }
        
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .listBreeds(let breeds):
            listBreedsView(breeds: breeds)
                .searchable(text: $searchText)
                .onChange(of: searchText) { _, value in
                    viewModel.filterBreeds(with: value)
                }
                .sheet(
                    item: $viewModel.selectedBreed,
                    content: {
                        detailView(for: $0)
                    }
                )
        case .empty:
            Text("No breeds found.")
        case .error(let error):
            Text("Error: \(error)")
        }
    }

    private var loadingView: some View {
        VStack {
            Spacer()
            LoadingView(subtitle: viewModel.loadingSubtitle)
            Spacer()
        }
    }

    private func listBreedsView(breeds: [Breed]) -> some View {
        List(breeds) { breed in
            NavigationLink(
                destination: { detailView(for: breed) },
                label: { CellRowView(text: breed.name) }
            )
        }
    }
}

// MARK: - Navigation

extension ListBreedsView {
    func detailView(for breed: Breed) -> some View {
        DetailBreedViewFactory.make(breed: breed.name,
                                    getRandomImageForBreedUseCase: DIContainer.shared.getRandomImageForBreedUseCase)
    }
}

// MARK: - Preview

import DogListingCore

final class ListBreedsViewModelStub: ListBreedsViewModeling {
    @Published var state: ListBreedsViewModel.State
    var selectedBreed: Breed?
    var title: String = "Title"
    let loadingSubtitle: String = "loadingSubtitle"

    init(state: ListBreedsViewModel.State = .empty) {
        self.state = state
    }
    
    func getBreeds() async {}
    func filterBreeds(with text: String) {}
}

// MARK: > Loading

#Preview("Loading") {
    ListBreedsView(viewModel: ListBreedsViewModelStub(state: .loading))
}

// MARK: > Error

private enum PreviewError: Error {
    case preview
}

#Preview("Error") {
    ListBreedsView(viewModel: ListBreedsViewModelStub(state: .error(PreviewError.preview)))
}

// MARK: > Empty

#Preview("Empty") {
    ListBreedsView(viewModel: ListBreedsViewModelStub(state: .empty))
}

private let stub: [Breed] = [
    Breed(name: "name", subBreeds: []),
    Breed(name: "name2", subBreeds: []),
]

// MARK: > With breeds

#Preview("With Breeds") {
    ListBreedsView(viewModel: ListBreedsViewModelStub(state: .listBreeds(stub)))
}

