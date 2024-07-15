//
//  FetchUtils.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 10/7/2024.
//

import Foundation
import SwiftData

func fetchList<T:HashableNamedDataType>(_ context:ModelContext , predicate: Predicate<T>? = nil )throws->[T]{
    do{
        let fetchDescriptor = FetchDescriptor<T>(predicate: predicate, sortBy: [SortDescriptor(\T.name)])
        let fetchedItems:[T] = try context.fetch(fetchDescriptor)
        return fetchedItems
    }catch{
        throw OperationError.FetchError
    }
}

func addItem<T:HashableNamedDataType>(_ context:ModelContext, data: T)throws{
    do{
        let name = data.name
        let fetchedItems = try fetchList(context,predicate: #Predicate<T>{$0.name == name})
        if !fetchedItems.isEmpty{ throw OperationError.InsertError }
        context.insert(data)
    }catch{
        throw error
    }
}
