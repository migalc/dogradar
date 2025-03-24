//
//  Test.swift
//  DogListing
//
//  Created by Miguel Alcantara on 24/03/2025.
//

import Combine
@testable import ListFeature
import DogListingCore
import Testing
import TestingUtils

class ListBreedsViewModelTests {
    var getDogBreedsUseCaseSpy: GetDogBreedsUseCaseSpy
    var cancellables: Set<AnyCancellable>
    
    init() {
        self.getDogBreedsUseCaseSpy = GetDogBreedsUseCaseSpy()
        cancellables = .init()
    }

    @Test(
        "When getting breeds, state is updated",
        arguments: [
            (Result<[Breed], Error>.success(ListBreedsViewModelTests.breedStubs), ListBreedsViewModel.State.listBreeds(ListBreedsViewModelTests.breedStubs)),
            (.success([]), ListBreedsViewModel.State.empty),
            (.failure(AnyError()), ListBreedsViewModel.State.error(AnyError()))
        ]
    )
    func getBreeds_whenUseCaseReturnsValue_stateIsUpdated(result: Result<[Breed], Error>, state: ListBreedsViewModel.State) async throws {
        getDogBreedsUseCaseSpy.getDogBreedsResult = result
        
        let sut = makeSUT()
        var receivedStates = [ListBreedsViewModel.State]()
        
        await withCheckedContinuation { continuation in
            sut.$state.dropFirst().prefix(1)
                .sink(
                    receiveCompletion: { _ in continuation.resume() },
                    receiveValue: { receivedStates.append($0) })
                .store(in: &cancellables)
            
            Task { await sut.getBreeds() }
        }

        #expect(receivedStates == [state])
        #expect(getDogBreedsUseCaseSpy.getDogBreedsCallCount == 1)
    }

    @Test(
        "When searching breeds, state is updated",
        arguments: [
            ("t", ListBreedsViewModelTests.breedStubs),
            ("tes", ListBreedsViewModelTests.breedStubs),
            ("asd", [])
        ]
    )
    func getBreeds_whenSearchTextIsPassed_breedsAreFiltered(searchText: String, result: [Breed]) async throws {
        let getDogBreedsResult = ListBreedsViewModelTests.breedStubs
        getDogBreedsUseCaseSpy.getDogBreedsResult = .success(getDogBreedsResult)
        
        let sut = makeSUT()
        var receivedStates = [ListBreedsViewModel.State]()
        
        await withCheckedContinuation { continuation in
            sut.$state.dropFirst(2).prefix(1)
                .sink(
                    receiveCompletion: { _ in continuation.resume() },
                    receiveValue: { receivedStates.append($0) })
                .store(in: &cancellables)
            
            Task {
                await sut.getBreeds()
                sut.filterBreeds(with: searchText)
            }
        }

        #expect(receivedStates == [.listBreeds(result)])
        #expect(getDogBreedsUseCaseSpy.getDogBreedsCallCount == 1)
    }
}

// MARK: - SUT

private extension ListBreedsViewModelTests {
    func makeSUT() -> ListBreedsViewModel {
        ListBreedsViewModel(getBreedsUseCase: getDogBreedsUseCaseSpy)
    }
}

// MARK: - Stubs

private extension ListBreedsViewModelTests {
    static let breedStubs: [Breed] = [.init(name: "test", subBreeds: [])]
}

// MARK: - Test Doubles

final class GetDogBreedsUseCaseSpy: GetDogBreedsUseCaseable {
    var getDogBreedsCallCount = 0
    var getDogBreedsResult: Result<[Breed], Error> = .success([])
    
    func getDogBreeds() async throws -> [Breed] {
        getDogBreedsCallCount += 1
        return try getDogBreedsResult.get()
    }
}

extension ListBreedsViewModel.State: Equatable {
    public static func == (lhs: ListBreedsViewModel.State, rhs: ListBreedsViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.empty, .empty):
            return true
        case (.listBreeds(let lhs), .listBreeds(let rhs)):
            return lhs == rhs
        case (.error(let lhs), .error(let rhs)):
            return lhs as? AnyError == rhs as? AnyError
        default:
            return false
        }
    }
}
