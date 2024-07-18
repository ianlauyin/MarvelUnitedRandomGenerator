//
//  GeneratorView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import SwiftUI

struct GeneratorView: View {
    var body: some View {
        NavigationStack{
            List{
                NavigationLink("Location Generator"){
                    GeneralGeneratorView<Location>().navigationTitle("Location Generator")
                }
                NavigationLink("Hero Generator"){
                    HeroGeneratorView().navigationTitle("Hero Generator")
                }
                NavigationLink("Game Mode Generator"){
                    GameModeGeneratorView().navigationTitle("Game Mode Generator")
                }
                NavigationLink("Villain Generator"){
                    GeneralGeneratorView<Villain>().navigationTitle("Villain Generator")
                }
                NavigationLink("Team Deck Generator"){
                    TeamDeckGeneratorView().navigationTitle("Team Deck Generator")
                }
                NavigationLink("Play Generator"){
                    PlayGeneratorView().navigationTitle("Play Generator")
                }
            }
        }
    }
}

#Preview {
    let container = previewModelContainer()
    migrateSampleData(container.mainContext)
    
    return GeneratorView().modelContainer(container)
}
