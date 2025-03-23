//
//  URLSessionApiProviderTests.swift
//  Networking
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import Foundation
@testable import Networking
import Testing
import TestingUtils

struct URLSessionApiProviderTests {
    private var urlSessionSpy: URLSessionSpy

    init() {
        self.urlSessionSpy = URLSessionSpy()
    }

    @Test("When URLSession implementation returns valid data and response, ApiProvidable propagates those fields")
    func call_whenUrlSessionReturnsValidDataAndResponse_urlSessionIsCalledAndDataPropagated() async throws {
        let expectedUrl = URL(string: "url")!
        let expectedUrlRequest = URLRequest(url: expectedUrl)
        let expectedData = "expectedData".data(using: .utf8)!
        let expectedResponse = URLResponse(url: expectedUrl, mimeType: "mimeType", expectedContentLength: 123, textEncodingName: "textEncodingName")
        urlSessionSpy.dataResult = .success((expectedData, expectedResponse))
        let result = try await makeSUT().call(with: expectedUrlRequest)
        
        #expect(result.0 == expectedData)
        #expect(result.1 == expectedResponse)

        #expect(urlSessionSpy.dataInputs == [expectedUrlRequest])
    }
    
    @Test("When URLSession implementation throws error, ApiProvidable propagates error")
    func call_whenUrlSessionReturnsValidDataAndResponse_throwsError() async throws {
        let expectedUrlRequest = URLRequest(url: .stub)
        urlSessionSpy.dataResult = .failure(AnyError())

        await #expect(
            throws: AnyError(),
            performing: { try await makeSUT().call(with: expectedUrlRequest) }
        )

        #expect(urlSessionSpy.dataInputs == [expectedUrlRequest])
    }

}

// MARK: - SUT

private extension URLSessionApiProviderTests {
    func makeSUT() -> URLSessionApiProvider {
        URLSessionApiProvider(session: urlSessionSpy)
    }
}

// MARK: - Stubs

private extension URL {
    static var stub: URL { .init(string: "string")! }
}

private extension URLRequest {
    static var stub: URLRequest { .init(url: URL.stub) }
}

private extension URLResponse {
    static var stub: URLResponse {
        .init(url: URL.stub, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
}

// MARK: - Test doubles

private final class URLSessionSpy: URLSessionable {
    private(set) var dataInputs: [URLRequest] = []
    var dataResult: Result<(Data, URLResponse), Error> = .success((Data(), .stub))

    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        dataInputs.append(request)
        return try dataResult.get()
    }
}
