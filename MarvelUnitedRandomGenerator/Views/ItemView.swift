//
//  AddItemView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import SwiftUI
import SwiftData

enum ItemViewOperation{
    case add,edit
    
    var name:String{
        switch self{
        case .add: return "Add"
        case .edit: return "Edit"
        }
    }
}

struct ItemView: View {
    var operation : ItemViewOperation
    var data : Data
    @State var name : String = ""
    @State var figureContainer : String = ""
    @State var isHazardous = false
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode
    var editingUUID : UUID?
    
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
                if operation == .edit{
                    HStack{
                        Spacer()
                        Button("Delete"){handleDelete()}.foregroundStyle(.red)
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("\(operation.name) \(data.name)")
            .toolbar{
                ToolbarItem(){
                    Button("Save"){handleSubmit()}
                }
            }
    }
    
    func handleSubmit(){
        LoadingHandler.shared.showLoading()
        if operation == .add{
            handleAdd()
        }else{
            handleEdit()
        }
        LoadingHandler.shared.closeLoading()
        AlertHandler.shared.showMessage("Saved")
    }
    
    func handleAdd(){
        let newDatas: [any PersistentModel] = switch data{
        case .hero: [Hero(name: name,teamDecks: [], figureContainer: figureContainer)]
        case .villain: [Villain(name: name, figureContainer:figureContainer)]
        case .campaign: [Campaign(name: name)]
        case .companion: [Companion(name:name)]
        case .location: [Location(name: name, isHazardous: isHazardous)]
        case .teamDeck: [TeamDeck(name: name, heroes: [])]
        case .antiHero: [Hero(name: name, teamDecks: [], figureContainer:figureContainer),Villain(name: name, figureContainer:figureContainer)]
        }
        for newData in newDatas{
            context.insert(newData)
        }
    }
    
    func handleEdit(){
        guard let editingUUID = editingUUID else {
            AlertHandler.shared.showMessage("Missing editingId")
            return
        }
        do{
            switch data{
            case .hero:
                let fetchDescriptor = FetchDescriptor<Hero>(predicate: #Predicate{$0.UUID == editingUUID})
                let fetchedItem = try context.fetch(fetchDescriptor)
                fetchedItem[0].name = name
                fetchedItem[0].figureContainer = figureContainer
            case .campaign:
                let fetchDescriptor = FetchDescriptor<Campaign>(predicate: #Predicate{$0.UUID == editingUUID})
                let fetchedItem = try context.fetch(fetchDescriptor)
                fetchedItem[0].name = name
            case .companion:
                let fetchDescriptor = FetchDescriptor<Companion>(predicate: #Predicate{$0.UUID == editingUUID})
                let fetchedItem = try context.fetch(fetchDescriptor)
                fetchedItem[0].name = name
            case .location:
                let fetchDescriptor = FetchDescriptor<Location>(predicate: #Predicate{$0.UUID == editingUUID})
                let fetchedItem = try context.fetch(fetchDescriptor)
                fetchedItem[0].name = name
                fetchedItem[0].isHazardous = isHazardous
            case .teamDeck:
                let fetchDescriptor = FetchDescriptor<TeamDeck>(predicate: #Predicate{$0.UUID == editingUUID})
                let fetchedItem = try context.fetch(fetchDescriptor)
                fetchedItem[0].name = name
            case .villain:
                let fetchDescriptor = FetchDescriptor<Villain>(predicate: #Predicate{$0.UUID == editingUUID})
                let fetchedItem = try context.fetch(fetchDescriptor)
                fetchedItem[0].name = name
                fetchedItem[0].figureContainer = figureContainer
            case .antiHero:
                AlertHandler.shared.showMessage("Wrong Type of Data")
            }
        }catch{
            AlertHandler.shared.showMessage("Cannot Fetch Data")
        }
    }
    
    func handleDelete(){
        LoadingHandler.shared.showLoading()
        guard let editingUUID = editingUUID else {
            AlertHandler.shared.showMessage("Missing editingId")
            return
        }
        do{
            switch data{
            case .hero:
                let fetchDescriptor = FetchDescriptor<Hero>(predicate: #Predicate{$0.UUID == editingUUID})
                let fetchedItem = try context.fetch(fetchDescriptor)
                context.delete(fetchedItem[0])
            case .campaign:
                let fetchDescriptor = FetchDescriptor<Campaign>(predicate: #Predicate{$0.UUID == editingUUID})
                let fetchedItem = try context.fetch(fetchDescriptor)
                context.delete(fetchedItem[0])
            case .companion:
                let fetchDescriptor = FetchDescriptor<Companion>(predicate: #Predicate{$0.UUID == editingUUID})
                let fetchedItem = try context.fetch(fetchDescriptor)
                context.delete(fetchedItem[0])
            case .location:
                let fetchDescriptor = FetchDescriptor<Location>(predicate: #Predicate{$0.UUID == editingUUID})
                let fetchedItem = try context.fetch(fetchDescriptor)
                context.delete(fetchedItem[0])
            case .teamDeck:
                let fetchDescriptor = FetchDescriptor<TeamDeck>(predicate: #Predicate{$0.UUID == editingUUID})
                let fetchedItem = try context.fetch(fetchDescriptor)
                context.delete(fetchedItem[0])
            case .villain:
                let fetchDescriptor = FetchDescriptor<Villain>(predicate: #Predicate{$0.UUID == editingUUID})
                let fetchedItem = try context.fetch(fetchDescriptor)
                context.delete(fetchedItem[0])
            case .antiHero:
                AlertHandler.shared.showMessage("Wrong Type of Data")
            }
        }catch{
            AlertHandler.shared.showMessage("Cannot Fetch Data")
        }
        LoadingHandler.shared.closeLoading()
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    ItemView(operation: .edit, data:.location)
}
