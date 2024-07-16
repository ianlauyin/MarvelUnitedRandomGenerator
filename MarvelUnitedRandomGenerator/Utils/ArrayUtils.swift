//
//  ArrayUtils.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 8/7/2024.
//

import Foundation

func getRepeatedCount<T: Hashable>(_ arr1: [T], _ arr2: [T]) -> Int {
    let set1 = Set(arr1)
    let set2 = Set(arr2)
    let intersection = set1.intersection(set2)
    return intersection.count
}
