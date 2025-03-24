//
//  DogListingRepository.swift
//  DogListing
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import DogListingAPI
import Foundation

protocol DogListingRepositoryable {
    func getDogBreeds() async throws -> [Breed]
    func getRandomImage(for breed: String) async throws -> URL
}

struct DogListingRepository: DogListingRepositoryable {
    // Local storage will come later
    let apiClient: APIClient

    func getDogBreeds() async throws -> [Breed] {
        try await apiClient.fetchDogBreeds()
            .message
            .breedList.map(\.toDomainModel)
    }

    func getRandomImage(for breed: String) async throws -> URL {
        try await apiClient.getDogBreedRandomImageUrl(for: breed)
            .message
    }
}

extension DTO.Breed {
    var toDomainModel: Breed {
        .init(name: name, subBreeds: subBreeds)
    }
}
