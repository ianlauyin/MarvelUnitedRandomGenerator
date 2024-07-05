//
//  HeroGeneratorView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 5/7/2024.
//

import SwiftUI
import SwiftData

struct LocationGeneratorView: View {
    @Query(sort: \Location.name) var allLocations : [Location]
    @State private var selection = Set<Location>()
    
    let names = [
            "Cyril",
            "Lana",
            "Mallory",
            "Sterling"
        ]

        var body: some View {
            NavigationStack {
                List(allLocations, id: \.self, selection: $selection) { location in
                    Text(location.name)
                }.environment(\.editMode ,.constant(EditMode.active))
                Text("\(selection.count)")
            }
        }
}

#Preview {
    let container = previewModelContainer()
    
    for locationName in Data.location.sampleData{
        let location = Location(name: locationName as! String, isHazardous: false)
        container.mainContext.insert(location)
    }
    
    return LocationGeneratorView().modelContainer(container)
}
