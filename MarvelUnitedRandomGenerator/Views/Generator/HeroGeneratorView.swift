//
//  HeroGeneratorView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 5/7/2024.
//

import SwiftUI
import SwiftData


struct HeroGeneratorView: View {
    @Query(sort: \Hero.name) var allHeroes : [Hero]
    @Environment(\.modelContext) private var context
    @State private var selection = Set<Hero>()
    @State private var playerCount : Int = 1
    @State private var includeCompanion : Bool = false
    
    struct HeroResult:Hashable{
        var name : String
        var figureContainer : String?
        var useEquipment : Bool?
        var companion: String?
    }
    
    @State private var results : [HeroResult] = []
    
    var body: some View {
        VStack{
            Text("Select Hero")
            List(allHeroes, id: \.self, selection: $selection) { hero in
                    Text(hero.name)
            }.environment(\.editMode ,.constant(EditMode.active))
                .frame(height:350)
            .scrollContentBackground(.hidden)
            Toggle(isOn: $includeCompanion){
                Text("Include Companion?")
            }.padding(.horizontal)
            Divider().foregroundStyle(.black).padding()
            Picker("Number",selection: $playerCount){
                ForEach((1...4), id:\.self){
                    Text("\($0)")
                }
            }.pickerStyle(.segmented)
                .padding(.horizontal)
            if results.count != 0{
                HStack{
                Text("Hero:")
                    Spacer()
                    Text("Equipment:")
                    Text("No.").frame(width:30)
                }.padding(.horizontal)
                Divider()
                ForEach(results,id:\.self){result in
                        HStack{
                            Text(result.name)
                            Spacer()
                            if result.useEquipment != nil {
                                Text(result.useEquipment! ? "Use" : "Not Use")
                            }
                            Text(result.figureContainer ?? "")
                                .frame(width:30)
                        }.padding(.horizontal)
                    if let companion = result.companion{
                        HStack{
                            Text("Companion:")
                            Spacer()
                            Text(companion)
                        }.padding(.horizontal)
                    }
                }
            }
            Spacer()
        }.onAppear{selection = Set(allHeroes)}
            .toolbar{Button("Generate"){generate()}}
    }
    
    func generate(){
        results = []
        let targetCount = playerCount == 1 ? 5 : playerCount
        if selection.count < targetCount{
            AlertHandler.shared.showMessage("Not Enough Hero")
            return
        }
        let arrayOfSelection = Array(selection)
        var filteredSelection = arrayOfSelection.filter{ !$0.isUsed }
        do{
            while results.count < targetCount{
                if filteredSelection.count == getRepeatedCount(filteredSelection.map{$0.name},results.map{$0.name}){
                    resetIsUsed()
                    filteredSelection = arrayOfSelection
                }
                let randomInt = Int.random(in: 0..<filteredSelection.count)
                let randomData = filteredSelection[randomInt]
                if results.contains(where: {$0.name == randomData.name}){
                    continue
                }
                let useEquipment : Bool? = playerCount == 1 && results.count >= 1 ? nil :
                Bool.random()
                let figureContainer : String? = playerCount == 1 && results.count >= 1 ?
                nil : randomData.figureContainer
                randomData.isUsed = true
                var companionName : String? = nil
                if includeCompanion && !(playerCount == 1 && results.count >= 1) {
                    companionName = try getRandomCompanion()?.name
                }
                let newResult = HeroResult(name: randomData.name, figureContainer: figureContainer, useEquipment : useEquipment, companion: companionName)
                results.append(newResult)
                filteredSelection.remove(at: randomInt)
            }
        }catch{
            AlertHandler.shared.showMessage("Cannot Fetch Data")
        }
    }
    
    func getRandomCompanion()throws -> Companion?{
        do{
            if Bool.random(){
                return nil
            }
            let fetchDescriptor = FetchDescriptor<Companion>(predicate: #Predicate{!$0.isUsed})
            let fetchedItems:[Companion] = try context.fetch(fetchDescriptor)
            let companion = fetchedItems[Int.random(in: 0..<fetchedItems.count)]
            companion.isUsed = true
            if fetchedItems.count == 1 {
                try resetAllCompanion()
            }
            return companion
        }catch{
            throw OperationError.FetchError
        }
    }
    
    func resetAllCompanion()throws{
        do{
            let fetchDescriptor = FetchDescriptor<Companion>()
            let fetchedItems:[Companion] = try context.fetch(fetchDescriptor)
            fetchedItems.forEach{$0.isUsed = false}
        }catch{
            throw OperationError.FetchError
        }
    }
    
    func resetIsUsed(){
        for hero in selection{
            hero.isUsed = false
        }
    }
}

#Preview {
    let container = previewModelContainer()
    
    for heroData in Data.hero.sampleData{
        if let heroDict = heroData as? [String: String],
               let name = heroDict["name"],
               let figureContainer = heroDict["figureContainer"] {
                let hero = Hero(name: name, teamDecks: [], figureContainer: figureContainer)
                container.mainContext.insert(hero)
            }
    }
    
    return HeroGeneratorView().modelContainer(container)
}
