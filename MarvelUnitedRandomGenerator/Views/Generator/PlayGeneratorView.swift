//
//  PlayGeneratorView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 17/7/2024.
//

import SwiftUI

struct PlayResult{
    var isCampaign : Bool
    var name : String
    var playerCount : Int
    var gameMode : GameMode? = nil
    var teamDeck : String? = nil
    var heroResults : [HeroResult] = []
}

struct PlayGeneratorView: View {
    @Environment(\.modelContext) private var context
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    PlayGeneratorView()
}
