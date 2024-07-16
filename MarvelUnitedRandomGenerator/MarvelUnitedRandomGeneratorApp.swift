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
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(for: Data.allCases.compactMap{data in data.modelType})
        }
    }
}
