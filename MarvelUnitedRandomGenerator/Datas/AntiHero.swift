//
//  AntiHero.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import SwiftData

@Model
final class AntiHero{
    var name: String
    var isUsedAsHero: Bool = false
    var isUsedAsVillain : Bool = false
        
    init(name: String) {
        self.name = name
    }
}

