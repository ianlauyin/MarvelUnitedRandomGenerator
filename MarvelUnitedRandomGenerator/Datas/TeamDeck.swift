//
//  TeamDeck.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import Foundation
import SwiftData

@Model
final class TeamDeck:HashableNamedDataType{
    @Attribute(.unique) var UUID : UUID
    @Attribute(.unique) var name: String
    var isUsed: Bool = false
    
    @Relationship var heroes: [Hero]
        
    subscript()->String{return "Team Deck"}
    
    init(name: String, heroes :[Hero]) {
        self.name = name
        self.heroes = heroes
        self.UUID = Foundation.UUID()
    }
}
