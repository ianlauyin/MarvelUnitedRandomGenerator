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
    @State var relatedTeamDeck : Set<TeamDeck> = Set()
    @State var relatedHeroes: Set<Hero> = Set()
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode
    @State private var extraList : [any HashableNamedDataType] = []
    var editingUUID : UUID?
    
    
    var body: some View {
        VStack{
            if data == .hero{
                if let extraList = extraList as? [TeamDeck]{
                    SelectionList(list: extraList, selection: $relatedTeamDeck)
                    Text("Related Team")
                }else{
                    EmptyView()
                }
            }
            if data == .teamDeck{
                if let extraList = extraList as? [Hero]{
                    SelectionList(list: extraList, selection: $relatedHeroes)
                    Text("Related Heroes")
                }else{
                    EmptyView()
                }
            }
            Form{
                Section{
                    HStack{
                        Text("Name")
                        TextField("Name",text:$name)
                            .multilineTextAlignment(.trailing)
                    }
                    if [.hero,.villain].contains(data){
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
        }.loadingCover()
            .onAppear{fetchExtraList()}
        .navigationTitle("\(operation.name) \(data[])")
            .toolbar{
                ToolbarItem(){
                    Button("Save"){handleSubmit()}
                }
            }
    }
    
    func fetchExtraList(){
        do{
            extraList = switch data{
            case .hero:
                try fetchSortedList(context) as [TeamDeck]
            case .teamDeck:
                try fetchSortedList(context) as [Hero]
            default:
                []
            }
        }catch{
            AlertHandler.shared.showMessage("Error: Cannot Fetch Data")
        }
    }
    
    func handleSubmit(){
        LoadingHandler.shared.showLoading()
        do{
            if operation == .add {
                try handleAdd()
            }else{
                try handleEdit()
            }
            AlertHandler.shared.showMessage("Saved")
        }catch OperationError.EditError{
            AlertHandler.shared.showMessage("Error: Save Failed")
        }catch OperationError.InsertError{
            AlertHandler.shared.showMessage("Error: Add Failed")
        }catch{
            AlertHandler.shared.showMessage("Error: Unexpected Error")
        }
        LoadingHandler.shared.closeLoading()
    }
    
    func handleAdd()throws{
        switch data{
            case .hero:
                let fetchDescriptor = FetchDescriptor<Hero>(predicate: #Predicate{$0.name == name})
                let fetchedItems = try context.fetch(fetchDescriptor)
                if !fetchedItems.isEmpty{ throw OperationError.InsertError }
                context.insert(Hero(name: name,teamDecks: Array(relatedTeamDeck), figureContainer: figureContainer))
            case .campaign:
                let fetchDescriptor = FetchDescriptor<Campaign>(predicate: #Predicate{$0.name == name})
                let fetchedItems = try context.fetch(fetchDescriptor)
                if !fetchedItems.isEmpty{ throw OperationError.InsertError }
                context.insert(Campaign(name: name))
            case .companion:
                let fetchDescriptor = FetchDescriptor<Companion>(predicate: #Predicate{$0.name == name})
                let fetchedItems = try context.fetch(fetchDescriptor)
                if !fetchedItems.isEmpty{ throw OperationError.InsertError }
                context.insert(Companion(name:name))
            case .location:
                let fetchDescriptor = FetchDescriptor<Location>(predicate: #Predicate{$0.name == name})
                let fetchedItems = try context.fetch(fetchDescriptor)
                if !fetchedItems.isEmpty{ throw OperationError.InsertError }
                context.insert(Location(name: name, isHazardous: isHazardous))
            case .teamDeck:
                let fetchDescriptor = FetchDescriptor<TeamDeck>(predicate: #Predicate{$0.name == name})
                let fetchedItems = try context.fetch(fetchDescriptor)
                if !fetchedItems.isEmpty{ throw OperationError.InsertError }
                context.insert(TeamDeck(name: name, heroes: Array(relatedHeroes)))
            case .villain:
                let fetchDescriptor = FetchDescriptor<Villain>(predicate: #Predicate{$0.name == name})
                let fetchedItems = try context.fetch(fetchDescriptor)
                if !fetchedItems.isEmpty{ throw OperationError.InsertError }
                context.insert(Villain(name: name, figureContainer:figureContainer))
            }
    }
    
    func handleEdit()throws{
        guard let editingUUID = editingUUID else {
            AlertHandler.shared.showMessage("Missing editingId")
            throw OperationError.EditError
        }
        switch data{
        case .hero:
            let fetchDescriptor = FetchDescriptor<Hero>(predicate: #Predicate{$0.UUID == editingUUID})
            let fetchedItems = try context.fetch(fetchDescriptor)
            fetchedItems[0].name = name
            fetchedItems[0].teamDecks = Array(relatedTeamDeck)
            fetchedItems[0].figureContainer = figureContainer
        case .campaign:
            let fetchDescriptor = FetchDescriptor<Campaign>(predicate: #Predicate{$0.UUID == editingUUID})
            let fetchedItems = try context.fetch(fetchDescriptor)
            fetchedItems[0].name = name
        case .companion:
            let fetchDescriptor = FetchDescriptor<Companion>(predicate: #Predicate{$0.UUID == editingUUID})
            let fetchedItems = try context.fetch(fetchDescriptor)
            fetchedItems[0].name = name
        case .location:
            let fetchDescriptor = FetchDescriptor<Location>(predicate: #Predicate{$0.UUID == editingUUID})
            let fetchedItems = try context.fetch(fetchDescriptor)
            fetchedItems[0].name = name
            fetchedItems[0].isHazardous = isHazardous
        case .teamDeck:
            let fetchDescriptor = FetchDescriptor<TeamDeck>(predicate: #Predicate{$0.UUID == editingUUID})
            let fetchedItems = try context.fetch(fetchDescriptor)
            fetchedItems[0].name = name
            fetchedItems[0].heroes = Array(relatedHeroes)
        case .villain:
            let fetchDescriptor = FetchDescriptor<Villain>(predicate: #Predicate{$0.UUID == editingUUID})
            let fetchedItems = try context.fetch(fetchDescriptor)
            fetchedItems[0].name = name
            fetchedItems[0].figureContainer = figureContainer
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
                let fetchedItems = try context.fetch(fetchDescriptor)
                context.delete(fetchedItems[0])
            case .campaign:
                let fetchDescriptor = FetchDescriptor<Campaign>(predicate: #Predicate{$0.UUID == editingUUID})
                let fetchedItems = try context.fetch(fetchDescriptor)
                context.delete(fetchedItems[0])
            case .companion:
                let fetchDescriptor = FetchDescriptor<Companion>(predicate: #Predicate{$0.UUID == editingUUID})
                let fetchedItems = try context.fetch(fetchDescriptor)
                context.delete(fetchedItems[0])
            case .location:
                let fetchDescriptor = FetchDescriptor<Location>(predicate: #Predicate{$0.UUID == editingUUID})
                let fetchedItems = try context.fetch(fetchDescriptor)
                context.delete(fetchedItems[0])
            case .teamDeck:
                let fetchDescriptor = FetchDescriptor<TeamDeck>(predicate: #Predicate{$0.UUID == editingUUID})
                let fetchedItems = try context.fetch(fetchDescriptor)
                context.delete(fetchedItems[0])
            case .villain:
                let fetchDescriptor = FetchDescriptor<Villain>(predicate: #Predicate{$0.UUID == editingUUID})
                let fetchedItems = try context.fetch(fetchDescriptor)
                context.delete(fetchedItems[0])
            }
        }catch{
            AlertHandler.shared.showMessage("Cannot Fetch Data")
        }
        LoadingHandler.shared.closeLoading()
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let container = previewModelContainer()
    migrateSampleData(container.mainContext)
    
    return ItemView(operation: .edit, data:.teamDeck).modelContainer(container)
}
