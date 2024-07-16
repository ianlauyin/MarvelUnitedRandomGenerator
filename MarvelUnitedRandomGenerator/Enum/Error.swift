//
//  Error.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 15/7/2024.
//

import Foundation

enum OperationError : Error{
    case InsertError
    case EditError
    case FetchError
    case ConvertingError
}

enum GeneratorError :Error{
    case EmptySelectionError
}
