//
//  URLStubs.swift
//  SharedUtils
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import Foundation

// MARK: - Stubs

public extension URL {
    static var stub: URL { .init(string: "string")! }
}

public extension URLRequest {
    static var stub: URLRequest { .init(url: URL.stub) }
}

public extension URLResponse {
    static var stub: URLResponse {
        .init(url: URL.stub, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
}
