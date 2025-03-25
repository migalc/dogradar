//
//  URLRequestFactoryTests.swift
//  Networking
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import Foundation
@testable import Networking
import Testing

struct URLRequestFactoryTests {
    @Test(
        "When valid data is provided, Factory returns built URLRequest",
        arguments: [
            EndpointData(baseURI: "expectedBaseUri"),
            EndpointData(baseURI: "expectedBaseUri", path: "expectedPath"),
            EndpointData(baseURI: "expectedBaseUri", path: "expectedPath", method: .post),
            EndpointData(baseURI: "expectedBaseUri", path: "expectedPath", method: .post, headers: ["Authorization": "Bearer accessToken"])
        ]
    )
    func make_whenValidDataProvided_returnsURLRequest(data: EndpointData) throws {
        let result = try makeSUT().make(
            baseURI: data.baseURI,
            path: data.path,
            method: data.method,
            headers: data.headers
        )
        var urlComponents = try #require(URLComponents(string: data.baseURI))
        if let path = data.path {
            urlComponents.path += "/\(path)"
        }
        let expectedURL = try #require(urlComponents.url)
        #expect(result.url == expectedURL)
        #expect(result.httpMethod == data.method.rawValue)
        #expect(result.allHTTPHeaderFields == (data.headers != nil ? data.headers : [:]))
    }
    
    @Test("When invalid baseURI is provided, throws error")
    func buildRequest_whenInvalidBaseUri_throwsError() throws {
        let baseURI = ""
        let sut = makeSUT()
        #expect(
            throws: URLRequestFactoryError.invalidURI(baseURI),
            performing: { try sut.make(baseURI: baseURI) }
        )
    }
}

// MARK: - SUT

private extension URLRequestFactoryTests {
    func makeSUT() -> URLRequestFactory {
        .init()
    }
}
