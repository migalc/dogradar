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
}

public struct DogAPIClient: APIClient {
    let apiProvidable: ApiProvidable
    
    public func fetchDogBreeds() async throws -> DTO.ListResponse {
        let endpoint = try DogEndpoint.list.buildRequest()
        return try await apiProvidable.call(request: endpoint)
    }
}
