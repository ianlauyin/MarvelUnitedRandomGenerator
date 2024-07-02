//
//  GameMode.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

protocol GameModeOption{
    var name:String { get }
    var needHazardousLocationNumber:Int {get}
    var excludeCharater:[String]{get}
}

enum GameMode:GameModeOption{    
    case normalGame,secretIdentity,takeover,hard,planB,heroic,moderate,dangerRoom,sentinel3,sentinel2,sentinel1,hazardousLocation,endangeredLocation,deadpoolChaos,carnage,complication
    
    var name: String{
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
        }
    }
    
    var needHazardousLocationNumber: Int{
        switch self{
        case .hazardousLocation: return 3
        default: return 0
        }
    }
    
    var excludeCharater: [String]{
        switch self{
        case .sentinel1,.sentinel2,.sentinel3: return ["Nimrod"]
        case .deadpoolChaos: return ["Dealpool"]
        case .carnage: return ["Carnage"]
        default: return []
        }
    }
}
