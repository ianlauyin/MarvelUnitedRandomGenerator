//
//  Hero.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import SwiftData

@Model
final class Hero{
    @Attribute(.unique) var name: String
    var isUsed: Bool = false
    
    @Relationship(inverse: \TeamDeck.heroes) var teamDecks : [TeamDeck]
        
    init(name: String, teamDecks:[TeamDeck]) {
        self.name = name
        self.teamDecks = teamDecks
    }
}
