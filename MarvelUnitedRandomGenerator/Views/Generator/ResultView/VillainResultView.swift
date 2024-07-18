//
//  VillainResultView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 16/7/2024.
//

import SwiftUI

struct VillainResult:Hashable{
    var name: String
    var figureContainer: String
}

struct VillainResultView: View {
    var villains : [VillainResult]
    var body: some View {
        ScrollView{
            HStack{
                Text("Villain:")
                Spacer()
                Text("No.").frame(width:30)
            }.padding(.horizontal)
            Divider()
            ForEach(villains,id:\.self){villain in
                HStack{
                    Text(villain.name)
                    Spacer()
                    Text(villain.figureContainer)
                        .frame(width:30)
                }.padding(.horizontal)
            }
        }
    }
}
