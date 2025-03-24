//
//  DogListingRepositoryTests.swift
//  DogListing
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import DogListingAPI
@testable import DogListingCore
import Foundation
import Testing
import TestingUtils

struct DogListingRepositoryTests {
    private var apiClientSpy: ApiClientSpy

    init() {
        self.apiClientSpy = ApiClientSpy()
    }
    
    // MARK: - fetchDogBreeds

    @Test("When fetches dog breeds succesfully, returns list of dog breeds")
    func fetchDogBreeds_whenSucceeds_returnsBreedList() async throws {
        let breedList: [DTO.Breed] = [
            .init(name: "dog1", subBreeds: []),
            .init(name: "dog2", subBreeds: ["subBreed1"]),
            .init(name: "dog3", subBreeds: ["subBreed1", "subBreed2", "subBreed3"])
        ]

        apiClientSpy.fetchDogBreedsResult = .success(DTO.ListResponse(breeds: .init(breedList: breedList)))
        let breeds = try await makeSUT().getDogBreeds()
        
        #expect(breeds == breedList.map(\.toDomainModel))
        #expect(apiClientSpy.fetchDogBreedsCallCount == 1)
    }

    @Test("When fetches dog breeds with error, returns error")
    func fetchDogBreeds_whenFails_throwsError() async throws {
        apiClientSpy.fetchDogBreedsResult = .failure(AnyError())
        
        await #expect(
            throws: AnyError(),
            performing: { try await makeSUT().getDogBreeds() })
        
        #expect(apiClientSpy.fetchDogBreedsCallCount == 1)
    }

    // MARK: - getDogBreedRandomImageUrl

    @Test("When fetches random breed image succesfully, returns image URL")
    func getDogBreedRandomImageUrl_whenSucceeds_returnsImageUrl() async throws {
        let expectedBreed = "expectedBreed"
        let expectedImageUrl = URL(string: "expectedImageUrl")!

        apiClientSpy.getDogBreedRandomImageUrlResult = .success(DTO.RandomImageResponse(message: expectedImageUrl))
        let result = try await makeSUT().getRandomImage(for: expectedBreed)
        
        #expect(result == expectedImageUrl)
        #expect(apiClientSpy.getDogBreedRandomImageUrlInputs == [expectedBreed])
    }

    @Test("When fetches random breed image with error, returns error")
    func getDogBreedRandomImageUrl_whenFails_throwsError() async throws {
        let expectedBreed = "expectedBreed"
        
        apiClientSpy.getDogBreedRandomImageUrlResult = .failure(AnyError())
        
        await #expect(
            throws: AnyError(),
            performing: { try await makeSUT().getRandomImage(for: expectedBreed) })
        
        #expect(apiClientSpy.getDogBreedRandomImageUrlInputs == [expectedBreed])
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
    
    var getDogBreedRandomImageUrlInputs: [String] = []
    var getDogBreedRandomImageUrlResult: Result<DTO.RandomImageResponse, Error> = .failure(AnyError())

    func getDogBreedRandomImageUrl(for breedName: String) async throws -> DTO.RandomImageResponse {
        getDogBreedRandomImageUrlInputs.append(breedName)
        return try getDogBreedRandomImageUrlResult.get()
    }
}
