//
//  GenerateUtil.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 16/7/2024.
//

import Foundation
import SwiftData

func generateRandomGameMode(_ selection:[GameMode])throws->GameMode{
    guard selection.isEmpty else{
        throw GeneratorError.SelectionCountError
    }
    return selection.randomElement()!
}

func generateRandomList<T:HashableNamedDataType>(_ context:ModelContext, count:Int, list: inout [T], includeUsed: Bool = true)throws->[T]{
    var results : [T] = []
    if list.count < count {
        throw GeneratorError.SelectionCountError
    }
    var filteredSelection = includeUsed ? list : list.filter{ !$0.isUsed }
    while results.count < count{
        let repeatedCount = getRepeatedCount(filteredSelection.map{$0.name},results.map{$0.name})
        if !includeUsed && filteredSelection.count == repeatedCount{
            resetIsUsed(context, list: &list)
            filteredSelection = list
        }
        let randomInt = Int.random(in: 0..<filteredSelection.count)
        let randomData = filteredSelection[randomInt]
        if results.contains(where: {$0.UUID == randomData.UUID}){
            continue
        }
        if !includeUsed{
            var usedItem = list.first{$0.UUID == randomData.UUID}
            usedItem?.isUsed = true
        }
        results.append(randomData)
        filteredSelection.remove(at: randomInt)
    }
    return results
}


