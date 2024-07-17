//
//  TeamDeckGeneratorView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 17/7/2024.
//

import SwiftUI
import SwiftData

struct TeamDeckResult{
    var teamDeck: String
    var heroResults: [HeroResult]
}

struct TeamDeckGeneratorView: View {
    @Query(sort: \TeamDeck.name) var allTeamDeck : [TeamDeck]
    @Environment(\.modelContext) private var context
    @State private var isLoading = false
    @State private var selection = Set<TeamDeck>()
    @State private var playerCount : Int = 2
    @State private var includeCompanion : Bool = false
    @State private var result : TeamDeckResult? = nil
    
    var body: some View {
        VStack{
            Text("Select TeamDeck")
            List(allTeamDeck, id: \.self, selection: $selection) {
                    Text($0.name)
            }.environment(\.editMode ,.constant(EditMode.active))
                .frame(height:340)
            .scrollContentBackground(.hidden)
            Toggle(isOn: $includeCompanion){
                Text("Include Companion?")
            }.padding(.horizontal)
            Divider().foregroundStyle(.black).padding()
            Picker("Number",selection: $playerCount){
                ForEach((2...4), id:\.self){
                    Text("\($0)")
                }
            }.pickerStyle(.segmented)
                .padding(.horizontal)
            if let result = result{
                Text(result.teamDeck)
                HeroResultView(heroResults: result.heroResults)
            }
            Spacer()
        }.loadingCover($isLoading)
            .onAppear{selection = Set(allTeamDeck)}
            .toolbar{Button("Generate"){generate()}}
    }
    
    func generate(){
        isLoading = true
        do{
           result = try generateTeamDeckHeroes(context, count: playerCount, list: Array(selection), includeCompanion: includeCompanion)
        }catch GeneratorError.TeamDeckNotEnoughError(let message){
            AlertHandler.shared.showMessage(message)
        }catch{
            AlertHandler.shared.showMessage("Must select at least one Team deck")
        }
        isLoading = false
    }
}

#Preview {
    let container = previewModelContainer()
    migrateSampleData(container.mainContext)
    
    return TeamDeckGeneratorView().modelContainer(container)
}
