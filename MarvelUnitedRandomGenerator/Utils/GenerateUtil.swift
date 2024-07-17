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

func generateRandomList<T:HashableNamedDataType>(_ context:ModelContext, count:Int, list: [T], includeUsed: Bool = true)throws->[T]{
    var results : [T] = []
    if list.count < count {
        throw GeneratorError.SelectionCountError
    }
    var filteredSelection = includeUsed ? list : list.filter{ !$0.isUsed }
    while results.count < count{
        let repeatedCount = getRepeatedCount(filteredSelection.map{$0.name},results.map{$0.name})
        if !includeUsed && filteredSelection.count == repeatedCount{
            resetIsUsed(context, list: list)
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

func generateRandomCompanion(_ context:ModelContext, heroName:String)throws->Companion?{
    if Bool.random(){
        return nil
    }
    
    let fetchDescriptor = FetchDescriptor<Companion>(predicate: #Predicate{!$0.isUsed})
    let fetchedItems:[Companion] = try context.fetch(fetchDescriptor)
    if fetchedItems.isEmpty{
        try resetAllIsUsed(context, T:Companion.self)
        return try generateRandomCompanion(context,heroName:heroName)
    }
    let companion = fetchedItems[Int.random(in: 0..<fetchedItems.count)]
    if (heroName == "Gwenpool" && companion.name != "Jeff") || (heroName == "Kitty Pryde" && companion.name != "Lockheed"){
        if fetchedItems.count == 1{
            return try generateRandomCompanion(context,heroName:heroName)
        }
    }
    companion.isUsed = true
    return companion
}

//func generateRandomHeroesWithCompanion(_ context:ModelContext, count: Int, list: inout [Hero])throws -> [HeroResult]{
//    var results : [HeroResult] = []
//        let targetCount = playerCount == 1 ? 5 : playerCount
//        if selection.count < targetCount{
//            AlertHandler.shared.showMessage("Not Enough Hero")
//            return
//        }
//    return results
//}
