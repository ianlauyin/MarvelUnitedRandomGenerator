//
//  AddItemView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import SwiftUI
import SwiftData



struct ItemView: View {
    var data : Data
    @State private var name : String = ""
    @State private var figureContainer : String = ""
    @State private var isHazardous = false
    @Environment(\.modelContext) private var context
    
    var body: some View {
        VStack{
            Form{
                Section{
                    HStack{
                        Text("Name")
                        TextField("Name",text:$name)
                            .multilineTextAlignment(.trailing)
                    }
                    if [.hero,.antiHero,.villain].contains(data){
                        HStack{
                            Text("Figure Container")
                            TextField("Figure Container",text:$figureContainer)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    if data == .location {
                        Toggle(isOn: $isHazardous){
                            Text("Hazardous")
                        }
                    }
                }
                HStack{
                    Spacer()
                    Button("Add"){handleSubmit()}
                    Spacer()
                }
            }
        }.navigationTitle("Add " + data.name)
    }
    
    func handleSubmit(){
        LoadingHandler.shared.showLoading()
        let figureContainerInput : String? = figureContainer.count == 0 ? nil : figureContainer
        let newDatas: [any PersistentModel] = switch data{
        case .hero: [Hero(name: name,teamDecks: [], figureContainer:figureContainerInput)]
        case .villain: [Villain(name: name, figureContainer:figureContainerInput)]
        case .campaign: [Campaign(name: name)]
        case .companion: [Companion(name:name)]
        case .location: [Location(name: name, isHazardous: isHazardous)]
        case .teamDeck: [TeamDeck(name: name, heroes: [])]
        case .antiHero: [Hero(name: name, teamDecks: [], figureContainer:figureContainerInput),Villain(name: name, figureContainer:figureContainerInput)]
        }
        for newData in newDatas{
            context.insert(newData)
        }
        LoadingHandler.shared.closeLoading()
    }
}

#Preview {
    ItemView(data:.hero)
}
