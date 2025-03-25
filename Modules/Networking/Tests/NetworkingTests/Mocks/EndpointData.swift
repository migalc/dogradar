//
//  EndpointData.swift
//  Networking
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import Networking

struct EndpointData : Sendable {
    let baseURI: String
    let path: String?
    let method: HTTPMethod
    let headers: [String : String]?

    init(baseURI: String = "baseURI",
         path: String? = nil,
         method: HTTPMethod = .get,
         headers: [String : String]? = nil) {
        self.baseURI = baseURI
        self.path = path
        self.method = method
        self.headers = headers
    }
}
