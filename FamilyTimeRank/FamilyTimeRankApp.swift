//
//  FamilyTimeRankApp.swift
//  FamilyTimeRank
//
//  Created by 厳恒 on 2026/01/04.
//

import FirebaseCore
import SwiftUI

@main
struct FamilyTimeRankApp: App {
    @UIApplicationDelegateAdaptor(FirebaseAppDelegate.self)
    var appDelegate

    let dependencyContainer: DependencyContainer

    init() {
        FirebaseApp.configure()
        dependencyContainer = DependencyContainer(
            source: .firestore(familyId: "UdtTpJWvHBQAvKEte7Eg")
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(dependencyContainer: dependencyContainer)
        }
    }
}
