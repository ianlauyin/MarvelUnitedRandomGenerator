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
    @State private var generateCount : Int = 1
    @State private var result : [String] = []
    
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
            if result.count != 0{
                ForEach(result,id:\.self){
                    Text($0)
                }
            }
            Spacer()
        }
            .onAppear{selection = Set(allLocations)}
            .toolbar{Button("Generate"){generate()}}
    }
    
    
    func generate(){
        result = []
        var arrayOfSelection = Array(selection)
        var filteredSelection = arrayOfSelection.filter{ !$0.isUsed }
        for _ in (1...generateCount){
            if filteredSelection.count == 0{
                resetIsUsed()
                filteredSelection = arrayOfSelection
            }
            let randomInt = Int.random(in: 0..<filteredSelection.count)
            filteredSelection[randomInt].isUsed = true
            result.append(filteredSelection[randomInt].name)
            filteredSelection.remove(at: randomInt)
        }
        print(allLocations.map{$0.isUsed})
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
