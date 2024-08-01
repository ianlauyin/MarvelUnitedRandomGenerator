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
    @State private var isLoading = false
    @State private var selection = Set<Hero>()
    @State private var playerCount : Int = 1
    @State private var includeCompanion : Bool = false
    @State private var results : [HeroResult] = []
    
    var body: some View {
        VStack{
            Text("Select Hero")
            List(allHeroes, id: \.self, selection: $selection) { hero in
                    Text(hero.name)
            }.environment(\.editMode ,.constant(EditMode.active))
                .frame(height:340)
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
               HeroResultView(heroResults: results)
            }
            Spacer()
        }.loadingCover($isLoading)
            .onAppear{selection = Set(allHeroes)}
            .toolbar{Button("Generate"){generate()}}
    }
    
    func generate(){
        isLoading = true
        do{
           results = try generateRandomHeroes(context, count: playerCount, list: Array(selection), includeCompanion: includeCompanion)
        }catch{
            AlertHandler.shared.showMessage("Cannot Generate")
        }
        isLoading = false
    }
}


