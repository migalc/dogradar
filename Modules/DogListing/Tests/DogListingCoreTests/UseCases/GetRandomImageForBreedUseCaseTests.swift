//
//  GetRandomImageForBreedUseCaseTests.swift
//  DogListing
//
//  Created by Miguel Alcantara on 24/03/2025.
//

import Foundation
@testable import DogListingCore
import Testing
import TestingUtils

struct GetRandomImageForBreedUseCaseTests {
    private var repositorySpy: DogListingRepositorySpy

    init() {
        self.repositorySpy = DogListingRepositorySpy()
    }

    @Test("When fetches succesfully, returns list of dog breeds")
    func getRandomImage_whenSucceeds_returnsImageUrl() async throws {
        let expectedBreed = "expectedBreed"
        let expectedImageUrl = URL(string: "expectedImageUrl")!

        repositorySpy.getRandomImageResult = .success(expectedImageUrl)
        let imageUrl = try await makeSUT().getRandomImage(for: expectedBreed)
        
        #expect(imageUrl == expectedImageUrl)
        #expect(repositorySpy.getRandomImageInputs == [expectedBreed])
    }

    @Test("When fetches with error, returns error")
    func fetchDogBreeds_whenFails_throwsError() async throws {
        let expectedBreed = "expectedBreed"
        repositorySpy.getRandomImageResult = .failure(AnyError())
        
        await #expect(
            throws: AnyError(),
            performing: { try await makeSUT().getRandomImage(for: expectedBreed) })
        
        #expect(repositorySpy.getRandomImageInputs == [expectedBreed])
    }
}

// MARK: - SUT

private extension GetRandomImageForBreedUseCaseTests {
    func makeSUT() -> GetRandomImageForBreedUseCase {
        GetRandomImageForBreedUseCase(repository: repositorySpy)
    }
}
