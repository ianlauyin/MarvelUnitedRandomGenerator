//
//  MainView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import SwiftUI
import SwiftData


struct MainView: View {
    var body: some View {
        TabView{
            Group{
                ListView(listItem:.add)
                    .tabItem{
                        Image(systemName: "plus.app")
                        Text("Add")
                    }
                GeneratorView()
                    .tabItem{
                        Image(systemName: "play.fill")
                        Text("Generate")
                    }
                ListView(listItem:.list)
                    .tabItem{
                        Image(systemName:"list.bullet.clipboard.fill")
                        Text("List")
                    }
            }.toolbarBackground(.gray.opacity(0.3), for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.light, for: .tabBar)
        }.customAlert()
    }
}


