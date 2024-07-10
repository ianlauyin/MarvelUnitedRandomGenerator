//
//  Data.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 10/7/2024.
//

import Foundation
import SwiftData

protocol NamedData{
    var name: String { get }
}

protocol HashableNamedData: PersistentModel, NamedData, Hashable {}
