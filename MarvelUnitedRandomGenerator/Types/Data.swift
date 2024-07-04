//
//  Data.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 3/7/2024.
//

import SwiftData

protocol DataOption{
    var name : String {get}
    var model : (any PersistentModel.Type)? {get}
}

enum Data:DataOption,CaseIterable{
    case hero,antiHero,villain,campaign,companion,teamDeck,location
    
    var name:String{
        switch self{
        case .hero:return "Hero"
        case .antiHero:return "Anti Hero"
        case .villain:return "Villain"
        case .campaign:return "Campagin"
        case .companion:return "Companion"
        case .teamDeck:return "Team deck"
        case .location:return "Location"
        }
    }
    
    var model: (any PersistentModel.Type)?{
        switch self{
        case .hero: return Hero.self
        case .antiHero: return nil
        case .villain: return Villain.self
        case .campaign: return Campaign.self
        case .companion: return Companion.self
        case .teamDeck: return TeamDeck.self
        case .location: return Location.self
        }
    }
}
