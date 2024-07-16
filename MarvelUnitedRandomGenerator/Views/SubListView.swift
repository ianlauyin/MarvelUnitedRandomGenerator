//
//  SubListView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 3/7/2024.
//

import SwiftUI
import SwiftData

struct SubListView<T:HashableNamedDataType>: View {
    var dataType: Data? = nil
    @Query private var allItems: [T] = []
    @Environment(\.modelContext) private var context
    
    init(){
        do{
            self.dataType = try convertGenericToDataType(T.self)
        }catch{
            AlertHandler.shared.showMessage("Cannot Fetch Data")
        }
    }
    
    var body: some View {
            VStack {
                List {
                    ForEach(allItems.sorted{ $0.name < $1.name}, id: \.self) { item in
                        NavigationLink(item.name) {
                            ItemView<T>(.edit,editingData: item)
                        }
                }
                }.navigationTitle(dataType?[] ?? "" + " List")
            }
        }
}

#Preview {
    let container = previewModelContainer()
    migrateSampleData(container.mainContext)
    
    return SubListView<Location>().modelContainer(container)
}
