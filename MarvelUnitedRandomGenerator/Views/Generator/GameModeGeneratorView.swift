//
//  GameModeGeneratorView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 9/7/2024.
//

import SwiftUI

struct GameModeGeneratorView: View {
    @State private var selection = Set<GameMode>(GameMode.allCases)
    @State private var isLoading = false
    @State private var result :String = ""
    var body: some View {
        VStack{
            List(GameMode.allCases, id:\.self , selection: $selection){
                Text($0.name)
            }.frame(height:400)
                .scrollContentBackground(.hidden)
                .environment(\.editMode ,.constant(EditMode.active))
            Text(result)
            Spacer()
        }.loadingCover($isLoading)
            .toolbar{Button("Generate"){generate()}}
    }
    
    func generate(){
        isLoading = true
        result = selection.randomElement()?.name ?? "Error"
        isLoading = false
    }
}

#Preview {
    let container = previewModelContainer()
    migrateSampleData(container.mainContext)
    
    return GameModeGeneratorView().modelContainer(container)
}
