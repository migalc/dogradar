//
//  RandomImageResponse.swift
//  DogListing
//
//  Created by Miguel Alcantara on 24/03/2025.
//

import Foundation

public extension DTO {
    struct RandomImageResponse: Codable, Equatable {
        public let message: URL

        public init(message: URL) {
            self.message = message
        }
    }
}
