//
//  ItemListView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import SwiftUI


struct ItemListView: View {
    var body: some View {
        NavigationStack{
            List{
                ForEach(Data.allCases,id:\.self){data in
                    NavigationLink("\(data.name) List"){SubListView(data: data)}
                }
            }
        }
    }
}

#Preview {
    ItemListView()
}
