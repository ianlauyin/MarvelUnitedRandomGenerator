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
                        NavigationLink("Add " + data[]){
                            ItemView(operation:.add,data:data)
                            }
                        }
                }else{
                    ForEach(Data.allCases,id:\.self){data in
                        if data == .hero{
                            NavigationLink("Hero list") {
                                SubListView<Hero>()
                            }
                        }else if data == .villain{
                            NavigationLink("Villain list") {
                                SubListView<Villain>()
                            }
                        }else if data == .campaign{
                            NavigationLink("Campaign list") {
                                SubListView<Campaign>()
                            }
                        }else if data == .companion{
                            NavigationLink("Companion list") {
                                SubListView<Companion>()
                            }
                        }else if data == .teamDeck{
                            NavigationLink("Team Deck list") {
                                SubListView<TeamDeck>()
                            }
                        }else if data == .location{
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

#Preview {
    let container = previewModelContainer()
    migrateSampleData(container.mainContext)

    return ListView(listItem: .add).modelContainer(container)
}
