//
//  GetDogBreedsUseCase.swift
//  DogListing
//
//  Created by Miguel Alcantara on 23/03/2025.
//

public protocol GetDogBreedsUseCaseable {
    func getDogBreeds() async throws -> [Breed]
}

public struct GetDogBreedsUseCase: GetDogBreedsUseCaseable {
    let repository: DogListingRepositoryable
    
    public func getDogBreeds() async throws -> [Breed] {
        try await repository.getDogBreeds()
    }
}
