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
                        locationList
                    case .hero:
                        heroList
                    case .villain:
                        villainList
                    case .campaign:
                        campaignList
                    case .companion:
                        companionList
                    case .teamDeck:
                        teamDeckList
                    case .none:
                        EmptyView()
                    }
                }
                .navigationTitle(data?[] ?? "" + " List")
            }
        }
        
        @ViewBuilder
        private var locationList: some View {
            if let locations = allItems as? [Location] {
                ForEach(locations.sorted(by: { $0.name < $1.name }), id: \.self) { location in
                    NavigationLink(location.name) {
                        ItemView(operation: .edit, data: .location, name: location.name, isHazardous: location.isHazardous, editingUUID: location.UUID)
                    }
                }
            }
        }
        
        @ViewBuilder
        private var heroList: some View {
            if let heroes = allItems as? [Hero] {
                ForEach(heroes.sorted(by: { $0.name < $1.name }), id: \.self) { hero in
                    NavigationLink(hero.name) {
                        ItemView(operation: .edit, data: .hero, name: hero.name, figureContainer: hero.figureContainer,
                                 relatedTeamDeck: Set(hero.teamDecks), editingUUID: hero.UUID)
                    }
                }
            }
        }
        
        @ViewBuilder
        private var villainList: some View {
            if let villains = allItems as? [Villain] {
                ForEach(villains.sorted(by: { $0.name < $1.name }), id: \.self) { villain in
                    NavigationLink(villain.name) {
                        ItemView(operation: .edit, data: .villain, name: villain.name,
                                 figureContainer: villain.figureContainer, editingUUID: villain.UUID)
                    }
                }
            }
        }
        
        @ViewBuilder
        private var campaignList: some View {
            if let campaigns = allItems as? [Campaign] {
                ForEach(campaigns.sorted(by: { $0.name < $1.name }), id: \.self) { campaign in
                    NavigationLink(campaign.name) {
                        ItemView(operation: .edit, data: .campaign, name: campaign.name, editingUUID: campaign.UUID)
                    }
                }
            }
        }
        
        @ViewBuilder
        private var companionList: some View {
            if let companions = allItems as? [Companion] {
                ForEach(companions.sorted(by: { $0.name < $1.name }), id: \.self) { companion in
                    NavigationLink(companion.name) {
                        ItemView(operation: .edit, data: .companion, name: companion.name, editingUUID: companion.UUID)
                    }
                }
            }
        }
        
        @ViewBuilder
        private var teamDeckList: some View {
            if let teamDecks = allItems as? [TeamDeck] {
                ForEach(teamDecks.sorted(by: { $0.name < $1.name }), id: \.self) { teamDeck in
                    NavigationLink(teamDeck.name) {
                        ItemView(operation: .edit, data: .teamDeck, name: teamDeck.name, relatedHeroes: Set(teamDeck.heroes), editingUUID: teamDeck.UUID)
                    }
                }
            }
        }
}

#Preview {
    let container = previewModelContainer()
    migrateSampleData(container.mainContext)
    
    return SubListView<Location>().modelContainer(container)
}
