//
//  APIClient.swift
//  DogListing
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import Foundation
import Networking

public protocol APIClient {
    func fetchDogBreeds() async throws -> DTO.ListResponse
    func getDogBreedRandomImageUrl(for breedName: String) async throws -> DTO.RandomImageResponse
}

public struct DogAPIClient: APIClient {
    let apiProvidable: ApiProvidable

    public init(apiProvidable: ApiProvidable) {
        self.apiProvidable = apiProvidable
    }
    
    public func fetchDogBreeds() async throws -> DTO.ListResponse {
        let endpoint = try DogEndpoint.list.buildRequest()
        return try await apiProvidable.call(request: endpoint)
    }

    public func getDogBreedRandomImageUrl(for breedName: String) async throws -> DTO.RandomImageResponse {
        let endpoint = try DogEndpoint.randomImage(breedName: breedName).buildRequest()
        return try await apiProvidable.call(request: endpoint)
    }
}
