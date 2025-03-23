//
//  ApiEndpointTests.swift
//  Networking
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import Foundation
import Testing
import TestingUtils
@testable import Networking

struct ApiEndpointTests {
    private var urlRequestFactorySpy: URLRequestFactorySpy
    
    init() {
        self.urlRequestFactorySpy = URLRequestFactorySpy()
    }

    @Test("When factory returns valid result, buildRequest calls URLRequestFactory instance")
    func buildRequest_whenValidBaseUri_returnsUrlRequest() throws {
        let data = EndpointData(baseURI: "expectedBaseUri", path: "expectedPath", method: .post, headers: ["Authorization": "Bearer accessToken"])
        let expectedResult = URLRequest(url: URL(string: data.baseURI)!)
        let makeResult: Result<URLRequest, Error> = .success(expectedResult)
        urlRequestFactorySpy.makeResult = makeResult
        let result = try makeSUT(data: data).buildRequest(using: urlRequestFactorySpy)
        
        #expect(result == expectedResult)
        #expect(urlRequestFactorySpy.makeInputs.count == 1)
        let input = try #require(urlRequestFactorySpy.makeInputs.first)
        #expect(input.baseURI == data.baseURI)
        #expect(input.path == data.path)
        #expect(input.method == data.method)
        #expect(input.headers == data.headers)
    }

    @Test("When invalid baseURI is provided, throws error")
    func buildRequest_whenInvalidBaseUri_throwsError() throws {
        let data = EndpointData()
        urlRequestFactorySpy.makeResult = .failure(AnyError())
        
        #expect(throws: AnyError(),
                performing: { try makeSUT(data: data).buildRequest(using: urlRequestFactorySpy) })
        
        #expect(urlRequestFactorySpy.makeInputs.count == 1)
        let input = try #require(urlRequestFactorySpy.makeInputs.first)
        #expect(input.baseURI == data.baseURI)
        #expect(input.path == data.path)
        #expect(input.method == data.method)
        #expect(input.headers == data.headers)
    }
}

// MARK: - SUT

private extension ApiEndpointTests {
    func makeSUT(data: EndpointData) -> MockApiEndpoint {
        MockApiEndpoint(data: data)
    }
}

// MARK: - Test doubles

private final class URLRequestFactorySpy: URLRequestFactoryable {
    private(set) var makeInputs: [(baseURI: String, path: String?, method: HTTPMethod, headers: [String : String]?)] = []
    var makeResult: Result<URLRequest, Error> = .success(.init(url: .init(string: "make")!))

    func make(baseURI: String, path: String?, method: HTTPMethod, headers: [String : String]?) throws -> URLRequest {
        makeInputs.append((baseURI, path, method, headers))
        return try makeResult.get()
    }
}

private struct MockApiEndpoint: ApiEndpoint {
    let baseURI: String
    let path: String?
    let method: HTTPMethod
    let headers: [String : String]?
    
    init(data: EndpointData) {
        self.baseURI = data.baseURI
        self.path = data.path
        self.method = data.method
        self.headers = data.headers
    }
}
