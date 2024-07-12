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
                    LocationGeneratorView().navigationTitle("Location Generator")
                }
                NavigationLink("Hero Generator"){
                    HeroGeneratorView().navigationTitle("Hero Generator")
                }
                NavigationLink("Game Mode Generator"){
                    GameModeGeneratorView().navigationTitle("Game Mode Generator")
                }
                NavigationLink("Villain Generator"){
                    VillainGeneratorView().navigationTitle("Villain Generator")
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
