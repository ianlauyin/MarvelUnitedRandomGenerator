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

func generateRandomList<T:HashableNamedDataType>(_ list:[T], count:Int, usedAfterDraw: Bool = true)throws->[T]{
    var results : [T] = []
    if list.count < count {
        throw GeneratorError.SelectionCountError
    }
    var filteredList = usedAfterDraw ? list.filter{ !$0.isUsed } : list
    
    while results.count < count{
        let repeatedCount = getRepeatedCount(filteredList.map{$0.name},results.map{$0.name})
        if usedAfterDraw && filteredList.count == repeatedCount{
            resetIsUsed(list: list)
            filteredList = list
        }
        let randomInt = Int.random(in: 0..<filteredList.count)
        let randomData = filteredList[randomInt]
        if results.contains(where: {$0.UUID == randomData.UUID}){
            continue
        }
        if usedAfterDraw{
            var usedItem = list.first{$0.UUID == randomData.UUID}
            usedItem?.isUsed = true
        }
        results.append(randomData)
        filteredList.remove(at: randomInt)
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

func generateRandomHeroes(_ context:ModelContext, count: Int, list: [Hero], includeCompanion: Bool = false, excludeHeroes:[String] = [])throws -> [HeroResult]{
    let heroCount = count == 1 ? 5 : count
    let filterList = list.filter{!excludeHeroes.contains($0.name)}
    
    if filterList.count < heroCount{
        throw GeneratorError.SelectionCountError
    }
    let heroes = try generateRandomList(filterList, count: heroCount)
    
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


func generateTeamDeckHeroes(_ context:ModelContext, count: Int, list: [TeamDeck], includeCompanion:Bool = false,excludeHeroes:[String] = [])throws -> TeamDeckResult{
    guard list.count > 0 else{
        throw GeneratorError.SelectionCountError
    }
    let teamDeckWithNone = list + [nil]
    let teamDeck = teamDeckWithNone.randomElement()!
    do{
        if let teamDeck = teamDeck{
            let heroResults = try generateRandomHeroes(context, count: count, list: teamDeck.heroes, includeCompanion: includeCompanion, excludeHeroes: excludeHeroes)
            teamDeck.isUsed = true
            return TeamDeckResult(teamDeck:teamDeck.name,heroResults: heroResults)
        }else{
            let heroList = try fetchList(context) as [Hero]
            let heroResults = try generateRandomHeroes(context, count: count, list: heroList, excludeHeroes: excludeHeroes)
            return TeamDeckResult(teamDeck: "No Team", heroResults: heroResults)
        }
    }catch{
        throw GeneratorError.TeamDeckNotEnoughError("\(teamDeck!.name) do not have enough heroes")
    }
}

func generatePlay(_ context:ModelContext)throws->PlayResult{
    
    var opponent = try generateOpponent(context)
    let playerCount = (1...4).randomElement()
    do{
        if let opponent = opponent as? Campaign{
            return PlayResult(isCampaign: true, name: opponent.name, playerCount: playerCount!)
        }else if let opponent = opponent as? Villain{
            return try generatePlayVillainResult(context,opponent: opponent,count: playerCount!)
        }else{
            throw GeneratorError.TypeError
        }
    }catch{
        opponent.isUsed = false
        throw error
    }
    
    func generatePlayVillainResult(_ context:ModelContext, opponent: Villain, count : Int)throws -> PlayResult{
        let gameMode = try generateRandomGameMode(GameMode.allCases)
        if let gameMode = gameMode,
           gameMode.excludeVillain.contains(opponent.name){
            throw GeneratorError.RepeatedCharaterError
        }
        let teamDeckList = try fetchList(context) as [TeamDeck]
        let excludeHeroList = (gameMode?.excludeHeroes ?? []) + [opponent.name]
        let teamDeckWithHero = try generateTeamDeckHeroes(context, count: count, list: teamDeckList, includeCompanion: true,excludeHeroes: excludeHeroList)
        return PlayResult(isCampaign: false, name: opponent.name, playerCount: count , opponentContainer: opponent.figureContainer, gameMode: gameMode, teamDeck: teamDeckWithHero.teamDeck, heroResults: teamDeckWithHero.heroResults)
    }
}

func generateOpponent(_ context:ModelContext)throws -> any HashableNamedDataType{
    let villains : [Villain] = try fetchList(context,predicate: #Predicate{!$0.isUsed})
    let campaigns : [Campaign] = try fetchList(context,predicate: #Predicate{!$0.isUsed})
    let opponents : [any HashableNamedDataType] = villains + campaigns
    guard !opponents.isEmpty else{
        try resetAllIsUsed(context, T: Villain.self)
        try resetAllIsUsed(context, T: Campaign.self)
        return try generateOpponent(context)
    }
    var opponent = opponents.randomElement()!
    opponent.isUsed = true
    return opponent
}

func generateLocationsWithHazardous(list:[Location], count: Int ,needHazardousCount : Int = 0 )throws->[Location]{
    if needHazardousCount > count{
        throw GeneratorError.GenerateCountError
    }
    if list.count < count{
        throw GeneratorError.SelectionCountError
    }
    let hazardousList = list.filter{$0.isHazardous}
    if hazardousList.count < needHazardousCount{
        throw GeneratorError.SelectionCountError
    }
    let randomHazardousList = try generateRandomList(hazardousList,count:needHazardousCount)
    let restList = list.filter{!randomHazardousList.contains($0)}
    let randomRestList = try generateRandomList(restList,count:count - needHazardousCount)
    var results : [Location] = randomHazardousList + randomRestList
    results.shuffle()
    return results
}
