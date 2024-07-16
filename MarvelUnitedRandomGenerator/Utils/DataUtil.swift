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

func fetchList<T:HashableNamedDataType>(_ context:ModelContext , predicate: Predicate<T>? = nil )throws->[T]{
    do{
        let fetchDescriptor = FetchDescriptor<T>(predicate: predicate, sortBy: [SortDescriptor(\T.name)])
        let fetchedItems:[T] = try context.fetch(fetchDescriptor)
        return fetchedItems
    }catch{
        throw OperationError.FetchError
    }
}

func addItem<T:HashableNamedDataType>(_ context:ModelContext, data: T, relatedHeroes : [Hero]? = nil, relatedTeamDecks : [TeamDeck]? = nil)throws{
    do{
        let name = data.name
        let fetchedItems = try fetchList(context,predicate: #Predicate<T>{$0.name == name})
        if !fetchedItems.isEmpty{ throw OperationError.InsertError }
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

func updateItem<T:HashableNamedDataType>(_ data: inout T , newInfo:[String:Any], relatedList:[any HashableNamedDataType]? = nil){
    if let name = newInfo["name"] as? String{
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

func resetIsUsed<T:HashableNamedDataType>(_ context:ModelContext ,list: inout [T]){
    for index in list.indices{
        list[index].isUsed = false
    }
}
