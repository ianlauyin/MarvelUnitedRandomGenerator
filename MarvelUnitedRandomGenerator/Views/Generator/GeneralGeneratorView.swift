//
//  VillainGeneratorView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 9/7/2024.
//

import SwiftUI
import SwiftData

struct GeneralGeneratorView<T:HashableNamedDataType>: View {
    @Query(sort: \T.name) var list : [T]
    @Environment(\.modelContext) private var context
    @State private var isLoading : Bool = false
    @State private var selection = Set<T>()
    @State private var count : Int = 1
    @State private var includeUsed : Bool = false
    
    @State private var results : [T] = []
    
    private var typeName:String = switch T.self{
    case is Location.Type: "Location"
    case is Villain.Type: "Villain"
    default: ""
    }
    
    var body: some View {
        VStack{
            Text("Select \(typeName)")
            List(list, id: \.self, selection: $selection) { item in
                    Text(item.name)
            }.environment(\.editMode ,.constant(EditMode.active))
            .frame(height:400)
            .scrollContentBackground(.hidden)
            Toggle(isOn: $includeUsed){
                Text("Include Used?")
            }.padding(.horizontal)
            Divider().foregroundStyle(.black).padding()
            Picker("Number",selection: $count){
                ForEach((1...6), id:\.self){
                    Text("\($0)")
                }
            }.pickerStyle(.segmented)
                .padding(.horizontal)
            if results.count != 0{
                switch T.self{
                case is Location.Type: LocationResultView(locations: results as! [Location])
                case is Villain.Type: VillainResultView(villains: results as! [Villain])
                default: EmptyView()
                }
            }
            Spacer()
        }.loadingCover($isLoading)
            .onAppear{selection = Set(list)}
            .toolbar{Button("Generate"){generate()}}
    }
    
    func generate(){
        isLoading = true
        do{
            var list = Array(selection)
            results = try generateRandomList(context, count: count, list: &list, includeUsed: includeUsed)
        }catch{
            AlertHandler.shared.showMessage("Cannot generate")
        }
        print(list.map{$0.name})
        print(list.map{$0.isUsed})
        isLoading = false
    }
}

#Preview {
    let container = previewModelContainer()
    migrateSampleData(container.mainContext)
    
    return GeneralGeneratorView<Villain>().modelContainer(container)
}
