//
//  URLRequestBuilder.swift
//  Networking
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import Foundation

struct URLRequestFactory: URLRequestFactoryable {
    init() { }

    func make(baseURI: String,
              path: String? = nil,
              method: HTTPMethod = .get,
              headers: [String : String]? = nil) throws -> URLRequest {
        guard var url = URL(string: baseURI) else {
            throw URLRequestFactoryError.invalidURI(baseURI)
        }

        if let path {
            url.appendPathComponent(path)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        return request
    }
}
