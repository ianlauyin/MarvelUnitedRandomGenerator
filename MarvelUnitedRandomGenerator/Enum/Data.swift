//
//  Data.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 3/7/2024.
//

import SwiftData

enum Data:CaseIterable{
    case hero,villain,campaign,companion,teamDeck,location
    
    subscript() -> String {
        switch self{
        case .hero:return "Hero"
        case .villain:return "Villain"
        case .campaign:return "Campagin"
        case .companion:return "Companion"
        case .teamDeck:return "Team deck"
        case .location:return "Location"
        }
    }
    
    var model: any HashableNamedDataType.Type{
        switch self{
        case .hero: return Hero.self
        case .villain: return Villain.self
        case .campaign: return Campaign.self
        case .companion: return Companion.self
        case .teamDeck: return TeamDeck.self
        case .location: return Location.self
        }
    }
    
    func migrateSampleData(_ context:ModelContext) -> Void {
        switch self{
        case .location:
            let locationNames = ["BA","AC","CB","AA","CA","CC","BB","AB","BC"]
            for locationName in locationNames{
                let location = Location(name: locationName, isHazardous: false)
                context.insert(location)
            }
        case .hero:
            let heroDatas = [["name":"H1","figureContainer":"1"],["name":"AH1","figureContainer":"A"],["name":"H2","figureContainer":"2"],["name":"H3","figureContainer":"1"],["name":"AH2","figureContainer":"A"],["name":"H4","figureContainer":"A"]]
            for heroData in heroDatas{
                let hero = Hero(name: heroData["name"]!, teamDecks: [], figureContainer: heroData["figureContainer"]!)
                context.insert(hero)
            }
        case .teamDeck:
            let teamDeckNames = ["T1","T3","T2","T4"]
            for teamDeckName in teamDeckNames{
                let teamDeck = TeamDeck(name: teamDeckName, heroes: [])
                context.insert(teamDeck)
            }
        case .villain:
            let villainDatas = [["name":"V1","figureContainer":"1"],["name":"AH1","figureContainer":"A"],["name":"V2","figureContainer":"2"],["name":"V3","figureContainer":"1"],["name":"AH2","figureContainer":"A"],["name":"V4","figureContainer":"A"]]
            for villainData in villainDatas{
                let villain = Villain(name: villainData["name"]!,figureContainer: villainData["figureContainer"]!)
                context.insert(villain)
            }
        case .companion:
            let companionNames = ["P1","P3","P2","P5","P4"]
            for companionName in companionNames{
                let companion = Companion(name: companionName)
                context.insert(companion)
            }
            default: break;
        }
    }
}
