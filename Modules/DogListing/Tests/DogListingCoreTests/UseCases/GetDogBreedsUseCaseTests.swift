//
//  DogListingRepositoryTests.swift
//  DogListing
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import DogListingAPI
@testable import DogListingCore
import Testing
import TestingUtils

struct GetDogBreedsUseCaseTests {
    private var repositorySpy: DogListingRepositorySpy

    init() {
        self.repositorySpy = DogListingRepositorySpy()
    }

    @Test("When fetches succesfully, returns list of dog breeds")
    func fetchDogBreeds_whenSucceeds_returnsBreedList() async throws {
        let expectedBreedList: [Breed] = [
            .init(name: "dog1", subBreeds: []),
            .init(name: "dog2", subBreeds: ["subBreed1"]),
            .init(name: "dog3", subBreeds: ["subBreed1", "subBreed2", "subBreed3"])
        ]

        repositorySpy.getDogBreedsResult = .success(expectedBreedList)
        let breeds = try await makeSUT().getDogBreeds()
        
        #expect(breeds == expectedBreedList)
    }

    @Test("When fetches with error, returns error")
    func fetchDogBreeds_whenFails_throwsError() async throws {
        repositorySpy.getDogBreedsResult = .failure(AnyError())
        
        await #expect(
            throws: AnyError(),
            performing: { try await makeSUT().getDogBreeds() })
    }
}

// MARK: - SUT

private extension GetDogBreedsUseCaseTests {
    func makeSUT() -> GetDogBreedsUseCase {
        GetDogBreedsUseCase(repository: repositorySpy)
    }
}

// MARK: - Test doubles

private final class DogListingRepositorySpy: DogListingRepositoryable {
    var getDogBreedsCallCount = 0
    var getDogBreedsResult: Result<[Breed], Error> = .success([])
    
    func getDogBreeds() async throws -> [Breed] {
        getDogBreedsCallCount += 1
        return try getDogBreedsResult.get()
    }
}
