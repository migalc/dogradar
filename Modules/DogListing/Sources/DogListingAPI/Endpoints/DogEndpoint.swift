//
//  DogEndpoint.swift
//  DogListing
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import Foundation
import Networking

enum DogEndpoint: ApiEndpoint {
    case list
    case randomImage(breedName: String)

    var baseURI: String {
        "https://dog.ceo/api"
    }
    
    var method: HTTPMethod {
        .get
    }

    var path: String? {
        switch self {
        case .list:
            return "breeds/list/all"
        case .randomImage(let breedName):
            return "breed/\(breedName)/images/random"
        }
    }

    var headers: [String : String]? {
        nil
    }
}
