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


struct ItemView<T:HashableNamedDataType>: View {
    var operation : ItemViewOperation
    var editingData : T?
    var dataType : Data? = nil
    
    @State var isLoading : Bool = false
    @State var name : String = ""
    @State var figureContainer : String = ""
    @State var isHazardous = false
    @State var relatedTeamDeck : Set<TeamDeck> = Set()
    @State var relatedHeroes: Set<Hero> = Set()
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode
    @State private var extraList : [any HashableNamedDataType] = []
    
    init(_ operation: ItemViewOperation , editingData:T? = nil) {
        self.operation = operation
        self.editingData = editingData
        self.dataType = try? convertGenericToDataType(T.self)
    }
    
    var body: some View {
        VStack{
            if let extraList = extraList as? [TeamDeck],
               dataType == .hero{
                SelectionList(list: extraList, selection: $relatedTeamDeck)
                Text("Related Team")
            }
            if let extraList = extraList as? [Hero],
               dataType == .teamDeck{
                SelectionList(list: extraList, selection: $relatedHeroes)
                Text("Related Heroes")
            }
            Form{
                Section{
                    HStack{
                        Text("Name")
                        TextField("Name",text:$name)
                            .multilineTextAlignment(.trailing)
                    }
                    switch dataType {
                    case .hero, .villain:
                        HStack{
                            Text("Figure Container")
                            TextField("Figure Container",text:$figureContainer)
                                .multilineTextAlignment(.trailing)
                        }
                    case .location:
                        Toggle(isOn: $isHazardous){
                            Text("Hazardous")
                        }
                    default:
                        EmptyView()
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
            .onAppear{
                fetchExtraList()
                migrateEditingData()
            }
            .navigationTitle("\(operation.name) \(dataType?[] ?? "")")
            .toolbar{
                ToolbarItem(){
                    Button("Save"){handleSubmit()}
                }
            }
    }
    
    func fetchExtraList(){
        isLoading = true
        do{
            extraList = switch dataType{
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
    
    private func migrateEditingData(){
        if let initData = editingData{
            self.name = initData.name
            if let initData = initData as? Hero{
                    self.figureContainer = initData.figureContainer
                    self.relatedTeamDeck = Set(initData.teamDecks)
            }
            if let initData = initData as? Villain{
                    self.figureContainer = initData.figureContainer
            }
            if let initData = initData as? TeamDeck{
                    self.relatedHeroes = Set(initData.heroes)
            }
            if let initData = initData as? Location{
                    self.isHazardous = initData.isHazardous
            }
        }
    }
    
    private func handleSubmit(){
        isLoading = true
        do{
            if operation == .add {
                try handleAdd()
            }else{
                handleEdit()
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
        let newData : any HashableNamedDataType = switch dataType{
            case .hero:
                Hero(name: name, teamDecks: [], figureContainer: figureContainer)
            case .campaign:
                Campaign(name: name)
            case .companion:
                Companion(name:name)
            case .location:
                Location(name: name, isHazardous: isHazardous)
            case .teamDeck:
                TeamDeck(name: name, heroes: [])
            case .villain:
                Villain(name: name, figureContainer:figureContainer)
        case .none:
            throw OperationError.InsertError
        }
        try addItem(context,data:newData,relatedHeroes: (newData is TeamDeck) ? Array(relatedHeroes) : nil, relatedTeamDecks: (newData is Hero) ? Array(relatedTeamDeck) : nil)
    }
    
    func handleEdit(){
        if var editingData = editingData{
            var relatedList : [any HashableNamedDataType]? = nil
            var newInfo : [String:Any] = ["name":name]
            switch editingData{
            case is Hero:
                newInfo["figureContainer"] = figureContainer
                relatedList = Array(relatedTeamDeck)
            case is Villain:
                newInfo["figureContainer"] = figureContainer
            case is Location:
                newInfo["isHazardous"] = isHazardous
            case is TeamDeck:
                relatedList = Array(relatedHeroes)
            default: break
            }
            updateItem(&editingData,newInfo: newInfo, relatedList: relatedList)
        }
    }
    
    func handleDelete(){
        guard let editingData = editingData else {
            AlertHandler.shared.showMessage("Cannot find Data to Delete")
            return
        }
        isLoading = true
        deleteItem(context, data: editingData)
        isLoading = false
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let container = previewModelContainer()
    migrateSampleData(container.mainContext)
    
    return ItemView<Companion>(.edit,editingData: Companion(name: "C1")).modelContainer(container)
}
