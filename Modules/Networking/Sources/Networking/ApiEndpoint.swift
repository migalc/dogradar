//
//  ApiEndpoint.swift
//  Networking
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import Foundation

public protocol ApiEndpoint {
    var baseURI: String { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
}

public extension ApiEndpoint {
    func buildRequest(using factory: URLRequestFactoryable? = nil) throws -> URLRequest {
        try (factory ?? URLRequestFactory())
            .make(
                baseURI: baseURI,
                path: path,
                method: method,
                headers: headers
            )
    }
}
