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
    @State private var usedAfterDraw : Bool = true
    
    @State private var results : [T] = []
    
    private var typeName:String = switch T.self{
    case is Location.Type: "Location"
    case is Villain.Type: "Villain"
    default: ""
    }
    
    var body: some View {
        VStack{
            List(list, id: \.self, selection: $selection) { item in
                    Text(item.name)
            }.environment(\.editMode ,.constant(EditMode.active))
            .frame(height:400)
            .scrollContentBackground(.hidden)
            Toggle(isOn: $usedAfterDraw){
                Text("Used after draw?")
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
                case is Location.Type: 
                    GeneralResultView(names: convertTsToNames(results))
                case is Villain.Type:
                    VillainResultView(villains: convertTsToVillainResults(results))
                default: EmptyView()
                }
            }
            Spacer()
        }.loadingCover($isLoading)
            .onAppear{selection = Set(list)}
            .toolbar{Button("Generate"){generate()}}
    }
    
    func convertTsToNames(_ Ts:[T])->[String]{
        return Ts.map{$0.name}
    }
    
    func convertTsToVillainResults(_ Ts:[T])->[VillainResult]{
        let villains = Ts as! [Villain]
        return villains.map{VillainResult(name: $0.name, figureContainer: $0.figureContainer)}
    }
    
    func generate(){
        isLoading = true
        do{
            results = try generateRandomList(Array(selection), count: count, usedAfterDraw: usedAfterDraw)
        }catch{
            AlertHandler.shared.showMessage("Cannot generate")
        }
        isLoading = false
    }
}

