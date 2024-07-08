//
//  ArrayUtils.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 8/7/2024.
//

import Foundation

func getRepeatedCount<T:Hashable>(_ arr1:[T],_ arr2:[T])->Int{
    return Set<T>(arr1 + arr2).count
}
