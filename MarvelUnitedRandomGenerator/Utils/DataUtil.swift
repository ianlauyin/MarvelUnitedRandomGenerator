//
//  FetchUtils.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 10/7/2024.
//

import Foundation
import SwiftData

func convertGenericToDataType(_ T:any HashableNamedDataType.Type)throws->Data{
    return switch T.self {
    case is Location.Type:.location
    case is Hero.Type:.hero
    case is Villain.Type:.villain
    case is Campaign.Type:.campaign
    case is Companion.Type:.companion
    case is TeamDeck.Type:.teamDeck
    default: throw OperationError.ConvertingError
        }
}

func fetchList<T:HashableNamedDataType>(_ context:ModelContext , predicate: Predicate<T>? = nil, sortBy:[SortDescriptor<T>] = [] )throws->[T]{
    do{
        let fetchDescriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortBy)
        let fetchedItems:[T] = try context.fetch(fetchDescriptor)
        return fetchedItems
    }catch{
        throw OperationError.FetchError
    }
}

func addItem<T:HashableNamedDataType>(_ context:ModelContext, data: T, relatedHeroes : [Hero]? = nil, relatedTeamDecks : [TeamDeck]? = nil)throws{
    do{
        try checkNameExist(context,type:T.self, name:data.name)
        context.insert(data)
        if let data = data as? Hero,
           let teamDecks = relatedTeamDecks{
            data.teamDecks = teamDecks
        }
        if let data = data as? TeamDeck,
           let heroes = relatedHeroes{
            data.heroes = heroes
        }
    }catch{
        throw error
    }
}

func deleteItem<T:HashableNamedDataType>(_ context:ModelContext,data:T){
    context.delete(data)
}

func checkNameExist<T:HashableNamedDataType>(_ context:ModelContext, type: T.Type, name:String)throws{
    let fetchedItems = try fetchList(context) as [T]
    if fetchedItems.map({$0.name}).contains(name){ throw OperationError.RepeatedNameError }
}

func updateItem<T:HashableNamedDataType>(_ context:ModelContext, data: inout T , newInfo:[String:Any], relatedList:[any HashableNamedDataType]? = nil)throws{
    if let name = newInfo["name"] as? String,
        data.name != name{
        try checkNameExist(context, type: T.self, name: name)
        data.name = name
    }
    if let data = data as? Hero{
        if let figureContainer = newInfo["figureContainer"] as? String {data.figureContainer = figureContainer}
        if let teamDecks = relatedList as? [TeamDeck] {data.teamDecks = teamDecks}
    }
    if let data = data as? Villain{
        if let figureContainer = newInfo["figureContainer"] as? String {data.figureContainer = figureContainer}
    }
    if let data = data as? TeamDeck{
        if let heroes = relatedList as? [Hero] {data.heroes = heroes}
    }
    if let data = data as? Location{
        if let isHazardous = newInfo["isHazardous"] as? Bool {data.isHazardous = isHazardous}
    }
}

func resetAllIsUsed<T:HashableNamedDataType>(_ context:ModelContext, T: T.Type)throws{
    let allData = try fetchList(context) as [T]
    resetIsUsed(list: allData)
}

func resetIsUsed<T:HashableNamedDataType>(list: [T]){
    var changeingList = list
    for index in changeingList.indices{
        changeingList[index].isUsed = false
    }
}

func convertingHeroIntoHeroResult(_ context:ModelContext,hero:Hero,includeCompanion:Bool = false)throws->HeroResult{
    let companion : Companion? = includeCompanion ? try generateRandomCompanion(context, heroName: hero.name) : nil
    return HeroResult(name: hero.name,figureContainer: hero.figureContainer, useEquipment: Bool.random(), companion: companion?.name)
}

func convertVillainToResults(_ villain:Villain)->VillainResult{
    return VillainResult(name:villain.name,figureContainer: villain.figureContainer)
}
