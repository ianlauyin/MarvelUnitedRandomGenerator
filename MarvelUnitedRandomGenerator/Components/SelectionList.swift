//
//  SelectionList.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 10/7/2024.
//

import SwiftUI
import SwiftData

struct SelectionList<T:HashableNamedDataType>: View {
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
    
    var companions : [Companion] = []
    @State var selection = Set<Companion>()
    let companionNames = ["P1","P3","P2","P5","P4"]
    for companionName in companionNames{
        let companion = Companion(name: companionName)
        container.mainContext.insert(companion)
        companions.append(companion)
    }
    
    return SelectionList<Companion>(list:companions,selection:$selection).modelContainer(container)

}
