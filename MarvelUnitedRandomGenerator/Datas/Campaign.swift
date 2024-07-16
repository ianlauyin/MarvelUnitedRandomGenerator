//
//  Campaign.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import Foundation
import SwiftData

@Model
final class Campaign:HashableNamedDataType{
    @Attribute(.unique) var UUID : UUID
    @Attribute(.unique) var name: String
    var isUsed: Bool = false
        
    subscript()->String{return "Campaign"}
    
    init(name: String) {
        self.name = name
        self.UUID = Foundation.UUID()
    }
}
