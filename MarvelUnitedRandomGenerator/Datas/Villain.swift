//
//  Villain.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import Foundation
import SwiftData

@Model
final class Villain:Hashable{
    @Attribute(.unique) var UUID : UUID
    @Attribute(.unique) var name: String
    var figureContainer : String
    var isUsed: Bool = false
    var gameModeUsed :[GameMode] = []
        
    init(name: String,figureContainer:String) {
        self.name = name
        self.figureContainer = figureContainer
        self.UUID = Foundation.UUID()
    }
}
