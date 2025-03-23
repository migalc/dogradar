//
//  Breeds.swift
//  DogListing
//
//  Created by Miguel Alcantara on 23/03/2025.
//

public extension DTO {
    struct Breeds: Equatable {
        public let breedList: [Breed]
        
        public init(breedList: [Breed]) {
            self.breedList = breedList
        }
    }
}

extension DTO.Breeds: Codable {
    enum CodingKeys: CodingKey {
        case breedList
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode([String: [String]].self)
        breedList = values.map { DTO.Breed(name: $0.key, subBreeds: $0.value) }
    }

    public func encode(to encoder: any Encoder) throws {
        var dict = [String: [String]]()
        for breed in breedList {
            dict.updateValue(breed.subBreeds, forKey: breed.name)
        }
        
        var container = encoder.singleValueContainer()
        try container.encode(dict)
    }
}
