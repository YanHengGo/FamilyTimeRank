//
//  FamilyTimeRankApp.swift
//  FamilyTimeRank
//
//  Created by 厳恒 on 2026/01/04.
//

import SwiftUI

@main
struct FamilyTimeRankApp: App {
    @UIApplicationDelegateAdaptor(FirebaseAppDelegate.self)
    var appDelegate

    private let dependencyContainer = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            ContentView(dependencyContainer: dependencyContainer)
        }
    }
}
