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
    return GeneratorView().modelContainer(container)
}
