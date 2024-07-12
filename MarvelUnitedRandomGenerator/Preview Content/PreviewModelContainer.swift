//
//  PreviewModelSetUp.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 5/7/2024.
//

import Foundation
import SwiftData

func previewModelContainer() -> ModelContainer{
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Hero.self,Villain.self,Campaign.self,Companion.self,TeamDeck.self,Location.self, configurations: config)
    
    return container
}

func migrateSampleData(_ context:ModelContext){
    Data.allCases.forEach{data in
        data.migrateSampleData(context)
    }
}
