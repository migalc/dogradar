//
//  DetailBreedViewModelTests.swift
//  DogListing
//
//  Created by Miguel Alcantara on 24/03/2025.
//

import Combine
@testable import DetailFeature
import Foundation
import DogListingCore
import Testing
import TestingUtils

class DetailBreedViewModelTests {
    var getRandomImageForBreedUseCaseSpy: GetRandomImageForBreedUseCaseSpy
    var cancellables: Set<AnyCancellable>
    
    init() {
        self.getRandomImageForBreedUseCaseSpy = GetRandomImageForBreedUseCaseSpy()
        cancellables = .init()
    }

    @Test(
        "When getting breed image URL, state is updated",
        arguments: [
            (Result<URL, Error>.success(stubUrl), DetailBreedViewModel.State.breed(name: stubBreedName, imageState: .loaded(stubUrl))),
            (.failure(AnyError()), DetailBreedViewModel.State.breed(name: stubBreedName, imageState: .error(AnyError())))
        ]
    )
    func getImage(result: Result<URL, Error>, state: DetailBreedViewModel.State) async throws {
        getRandomImageForBreedUseCaseSpy.getRandomImageResult = result
        
        let sut = makeSUT()
        var receivedStates = [DetailBreedViewModel.State]()
        
        await withCheckedContinuation { continuation in
            sut.$state.prefix(2)
                .sink(
                    receiveCompletion: { _ in continuation.resume() },
                    receiveValue: { receivedStates.append($0) })
                .store(in: &cancellables)
            
            Task { await sut.getImage() }
        }

        #expect(receivedStates == [.breed(name: Self.stubBreedName, imageState: .loading), state])
        #expect(getRandomImageForBreedUseCaseSpy.getRandomImageInputs == [Self.stubBreedName])
    }
}

// MARK: - SUT

private extension DetailBreedViewModelTests {
    func makeSUT(breed: String = "breed") -> DetailBreedViewModel {
        DetailBreedViewModel(breed: breed, getRandomImageForBreedUseCase: getRandomImageForBreedUseCaseSpy)
    }
}

// MARK: - Stubs

private extension DetailBreedViewModelTests {
    static var stubBreedName: String { "breed" }
    static var stubUrl: URL { URL(string: "stub")! }
}

// MARK: - Test Doubles

final class GetRandomImageForBreedUseCaseSpy: GetRandomImageForBreedUseCaseable {
    private(set) var getRandomImageInputs: [String] = []
    var getRandomImageResult: Result<URL, Error> = .success(URL(string: "test")!)
    
    func getRandomImage(for breed: String) async throws -> URL {
        getRandomImageInputs.append(breed)
        return try getRandomImageResult.get()
    }
}

// MARK: - Equatable conformance

extension DetailBreedViewModel.State: Equatable {
    public static func == (lhs: DetailBreedViewModel.State, rhs: DetailBreedViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case (.breed(let lhsName, let lhsImageState), .breed(let rhsName, let rhsImageState)):
            return lhsName == rhsName &&
                lhsImageState == rhsImageState
        }
    }
}

extension DetailBreedViewModel.ImageState: Equatable {
    public static func == (lhs: DetailBreedViewModel.ImageState, rhs: DetailBreedViewModel.ImageState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.loaded(let lhs), .loaded(let rhs)):
            return lhs == rhs
        case (.error(let lhs), .error(let rhs)):
            return lhs as? AnyError == rhs as? AnyError
        default:
            return false
        }
    }
}

