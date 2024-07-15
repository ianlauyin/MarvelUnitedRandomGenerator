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
    @State var isLoading : Bool = false
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
        }.loadingCover($isLoading)
            .onAppear{fetchExtraList()}
        .navigationTitle("\(operation.name) \(data[])")
            .toolbar{
                ToolbarItem(){
                    Button("Save"){handleSubmit()}
                }
            }
    }
    
    func fetchExtraList(){
        isLoading = true
        do{
            extraList = switch data{
            case .hero:
                try fetchList(context) as [TeamDeck]
            case .teamDeck:
                try fetchList(context) as [Hero]
            default:
                []
            }
        }catch{
            AlertHandler.shared.showMessage("Error: Cannot Fetch Data")
        }
        isLoading = false
    }
    
    func handleSubmit(){
        isLoading = true
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
        isLoading = false
    }
    
    func handleAdd()throws{
        let newData : any HashableNamedDataType = switch data{
            case .hero:
            Hero(name: name,teamDecks: Array(relatedTeamDeck), figureContainer: figureContainer)
            case .campaign:
            Campaign(name: name)
            case .companion:
            Companion(name:name)
            case .location:
                Location(name: name, isHazardous: isHazardous)
            case .teamDeck:
                TeamDeck(name: name, heroes: Array(relatedHeroes))
            case .villain:
                Villain(name: name, figureContainer:figureContainer)
            }
        try addItem(context,data:newData)
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
        isLoading = true
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
        isLoading = false
        presentationMode.wrappedValue.dismiss()
    }
    
    
}

#Preview {
    let container = previewModelContainer()
    migrateSampleData(container.mainContext)
    
    return ItemView(operation: .edit, data:.teamDeck).modelContainer(container)
}
