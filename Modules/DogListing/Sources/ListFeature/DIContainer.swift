//
//  DIContainer.swift
//  DogListing
//
//  Created by Miguel Alcantara on 24/03/2025.
//

import DogListingCore

public final class DIContainer {
    private var apiProvidable: ApiProvidable!
    
    public init(apiProvidable: ApiProvidable? = nil) {
        self.apiProvidable = apiProvidable
    }
    
    public static let shared = DIContainer()

    public func setApiProvider(_ apiProvidable: ApiProvidable) {
        self.apiProvidable = apiProvidable
    }
}

// MARK: - Detail

extension DIContainer {
    var getRandomImageForBreedUseCase: GetRandomImageForBreedUseCaseable {
        GetRandomImageForBreedUseCaseFactory.make(apiProvidable: apiProvidable)
    }
}
