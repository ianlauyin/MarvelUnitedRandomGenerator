//
//  PlayGeneratorLocationGeneratorView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 18/7/2024.
//

import SwiftUI
import SwiftData

struct PlayGeneratorLocationGeneratorView: View {
    @Query(sort:\Location.name) private var locations : [Location]
    @State private var selection = Set<Location>()
    @State private var count : Int = 1
    var onClick : (_ count:Int ,_ list:[Location])->Void
    
    var body: some View {
        VStack{
            Text("Select Location:")
            SelectionList(list: locations, selection: $selection)
                .frame(height:400)
            Picker("Number",selection: $count){
                ForEach((1...6), id:\.self){
                    Text(String($0))
                }
            }.padding(.vertical)
                .pickerStyle(.segmented)
                .padding(.horizontal)
            Button("Confirm"){
                onClick(count, Array(selection))
            }
        }.onAppear{selection = Set(locations)}
    }
}

