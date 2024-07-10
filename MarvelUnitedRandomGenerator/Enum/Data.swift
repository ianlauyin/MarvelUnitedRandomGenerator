//
//  Data.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 3/7/2024.
//

import SwiftData

protocol DataOption:CaseIterable{
    var name : String {get}
    var model : any HashableNamedData.Type {get}
}

enum Data:DataOption{
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
    
    var model: any HashableNamedData.Type{
        switch self{
        case .hero: return Hero.self
        case .villain: return Villain.self
        case .campaign: return Campaign.self
        case .companion: return Companion.self
        case .teamDeck: return TeamDeck.self
        case .location: return Location.self
        }
    }
    
    var sampleData:[Any]{
        switch self{
        case .location: return ["BA","AC","CB","AA","CA","CC","BB","AB","BC"]
        case .hero: return [["name":"H1","figureContainer":"1"],["name":"AH1","figureContainer":"A"],["name":"H2","figureContainer":"2"],["name":"H3","figureContainer":"1"],["name":"AH2","figureContainer":"A"],["name":"H4","figureContainer":"A"]]
        case .teamDeck: return
            ["T1","T3","T2","T4"]
        case .villain: return
            [["name":"V1","figureContainer":"1"],["name":"AH1","figureContainer":"A"],["name":"V2","figureContainer":"2"],["name":"V3","figureContainer":"1"],["name":"AH2","figureContainer":"A"],["name":"V4","figureContainer":"A"]]
        case .companion: return
            ["P1","P3","P2","P5","P4"]
        default: return []
        }
    }
}
