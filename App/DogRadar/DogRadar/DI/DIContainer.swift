//
//  DIContainer.swift
//  DogRadar
//
//  Created by Miguel Alcantara on 24/03/2025.
//

import ListFeature
import Networking

struct DIContainer {
    static let shared = DIContainer()

    func configure() {
        ListFeature.DIContainer.shared.setApiProvider(Self.apiProvider)
    }
}

// MARK: - Networking

extension DIContainer {
    static let apiProvider = URLSessionApiProvider()
}

// MARK: - List

import DogListingCore
import SwiftUI

extension DIContainer {
    static func listView() -> some View {
        ListBreedsViewFactory.make(getBreedsUseCase: GetDogBreedsUseCaseFactory.make(apiProvidable: DIContainer.apiProvider))
    }
}
