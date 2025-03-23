//
//  DogListingRepository.swift
//  DogListing
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import DogListingAPI

protocol DogListingRepositoryable {
    func getDogBreeds() async throws -> [Breed]
}

struct DogListingRepository: DogListingRepositoryable {
    // Local storage will come later
    let apiClient: APIClient

    func getDogBreeds() async throws -> [Breed] {
        try await apiClient.fetchDogBreeds()
            .message
            .breedList.map(\.toDomainModel)
    }
}

extension DTO.Breed {
    var toDomainModel: Breed {
        .init(name: name, subBreeds: subBreeds)
    }
}
