//
//  Hero.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import Foundation
import SwiftData

@Model
final class Hero:Hashable,NamedData{
    @Attribute(.unique) let UUID : UUID
    @Attribute(.unique) var name: String
    var figureContainer : String
    var isUsed: Bool = false
    
    @Relationship(inverse: \TeamDeck.heroes) var teamDecks : [TeamDeck]
        
    init(name: String, teamDecks:[TeamDeck],figureContainer:String) {
        self.name = name
        self.teamDecks = teamDecks
        self.figureContainer = figureContainer
        self.UUID = Foundation.UUID()
    }
}
