//
//  SubListView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 3/7/2024.
//

import SwiftUI
import SwiftData

struct SubListView<T: PersistentModel>: View {
    @Query private var allItems: [T]
    var data: Data?
    
    init(){
        data = switch T.self {
            case is Location.Type:.location
            case is Hero.Type:.hero
            case is Villain.Type:.villain
            case is Campaign.Type:.campaign
            case is Companion.Type:.companion
            case is TeamDeck.Type:.teamDeck
            default: nil
            }
        if data == nil{
            ErrorHandler.shared.showError("Error: Wrong Type of data")
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(allItems, id: \.self) { item in
                    switch data {
                    case .location:
                        if let location = item as? Location {
                            NavigationLink(location.name) {
                                ItemView(data: .location)
                            }
                        }
                    case .hero:
                        if let hero = item as? Hero {
                            NavigationLink(hero.name) {
                                ItemView(data: .hero)
                            }
                        }
                    case .villain:
                        if let villain = item as? Villain {
                            NavigationLink(villain.name) {
                                ItemView(data: .villain)
                            }
                        }
                    case .campaign:
                        if let campaign = item as? Campaign {
                            NavigationLink(campaign.name) {
                                ItemView(data: .campaign)
                            }
                        }
                    case .companion:
                        if let companion = item as? Companion {
                            NavigationLink(companion.name) {
                                ItemView(data: .companion)
                            }
                        }
                    case .teamDeck:
                        if let teamDeck = item as? TeamDeck {
                            NavigationLink(teamDeck.name) {
                                ItemView(data: .teamDeck)
                            }
                        }
                    default:
                        EmptyView()
                    }
                }
            }
            .navigationTitle(data?.name ?? "" + " List")
        }
    }
}

#Preview {
    SubListView<Location>().modelContainer(for: Data.allCases.compactMap{data in data.model})
}
