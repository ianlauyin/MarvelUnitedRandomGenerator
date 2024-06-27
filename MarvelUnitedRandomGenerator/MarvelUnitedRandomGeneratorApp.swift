//
//  MarvelUnitedRandomGeneratorApp.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 27/6/2024.
//

import SwiftUI
import SwiftData

@main
struct MarvelUnitedRandomGeneratorApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
