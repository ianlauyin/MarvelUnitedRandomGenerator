//
//  Item.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 27/6/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
