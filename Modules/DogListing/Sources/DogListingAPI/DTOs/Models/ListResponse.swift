//
//  ListResponse.swift
//  DogListing
//
//  Created by Miguel Alcantara on 23/03/2025.
//

public extension DTO {
    struct ListResponse: Equatable {
        public let message: Breeds
        
        public init(breeds: Breeds) {
            self.message = breeds
        }
    }
}

extension DTO.ListResponse: Codable {
    enum CodingKeys: CodingKey {
        case message
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: DTO.ListResponse.CodingKeys.self)
        
        self.message = try container.decode(DTO.Breeds.self, forKey: DTO.ListResponse.CodingKeys.message)
    }
}
