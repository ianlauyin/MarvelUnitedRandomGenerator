//
//  Companion.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import Foundation
import SwiftData

@Model
final class Companion:HashableNamedDataType{
    @Attribute(.unique) var UUID : UUID
    @Attribute(.unique) var name: String
    var isUsed: Bool = false
        
    init(name: String) {
        self.name = name
        self.UUID = Foundation.UUID()
    }
}
