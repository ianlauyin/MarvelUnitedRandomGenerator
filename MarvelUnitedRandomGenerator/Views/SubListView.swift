//
//  SubListView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 3/7/2024.
//

import SwiftUI
import SwiftData

struct SubListView<T: PersistentModel>: View {
    var data: Data?
    @Query var allItems: [T]
    
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
            AlertHandler.shared.showMessage("Error: Wrong Type of data")
        }
    }
    
    var body: some View {
        VStack {
            List {
                    switch data {
                    case .location:
                        if let locations = allItems as? [Location] {
                            ForEach(locations.sorted(by: { $0.name < $1.name }), id: \.self) { location in
                                NavigationLink(location.name) {
                                    ItemView(operation:.edit, data: .location, name:location.name,isHazardous: location.isHazardous,editingUUID:location.UUID)
                                }
                            }
                        }
                    case .hero:
                        if let heroes = allItems as? [Hero] {
                            ForEach(heroes.sorted(by: { $0.name < $1.name }), id: \.self) { hero in
                                NavigationLink(hero.name) {
                                    ItemView(operation:.edit, data:.hero, name:hero.name, figureContainer:hero.figureContainer,editingUUID:hero.UUID)
                                }
                            }
                        }
                    case .villain:
                        if let villains = allItems as? [Villain] {
                                ForEach(villains.sorted(by: { $0.name < $1.name }), id: \.self) { villain in
                                NavigationLink(villain.name) {
                                    ItemView(operation:.edit, data: .villain, name:villain.name,
                                             figureContainer:villain.figureContainer,editingUUID:villain.UUID)
                                }
                            }
                        }
                    case .campaign:
                        if let campaigns = allItems as? [Campaign] {
                                    ForEach(campaigns.sorted(by: { $0.name < $1.name }), id: \.self) { campaign in
                                NavigationLink(campaign.name) {
                                    ItemView(operation:.edit, data: .campaign, name:campaign.name,editingUUID:campaign.UUID)
                                }
                            }
                        }
                    case .companion:
                        if let companions = allItems as? [Companion] {
                                        ForEach(companions.sorted(by: { $0.name < $1.name }), id: \.self) { companion in
                                NavigationLink(companion.name) {
                                    ItemView(operation:.edit, data: .companion, name:companion.name,editingUUID:companion.UUID)
                                }
                            }
                        }
                    case .teamDeck:
                        if let teamDecks = allItems as? [TeamDeck] {
                            ForEach(teamDecks.sorted(by: { $0.name < $1.name }), id: \.self) { teamDeck in
                                NavigationLink(teamDeck.name) {
                                    ItemView(operation:.edit, data: .teamDeck, name:teamDeck.name, editingUUID:teamDeck.UUID)
                                }
                            }
                        }
                    default:
                        EmptyView()
                }
            }
            .navigationTitle(data?.name ?? "" + " List")
        }
    }
}

#Preview {
    let container = previewModelContainer()
    
    for locationName in Data.location.sampleData{
        let location = Location(name: locationName as! String, isHazardous: false)
        container.mainContext.insert(location)
    }
    
    return SubListView<Location>().modelContainer(container)
}
