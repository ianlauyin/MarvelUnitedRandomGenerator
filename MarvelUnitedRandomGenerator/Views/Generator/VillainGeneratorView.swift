//
//  VillainGeneratorView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 9/7/2024.
//

import SwiftUI
import SwiftData

struct VillainGeneratorView: View {
    @Query(sort: \Villain.name) var allVillains : [Villain]
    @Environment(\.modelContext) private var context
    @State private var isLoading : Bool = false
    @State private var selection = Set<Villain>()
    @State private var villainCount : Int = 1
    @State private var includeUsed : Bool = false
    
    @State private var results : [Villain] = []
    
    var body: some View {
        VStack{
            Text("Select Villain")
            List(allVillains, id: \.self, selection: $selection) { villain in
                    Text(villain.name)
            }.environment(\.editMode ,.constant(EditMode.active))
            .frame(height:400)
            .scrollContentBackground(.hidden)
            Toggle(isOn: $includeUsed){
                Text("Include Used?")
            }.padding(.horizontal)
            Divider().foregroundStyle(.black).padding()
            Picker("Number",selection: $villainCount){
                ForEach((1...6), id:\.self){
                    Text("\($0)")
                }
            }.pickerStyle(.segmented)
                .padding(.horizontal)
            if results.count != 0{
                HStack{
                Text("Villain:")
                    Spacer()
                    Text("No.").frame(width:30)
                }.padding(.horizontal)
                Divider()
                ForEach(results,id:\.self){result in
                        HStack{
                            Text(result.name)
                            Spacer()
                            Text(result.figureContainer)
                                .frame(width:30)
                        }.padding(.horizontal)
                }
            }
            Spacer()
        }.loadingCover($isLoading)
            .onAppear{selection = Set(allVillains)}
            .toolbar{Button("Generate"){generate()}}
    }
    
    func generate(){
        isLoading = true
        do{
            var list = Array(selection)
            results = try generateRandomList(context, count: villainCount, list: &list, includeUsed: includeUsed)
        }catch{
            AlertHandler.shared.showMessage("Cannot generate")
        }
        print(allVillains.compactMap{$0.name})
        print(allVillains.compactMap{$0.isUsed})
        isLoading = false
    }
}

#Preview {
    let container = previewModelContainer()
    migrateSampleData(container.mainContext)
    
    return VillainGeneratorView().modelContainer(container)
}
