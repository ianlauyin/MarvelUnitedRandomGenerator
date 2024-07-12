//
//  FetchUtils.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 10/7/2024.
//

import Foundation
import SwiftData

func fetchSortedList<T:HashableNamedDataType>(_ context:ModelContext)throws->[T]{
    do{
        let fetchDescriptor = FetchDescriptor<T>(sortBy: [SortDescriptor(\T.name)])
        let fetchedItems:[T] = try context.fetch(fetchDescriptor)
        return fetchedItems
    }catch{
        throw OperationError.FetchError
    }
}
