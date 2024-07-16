//
//  GenerateUtil.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 16/7/2024.
//

import Foundation

func generateRandomGameMode(_ selection:[GameMode])throws->GameMode{
    guard selection.isEmpty else{
        throw GeneratorError.EmptySelectionError
    }
    return selection.randomElement()!
}
