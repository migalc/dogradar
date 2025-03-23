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

    var baseURI: String {
        "https://dog.ceo/api/breeds"
    }
    
    var method: HTTPMethod {
        .get
    }

    var path: String? {
        switch self {
            case .list:
            return "list/all"
        }
    }

    var headers: [String : String]? {
        nil
    }
}
