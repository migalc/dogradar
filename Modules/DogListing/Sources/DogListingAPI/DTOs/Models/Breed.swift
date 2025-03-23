//
//  Breed.swift
//  DogListing
//
//  Created by Miguel Alcantara on 23/03/2025.
//

public extension DTO {
    struct Breed: Codable, Equatable {
        public let name: String
        public let subBreeds: [String]

        public init(
            name: String,
            subBreeds: [String]
        ) {
            self.name = name
            self.subBreeds = subBreeds
        }
    }
}
