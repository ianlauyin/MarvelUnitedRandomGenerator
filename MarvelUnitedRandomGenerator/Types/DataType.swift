//
//  Data.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 10/7/2024.
//

import Foundation
import SwiftData

protocol NamedDataType{
    var UUID: UUID { get }
    var name: String { get set}
}

protocol HashableNamedDataType: PersistentModel, NamedDataType, Hashable {}
