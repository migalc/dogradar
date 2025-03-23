//
//  ApiProvider.swift
//  Networking
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import Foundation

public protocol ApiProvidable {
    func call(with request: URLRequest) async throws -> (Data, URLResponse)
    func call<T: Decodable>(with request: URLRequest, using decoder: JSONDecoder) async throws -> T
}
