//
//  GameMode.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import SwiftData

protocol GameModeOption{
    var needHazardousLocationNumber:Int {get}
    var excludeHeroes:[String]{get}
    var excludeVillain:[String]{get}
}

enum GameMode:GameModeOption,CaseIterable,Codable{
    
    case normalGame,secretIdentity,takeover,hard,planB,heroic,moderate,dangerRoom,sentinel3,sentinel2,sentinel1,hazardousLocation,endangeredLocation,deadpoolChaos,carnage,complication,FinFangFoom
    
    subscript()->String{
        switch self{
        case .normalGame: return "Normal Game"
        case .secretIdentity: return "Secret identity"
        case .takeover: return "Takeover"
        case .hard: return "Hard"
        case .planB: return "Plan B"
        case .heroic: return "Heroic"
        case .moderate: return "Moderate"
        case .dangerRoom: return "Danger room"
        case .sentinel3: return "Sentinel 3"
        case .sentinel2: return "Sentinel 2"
        case .sentinel1: return "Sentinel 1"
        case .hazardousLocation: return "Hazardous location"
        case .endangeredLocation: return "Endangered location"
        case .deadpoolChaos: return "Deadpool chaos"
        case .carnage: return "Carnage"
        case .complication: return "Complication"
        case .FinFangFoom: return "Fin Fang Foom"
        }
    }
    
    var needHazardousLocationNumber: Int{
        switch self{
        case .hazardousLocation: return 3
        default: return 0
        }
    }
    
    var excludeHeroes: [String]{
        switch self{
        case .deadpoolChaos: return ["Dealpool"]
        default: return []
        }
    }
    
    var excludeVillain: [String]{
        switch self{
        case .sentinel1,.sentinel2,.sentinel3: return ["Nimrod"]
        case .deadpoolChaos: return ["Dealpool"]
        case .carnage: return ["Carnage"]
        case .FinFangFoom:
            return ["Fin Fang Foom","Legion","The Horsemen of Apocalypse","Return Of The Sinister Six","Sinister Six Assembled","New Sinister Six","Apocalypse (Age of Apocalypse)","Dark Avengers"]
        default: return []
        }
    }
}
