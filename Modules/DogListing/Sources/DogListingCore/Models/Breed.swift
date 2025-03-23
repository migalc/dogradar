//
//  Breed.swift
//  DogListing
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import Foundation

public struct Breed: Codable, Equatable, Sendable {
    public let name: String
    public let subBreeds: [String]
}
