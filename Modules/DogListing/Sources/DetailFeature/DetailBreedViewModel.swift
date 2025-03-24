//
//  Untitled.swift
//  DogListing
//
//  Created by Miguel Alcantara on 24/03/2025.
//

import Combine
import DogListingCore
import SwiftUI

// MARK: - Protocol

public protocol DetailBreedViewModeling: ObservableObject {
    var state: DetailBreedViewModel.State { get }
    var title: String { get }
    var subtitle: String { get }
    var loadingSubtitle: String { get }

    func getImage() async
}

// MARK: - Implementation

public final class DetailBreedViewModel: DetailBreedViewModeling {
    public enum ImageState {
        case loading
        case loaded(URL)
        case error(Error)
    }

    public enum State {
        case breed(name: String, imageState: DetailBreedViewModel.ImageState)
    }
    
    @Published public var state: DetailBreedViewModel.State
    public let title: String = "Details"
    public var subtitle: String = "Lorem ipsum"
    public var loadingSubtitle: String = "Loading image"

    private let breed: String
    private let getRandomImageForBreedUseCase: GetRandomImageForBreedUseCaseable

    public init(breed: String, getRandomImageForBreedUseCase: GetRandomImageForBreedUseCaseable) {
        self.breed = breed
        self.state = .breed(name: breed, imageState: .loading)
        self.getRandomImageForBreedUseCase = getRandomImageForBreedUseCase
    }

    public func getImage() async {
        do {
            let imageUrl = try await getRandomImageForBreedUseCase.getRandomImage(for: breed)
            await setState(to: .breed(name: breed, imageState: .loaded(imageUrl)))
        } catch {
            await setState(to: .breed(name: breed, imageState: .error(error)))
        }
        
    }
}

private extension DetailBreedViewModel {
    @MainActor
    func setState(to state: State) {
        self.state = state
    }
}
