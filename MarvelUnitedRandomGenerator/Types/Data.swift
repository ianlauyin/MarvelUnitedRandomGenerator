//
//  Data.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 3/7/2024.
//

import SwiftData

protocol DataOption{
    var name : String {get}
}

enum Data:DataOption,CaseIterable{
    case hero,villain,campaign,companion,teamDeck,location
    
    var name:String{
        switch self{
        case .hero:return "Hero"
        case .villain:return "Villain"
        case .campaign:return "Campagin"
        case .companion:return "Companion"
        case .teamDeck:return "Team deck"
        case .location:return "Location"
        }
    }
}
