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

public protocol ListBreedsViewModeling: ObservableObject {
    var state: ListBreedsViewModel.State { get }
    var loadingSubtitle: String { get }

    func getBreeds() async
    func filterBreeds(with text: String)
}

// MARK: - Implementation

public final class ListBreedsViewModel: ListBreedsViewModeling {
    public enum State {
        case loading
        case empty
        case listBreeds([Breed])
        case error(Error)
    }

    private let getBreedsUseCase: GetDogBreedsUseCaseable

    public let loadingSubtitle: String = "Loading list..."
    @Published public var state: State = .loading
    private var fetchedBreeds: [Breed] = []

    public init(getBreedsUseCase: GetDogBreedsUseCaseable) {
        self.getBreedsUseCase = getBreedsUseCase
    }

    public func getBreeds() async {
        do {
            let breeds = try await getBreedsUseCase.getDogBreeds()
            fetchedBreeds = breeds
            await setState(to: breeds.isEmpty ? .empty : .listBreeds(breeds))
        } catch {
            await setState(to: .error(error))
        }
    }

    public func filterBreeds(with text: String) {
        Task {
            guard !fetchedBreeds.isEmpty, !text.isEmpty else {
                await setState(to: .listBreeds(fetchedBreeds))
                return
            }
            let filteredBreeds = fetchedBreeds.filter { $0.name.contains(text.lowercased()) }
            await setState(to: .listBreeds(filteredBreeds))
        }
    }
}

private extension ListBreedsViewModel {
    @MainActor
    func setState(to state: State) {
        self.state = state
    }
}

// MARK: - Helpers

extension Breed: Identifiable {
    public var id: String { name }
}
