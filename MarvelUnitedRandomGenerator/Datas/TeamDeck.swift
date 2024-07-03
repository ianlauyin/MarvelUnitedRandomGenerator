//
//  TeamDeck.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import SwiftData

@Model
final class TeamDeck{
    @Attribute(.unique) var name: String
    var isUsed: Bool = false
    
    @Relationship var heroes: [Hero]
        
    init(name: String, heroes :[Hero]) {
        self.name = name
        self.heroes = heroes
    }
}
