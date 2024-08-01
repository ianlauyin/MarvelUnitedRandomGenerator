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
