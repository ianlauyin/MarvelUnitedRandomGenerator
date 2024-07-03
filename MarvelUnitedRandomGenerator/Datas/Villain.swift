//
//  Villain.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import SwiftData

@Model
final class Villain{
    @Attribute(.unique) var name: String
    var isUsed: Bool = false
        
    init(name: String) {
        self.name = name
    }
}
