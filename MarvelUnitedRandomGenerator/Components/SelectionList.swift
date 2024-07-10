//
//  SelectionList.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 10/7/2024.
//

import SwiftUI
import SwiftData

struct SelectionList<T:HashableNamedData>: View {
    var list : [T]
    @Binding var selection : Set<T>
    var body: some View {
            List(list, id:\.self ,selection:$selection){item in
                Text(item.name)
            }.environment(\.editMode , .constant(.active))
                .scrollContentBackground(.hidden)
    }
}

#Preview {
    let container = previewModelContainer()
    
    var heroes : [Hero] = []
    @State var selection = Set<Hero>()
    for heroData in Data.hero.sampleData{
        if let heroDict = heroData as? [String: String],
               let name = heroDict["name"],
               let figureContainer = heroDict["figureContainer"] {
                let hero = Hero(name: name, teamDecks: [], figureContainer: figureContainer)
                container.mainContext.insert(hero)
                heroes.append(hero)
            }
    }
    
    return SelectionList<Hero>(list:heroes,selection:$selection).modelContainer(container)

}
