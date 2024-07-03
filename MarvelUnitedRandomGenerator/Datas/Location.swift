//
//  Location.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import SwiftData

@Model
final class Location{
    @Attribute(.unique) var name: String
    var isHazardous : Bool
    var isUsed: Bool = false
        
    init(name: String, isHazardous:Bool) {
        self.name = name
        self.isHazardous = isHazardous
    }
}
