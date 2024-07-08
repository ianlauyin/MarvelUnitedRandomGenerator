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
    @State private var extraList : [any PersistentModel] = []
    var editingUUID : UUID?
    
    
    var body: some View {
        VStack{
            if data == .hero{
                if let extraList = extraList as? [TeamDeck]{
                    List(extraList, id:\.self ,selection:$relatedTeamDeck){item in
                        Text(item.name)
                    }.environment(\.editMode , .constant(.active))
                        .scrollContentBackground(.hidden)
                    Text("Related Team")
                }else{
                    EmptyView()
                }
            }
            if data == .teamDeck{
                if let extraList = extraList as? [Hero]{
                        List(extraList, id:\.self ,selection:$relatedHeroes){item in
                            Text(item.name)
                        }.environment(\.editMode , .constant(.active))
                        .scrollContentBackground(.hidden)
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
        }.onAppear{fetchList()}
        .navigationTitle("\(operation.name) \(data.name)")
            .toolbar{
                ToolbarItem(){
                    Button("Save"){handleSubmit()}
                }
            }
    }
    
    func fetchList(){
        do{
            switch data{
            case .hero:
                let fetchDescriptor = FetchDescriptor<TeamDeck>(sortBy: [SortDescriptor(\TeamDeck.name)])
                let fetchedItems:[TeamDeck] = try context.fetch(fetchDescriptor)
                extraList = fetchedItems
            case .teamDeck:
                let fetchDescriptor = FetchDescriptor<Hero>(sortBy: [SortDescriptor(\Hero.name)])
                let fetchedItems:[Hero] = try context.fetch(fetchDescriptor)
                extraList = fetchedItems
            default:
                return
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
    
    let sampleRelatedHero = Hero(name:"RH1",teamDecks: [], figureContainer:"1")
    let sampleRelatedTeam = TeamDeck(name:"RT1",heroes: [])
    container.mainContext.insert(sampleRelatedTeam)
    container.mainContext.insert(sampleRelatedHero)
    sampleRelatedHero.teamDecks.append(sampleRelatedTeam)
    sampleRelatedTeam.heroes.append(sampleRelatedHero)
    
    
    for heroData in Data.hero.sampleData{
        if let heroDict = heroData as? [String: String],
               let name = heroDict["name"],
               let figureContainer = heroDict["figureContainer"] {
                let hero = Hero(name: name, teamDecks: [], figureContainer: figureContainer)
                container.mainContext.insert(hero)
            }
    }
    for teamName in Data.teamDeck.sampleData{
        let team = TeamDeck(name: teamName as! String, heroes:[])
        container.mainContext.insert(team)
    }
    
    return ItemView(operation: .edit, data:.teamDeck).modelContainer(container)
}
