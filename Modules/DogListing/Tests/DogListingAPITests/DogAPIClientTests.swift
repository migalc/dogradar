//
//  Test.swift
//  DogListing
//
//  Created by Miguel Alcantara on 23/03/2025.
//

@testable import DogListingAPI
import Networking
import Testing
import TestingUtils

struct DogAPIClientTests {
    var apiProvidableSpy: ApiProvidableSpy

    init() {
        self.apiProvidableSpy = ApiProvidableSpy()
    }

    @Test("When called and API client returns data, then returns a list of breeds")
    func test_fetchDogBreeds_whenValidData_returnsList() async throws {
        let expectedResult = DTO.ListResponse(
            breeds: .init(
                breedList: [
                    .init(name: "dog1", subBreeds: []),
                    .init(name: "dog2", subBreeds: ["subbreed1"]),
                    .init(name: "dog3", subBreeds: ["subbreed1", "subbreed2", "subbreed3"]),
                ]
            )
        )
        let encoded = try JSONEncoder().encode(expectedResult)
        apiProvidableSpy.callResult = .success((encoded, .stub))
        let apiClient = makeSUT()
        let result = try await apiClient.fetchDogBreeds()
        
        #expect(result.message.breedList.sorted(by: { $0.name < $1.name }) == expectedResult.message.breedList)
    }

    @Test("When called and API client throws error, then error is propagated")
    func test_fetchDogBreeds_whenThrowsError_throwsError() async throws {
        apiProvidableSpy.callResult = .failure(AnyError())
        
        await #expect(
            throws: AnyError(),
            performing: { try await makeSUT().fetchDogBreeds() }
        )
    }
}

// MARK: - SUT

private extension DogAPIClientTests {
    func makeSUT() -> DogAPIClient {
        DogAPIClient(apiProvidable: apiProvidableSpy)
    }
}

// MARK: - Test doubles

import Foundation

final class ApiProvidableSpy: ApiProvidable {
    private(set) var callInputs = [URLRequest]()
    var callResult: Result<(Data, URLResponse), Error> = .success((Data(), .stub))
    
    func call(with request: URLRequest) async throws -> (Data, URLResponse) {
        callInputs.append(request)
        return try callResult.get()
    }
}
