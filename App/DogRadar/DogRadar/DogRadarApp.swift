//
//  DogRadarApp.swift
//  DogRadar
//
//  Created by Miguel Alcantara on 23/03/2025.
//

import SwiftUI
import DogListingCore
import ListFeature

@main
struct DogRadarApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            DIContainer.listView()
        }
    }
}
