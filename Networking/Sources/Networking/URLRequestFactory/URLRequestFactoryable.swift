//
//  URLRequestFactoryable.swift
//  Networking
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import Foundation

public protocol URLRequestFactoryable {
    func make(baseURI: String,
                      path: String?,
                      method: HTTPMethod,
                      headers: [String : String]?) throws -> URLRequest
}
