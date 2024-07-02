//
//  ModelContainerHandler.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import Foundation
import SwiftData

func ModelContainerHandler(_ schema:Array<any PersistentModel.Type>)->ModelContainer{
    let schema = Schema(schema)
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}
