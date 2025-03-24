//
//  DogListingRepositorySpy.swift
//  DogListing
//
//  Created by Miguel Alcantara on 24/03/2025.
//

@testable import DogListingCore
import Foundation

final class DogListingRepositorySpy: DogListingRepositoryable {
    var getDogBreedsCallCount = 0
    var getDogBreedsResult: Result<[Breed], Error> = .success([])
    
    func getDogBreeds() async throws -> [Breed] {
        getDogBreedsCallCount += 1
        return try getDogBreedsResult.get()
    }
    
    var getRandomImageInputs = [String]()
    var getRandomImageResult: Result<URL, Error> = .success(URL(string: "string")!)

    func getRandomImage(for breed: String) async throws -> URL {
        getRandomImageInputs.append(breed)
        return try getRandomImageResult.get()
    }
}
