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
            }
        }
    }
}

#Preview {
    let container = previewModelContainer()
    
    for locationName in Data.location.sampleData{
        let location = Location(name: locationName as! String, isHazardous: false)
        container.mainContext.insert(location)
    }
    
    for heroData in Data.hero.sampleData{
        if let heroDict = heroData as? [String: String],
               let name = heroDict["name"],
               let figureContainer = heroDict["figureContainer"] {
                let hero = Hero(name: name, teamDecks: [], figureContainer: figureContainer)
                container.mainContext.insert(hero)
            }
    }
    
    return GeneratorView().modelContainer(container)
}
