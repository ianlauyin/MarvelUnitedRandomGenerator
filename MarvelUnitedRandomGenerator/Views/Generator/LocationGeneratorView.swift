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
    @Environment(\.modelContext) private var context
    @State private var selection = Set<Location>()
    @State private var generateCount : Int = 6
    @State private var results : [String] = []
    
    var body: some View {
        VStack{
            Text("Select Location")
            List(allLocations, id: \.self, selection: $selection) { location in
                    Text(location.name)
            }.environment(\.editMode ,.constant(EditMode.active))
            .frame(height:400)
            .scrollContentBackground(.hidden)
            Divider().foregroundStyle(.black).padding()
            Picker("Number",selection: $generateCount){
                ForEach((1...6), id:\.self){
                    Text("\($0)")
                }
            }.pickerStyle(.segmented)
                .padding(.horizontal)
            if results.count != 0{
                ForEach(results,id:\.self){
                    Text($0)
                }
            }
            Spacer()
        }.loadingCover()
            .onAppear{selection = Set(allLocations)}
            .toolbar{Button("Generate"){generate()}}
    }
    
    func generate(){
        LoadingHandler.shared.showLoading()
        results = []
        let targetCount = generateCount
        if selection.count < generateCount{
            results.append("No Enough Locations")
            return
        }
        let arrayOfSelection = Array(selection)
        var filteredSelection = arrayOfSelection.filter{ !$0.isUsed }
        while results.count < targetCount{
            if filteredSelection.count == getRepeatedCount(filteredSelection.map{$0.name},results){
                resetIsUsed()
                filteredSelection = arrayOfSelection
            }
            let randomInt = Int.random(in: 0..<filteredSelection.count)
            let randomItem = filteredSelection[randomInt]
            if results.contains(randomItem.name){
                continue
            }
            randomItem.isUsed = true
            results.append(randomItem.name)
            filteredSelection.remove(at: randomInt)
        }
        LoadingHandler.shared.closeLoading()
    }
    
    func resetIsUsed(){
        for location in allLocations{
            location.isUsed = false
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
