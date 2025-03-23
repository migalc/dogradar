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

struct DogListingRepositoryTests {
    private var apiClientSpy: ApiClientSpy

    init() {
        self.apiClientSpy = ApiClientSpy()
    }

    @Test("When fetches succesfully, returns list of dog breeds")
    func fetchDogBreeds_whenSucceeds_returnsBreedList() async throws {
        let breedList: [DTO.Breed] = [
            .init(name: "dog1", subBreeds: []),
            .init(name: "dog2", subBreeds: ["subBreed1"]),
            .init(name: "dog3", subBreeds: ["subBreed1", "subBreed2", "subBreed3"])
        ]

        apiClientSpy.fetchDogBreedsResult = .success(DTO.ListResponse(breeds: .init(breedList: breedList)))
        let breeds = try await makeSUT().getDogBreeds()
        
        #expect(breeds == breedList.map(\.toDomainModel))
    }

    @Test("When fetches with error, returns error")
    func fetchDogBreeds_whenFails_throwsError() async throws {
        apiClientSpy.fetchDogBreedsResult = .failure(AnyError())
        
        await #expect(
            throws: AnyError(),
            performing: { try await makeSUT().getDogBreeds() })
    }
}

// MARK: - SUT

private extension DogListingRepositoryTests {
    func makeSUT() -> DogListingRepository {
        DogListingRepository(apiClient: apiClientSpy)
    }
}

// MARK: - Test doubles

private final class ApiClientSpy: APIClient {
    var fetchDogBreedsCallCount = 0
    var fetchDogBreedsResult: Result<DTO.ListResponse, Error> = .failure(AnyError())
    
    func fetchDogBreeds() async throws -> DTO.ListResponse {
        fetchDogBreedsCallCount += 1
        return try fetchDogBreedsResult.get()
    }
}
