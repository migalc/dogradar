//
//  AppDelegate.swift
//  DogRadar
//
//  Created by Miguel Alcantara on 24/03/2025.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        DIContainer.shared.configure()
        return true
    }
}
