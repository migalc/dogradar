//
//  ApiProvider.swift
//  Networking
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import Foundation

public protocol ApiProvidable {
    func call(with request: URLRequest) async throws -> (Data, URLResponse)
}

public extension ApiProvidable {
    func call<T: Decodable>(request: URLRequest, using decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        let data = try await call(with: request).0
        return try decoder.decode(T.self, from: data)
    }
}
