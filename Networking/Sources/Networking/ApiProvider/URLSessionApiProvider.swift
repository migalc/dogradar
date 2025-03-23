//
//  URLSessionApiProvider.swift
//  Networking
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import Foundation

public protocol URLSessionable {
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}

public struct URLSessionApiProvider: ApiProvidable {
    private let session: URLSessionable
    
    public init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }

    public func call(with request: URLRequest) async throws -> (Data, URLResponse) {
        try await session.data(for: request, delegate: nil)
    }

    public func call<T>(with request: URLRequest, using decoder: JSONDecoder) async throws -> T where T : Decodable {
        let data = try await call(with: request).0
        return try decoder.decode(T.self, from: data)
    }
}

// MARK: - Default extension for native URLSession

extension URLSession: URLSessionable {}
