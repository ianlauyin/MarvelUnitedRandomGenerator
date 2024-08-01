//
//  ItemListView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import SwiftUI

enum ListViewOption{
    case add
    case list
}

struct ListView: View {
    var listItem : ListViewOption
    
    var body: some View {
        NavigationStack{
            List{
                if listItem == .add{
                    ForEach(Data.allCases,id:\.self){data in
                        switch data{
                        case .hero:
                            NavigationLink("Add Hero") {
                                ItemView<Hero>(.add)
                            }
                        case .villain:
                            NavigationLink("Add Villain") {
                                ItemView<Villain>(.add)
                            }
                        case .campaign:
                            NavigationLink("Add Campaign") {
                                ItemView<Campaign>(.add)
                            }
                        case .companion:
                            NavigationLink("Add Companion") {
                                ItemView<Companion>(.add)
                            }
                        case .teamDeck:
                            NavigationLink("Add Team Deck") {
                                ItemView<TeamDeck>(.add)
                            }
                        case .location:
                            NavigationLink("Add Location") {
                                ItemView<Location>(.add)
                            }
                        }
                    }
                }else{
                    ForEach(Data.allCases,id:\.self){data in
                        switch data{
                        case .hero:
                            NavigationLink("Hero list") {
                                SubListView<Hero>()
                            }
                        case .villain:
                            NavigationLink("Villain list") {
                                SubListView<Villain>()
                            }
                        case .campaign:
                            NavigationLink("Campaign list") {
                                SubListView<Campaign>()
                            }
                        case .companion:
                            NavigationLink("Companion list") {
                                SubListView<Companion>()
                            }
                        case .teamDeck:
                            NavigationLink("Team Deck list") {
                                SubListView<TeamDeck>()
                            }
                        case .location:
                            NavigationLink("Location list") {
                                SubListView<Location>()
                            }
                        }
                    }
                }
            }
        }
    }
}
