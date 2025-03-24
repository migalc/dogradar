//
//  GetRandomImageForBreedUseCase.swift
//  DogListing
//
//  Created by Miguel Alcantara on 24/03/2025.
//

import Foundation
import Networking
import DogListingAPI

public protocol GetRandomImageForBreedUseCaseable {
    func getRandomImage(for breed: String) async throws -> URL
}

public struct GetRandomImageForBreedUseCase: GetRandomImageForBreedUseCaseable {
    let repository: DogListingRepositoryable
    
    public func getRandomImage(for breed: String) async throws -> URL {
        try await repository.getRandomImage(for: breed)
    }
}

public struct GetRandomImageForBreedUseCaseFactory {
    public static func make(apiProvidable: ApiProvidable) -> GetRandomImageForBreedUseCaseable {
        let apiClient = DogAPIClient(apiProvidable: apiProvidable)
        let repository = DogListingRepository(apiClient: apiClient)
        return GetRandomImageForBreedUseCase(repository: repository)
    }
}
