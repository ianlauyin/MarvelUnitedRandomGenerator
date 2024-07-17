//
//  HeroResultView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 16/7/2024.
//

import SwiftUI


struct HeroResult:Hashable{
    var name : String
    var figureContainer : String? = nil
    var useEquipment : Bool? = nil
    var companion: String? = nil
}

struct HeroResultView: View {
    var heroResults : [HeroResult]
    
    var body: some View {
        ScrollView{
            HStack{
                Text("Hero:")
                Spacer()
                Text("Equipment:")
                Text("No.").frame(width:30)
            }.padding(.horizontal)
            Divider()
            ForEach(heroResults,id:\.self){heroResult in
                HStack{
                    Text(heroResult.name)
                    Spacer()
                    if heroResult.useEquipment != nil {
                        Text(heroResult.useEquipment! ? "Use" : "Not Use")
                    }
                    Text(heroResult.figureContainer ?? "")
                        .frame(width:30)
                }.padding(.horizontal)
                if let companion = heroResult.companion{
                    HStack{
                        Text("   Companion:")
                        Text(companion)
                        Spacer()
                    }.padding(.horizontal)
                }
            }
        }
    }
}
