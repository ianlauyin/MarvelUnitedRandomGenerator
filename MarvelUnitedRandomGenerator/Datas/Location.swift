//
//  Location.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import Foundation
import SwiftData

@Model
final class Location:HashableNamedData{
    @Attribute(.unique) var UUID : UUID
    @Attribute(.unique) var name: String
    var isHazardous : Bool
    var isUsed: Bool = false
        
    init(name: String, isHazardous:Bool) {
        self.name = name
        self.isHazardous = isHazardous
        self.UUID = Foundation.UUID()
    }
}
