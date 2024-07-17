//
//  GenerateUtil.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 16/7/2024.
//

import Foundation
import SwiftData

func generateRandomGameMode(_ selection:[GameMode])throws->GameMode?{
    guard !selection.isEmpty else{
        throw GeneratorError.SelectionCountError
    }
    let selectionWithNone : [GameMode?] = selection + [nil]
    return selectionWithNone.randomElement()!
}

func generateRandomList<T:HashableNamedDataType>(_ context: ModelContext, count:Int, list: [T], includeUsed: Bool = true)throws->[T]{
    var results : [T] = []
    if list.count < count {
        throw GeneratorError.SelectionCountError
    }
    var filteredSelection = includeUsed ? list : list.filter{ !$0.isUsed }
    while results.count < count{
        let repeatedCount = getRepeatedCount(filteredSelection.map{$0.name},results.map{$0.name})
        if !includeUsed && filteredSelection.count == repeatedCount{
            resetIsUsed(list: list)
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

    let fetchedItems:[Companion] = try fetchList(context,predicate: #Predicate{!$0.isUsed})
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

func generateRandomHeroes(_ context:ModelContext, count: Int, list: [Hero], includeCompanion: Bool = false)throws -> [HeroResult]{
    let heroCount = count == 1 ? 5 : count
    if list.count < heroCount{
        throw GeneratorError.SelectionCountError
    }
    let heroes = try generateRandomList(context, count: heroCount, list: list )
    
    var results : [HeroResult] = []
    if count == 1 {
        let firstHeroResult = try convertingHeroIntoHeroResult(context, hero: heroes[0], includeCompanion: includeCompanion)
        results.append(firstHeroResult)
        for hero in heroes[1..<heroes.count]{
            results.append(HeroResult(name: hero.name))
        }
        return results
    }
    
    for hero in heroes{
            let companionList = results.compactMap{$0.companion}
            var result = try convertingHeroIntoHeroResult(context, hero: hero, includeCompanion: includeCompanion)
            while result.companion != nil && companionList.contains(result.companion!){
                result = try convertingHeroIntoHeroResult(context, hero: hero, includeCompanion: includeCompanion)
            }
            results.append(result)
    }
    return results
}


func convertingHeroIntoHeroResult(_ context:ModelContext,hero:Hero,includeCompanion:Bool = false)throws->HeroResult{
    let companion : Companion? = includeCompanion ? try generateRandomCompanion(context, heroName: hero.name) : nil
    return HeroResult(name: hero.name,figureContainer: hero.figureContainer, useEquipment: Bool.random(), companion: companion?.name)
}

func generateTeamDeckHeroes(_ context:ModelContext, count: Int, list: [TeamDeck], includeCompanion:Bool = false)throws -> TeamDeckResult{
    guard list.count > 0 else{
        throw GeneratorError.SelectionCountError
    }
    let teamDeck = list.randomElement()
    do{
        let heroes = try generateRandomHeroes(context, count: count, list: teamDeck!.heroes, includeCompanion: includeCompanion)
        teamDeck?.isUsed = true
        return TeamDeckResult(teamDeck:teamDeck!.name,heroResults: heroes)
    }catch{
        throw GeneratorError.TeamDeckNotEnoughError("\(teamDeck!.name) do not have enough heroes")
    }
}

//func generatePlay(_ context:ModelContext)throws->PlayResult{
//    let opponent = try generateOpponent(context)
//    let playerCount = (1...4).randomElement()
//    if let opponent = opponent as? Campaign{
//        return PlayResult(isCampaign: true, name: opponent.name, playerCount: playerCount!)
//    }else{
//        let gameMode = try generateRandomGameMode(GameMode.allCases, includeNone: true)
//    }
//}

func generateOpponent(_ context:ModelContext)throws -> any HashableNamedDataType{
    let villains = try fetchList(context,predicate: #Predicate{!$0.isUsed}) as [Villain]
    let campaigns = try fetchList(context,predicate: #Predicate{!$0.isUsed}) as [Campaign]
    let opponents : [any HashableNamedDataType] = villains + campaigns
    guard opponents.isEmpty else{
        try resetAllIsUsed(context, T: Villain.self)
        try resetAllIsUsed(context, T: Campaign.self)
        return try generateOpponent(context)
    }
    return opponents.randomElement()!
}
