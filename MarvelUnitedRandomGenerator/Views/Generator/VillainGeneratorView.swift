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
    @State private var selection = Set<Villain>()
    @State private var villainCount : Int = 1
    @State private var includeUsed : Bool = false
    
    struct VillainResult:Hashable{
        var name : String
        var figureContainer : String
    }
    
    @State private var results : [VillainResult] = []
    
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
        }
            .onAppear{selection = Set(allVillains)}
            .toolbar{Button("Generate"){generate()}}
    }
    
    func generate(){
        results = []
        let targetCount = villainCount
        if selection.count < targetCount{
            AlertHandler.shared.showMessage("Not Enough Villain")
            return
        }
        let arrayOfSelection = Array(selection)
        var filteredSelection = includeUsed ? arrayOfSelection : arrayOfSelection.filter{ !$0.isUsed }
        while results.count < targetCount{
            let repeatedCount = getRepeatedCount(filteredSelection.map{$0.name},results.map{$0.name})
            if !includeUsed && filteredSelection.count == repeatedCount{
                resetIsUsed()
                filteredSelection = arrayOfSelection
            }
            let randomInt = Int.random(in: 0..<filteredSelection.count)
            let randomData = filteredSelection[randomInt]
            if results.contains(where: {$0.name == randomData.name}){
                continue
            }
            let figureContainer = randomData.figureContainer
            if !includeUsed{
                randomData.isUsed = true
            }
            let newResult = VillainResult(name: randomData.name, figureContainer: figureContainer)
            results.append(newResult)
            filteredSelection.remove(at: randomInt)
        }
    }
    
    func resetIsUsed(){
        for villain in allVillains{
            villain.isUsed = true
        }
    }
}

#Preview {
    let container = previewModelContainer()
    
    for villainData in Data.villain.sampleData{
        if let villainDict = villainData as? [String: String],
               let name = villainDict["name"],
               let figureContainer = villainDict["figureContainer"] {
                let villain = Villain(name: name, figureContainer: figureContainer)
                container.mainContext.insert(villain)
            }
    }
    
    return VillainGeneratorView().modelContainer(container)
}
