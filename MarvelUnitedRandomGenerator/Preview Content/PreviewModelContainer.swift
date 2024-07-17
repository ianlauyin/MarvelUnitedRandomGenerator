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
    //Data testing for TeamDeck and Villain name generation crash
    context.insert(Villain(name: "TV1", figureContainer: "TV1"))
    context.insert(TeamDeck(name: "TV1", heroes: []))
    
    //Data testing for TeamDeck and Hero Relationship
    let heroes = [Hero(name: "TH1", teamDecks: [], figureContainer: "1"),
                  Hero(name: "TH2", teamDecks: [], figureContainer: "2"),
                  Hero(name: "TH3", teamDecks: [], figureContainer: "3"),
                  Hero(name: "TAH1", teamDecks: [], figureContainer: "1"),
                  Hero(name: "TAH2", teamDecks: [], figureContainer: "2")]
    
    let villains = [Villain(name: "TAH1", figureContainer: "1"),
                    Villain(name: "TAH2", figureContainer: "2")]
    
    let teamDecks = [TeamDeck(name: "T5", heroes: []),
                     TeamDeck(name: "T6", heroes: []),
                     TeamDeck(name: "T7", heroes: [])]
    
    heroes.forEach{context.insert($0)}
    villains.forEach{context.insert($0)}
    teamDecks.forEach{context.insert($0)}
    teamDecks[0].heroes = [heroes[0], heroes[2], heroes[3]]
    teamDecks[1].heroes = [heroes[0], heroes[1], heroes[3], heroes[4]]
    teamDecks[2].heroes = heroes
}

