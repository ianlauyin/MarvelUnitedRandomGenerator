//
//  PlayGeneratorView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 17/7/2024.
//

import SwiftUI

struct PlayResult{
    var isCampaign : Bool
    var name : String
    var playerCount : Int
    var opponentContainer : String? = nil
    var gameMode : String? = nil
    var teamDeck : String? = nil
    var heroResults : [HeroResult] = []
    var locations : [String] = []
}

struct PlayGeneratorView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var playResult : PlayResult? = nil
    @State private var isLoading : Bool = false
    @State private var isPopup: Bool = false
    
    
    var body: some View {
        VStack{if let playResult = playResult{
            VStack(spacing: 5){
                OpponentResult(isCampaign: playResult.isCampaign, name: playResult.name, opponentContainer: playResult.opponentContainer ?? "")
                if !playResult.isCampaign{
                    HeroResultView(heroResults: playResult.heroResults).frame(height:200)
                    Divider()
                    HStack{
                        Text("Game Mode:")
                        Spacer()
                        Text(playResult.gameMode ?? "No Game Mode")
                    }
                    HStack{
                        Text("Team Deck:")
                        Spacer()
                        Text(playResult.teamDeck ?? "No Team")
                    } .toolbar{Button("Add Locations"){isPopup = true}}
                }
                HStack{
                    Text("Player Count:")
                    Spacer()
                    Text(String(playResult.playerCount))
                }
            }.sheet(isPresented: $isPopup){PlayGeneratorLocationGeneratorView{generateLocation()}}.padding()
                .loadingCover($isLoading)
            }else{
                EmptyView()
            }
        }.onAppear{generateResult()}
    }
    
    @ViewBuilder
    func OpponentResult(isCampaign:Bool,name:String,opponentContainer:String) -> some View{
        VStack{
            if isCampaign{
                GeneralResultView(names: [name])
            }else{
                VillainResultView(villains: [VillainResult(name: name, figureContainer: opponentContainer)])
                Spacer().frame(height:50)
            }
        }
    }
    
    func generateResult(retryCount:Int = 10){
        if retryCount == 0 {
            AlertHandler.shared.showMessage("Please Re-enter again.")
            return dismiss()
        }
        isLoading = true
        do{
            playResult = try generatePlay(context)
        }catch{
            generateResult(retryCount: retryCount - 1)
        }
        isLoading = false
    }
    
    func generateLocation(){
        isPopup = false
    }
}

#Preview {
    let container = previewModelContainer()
    migrateSampleData(container.mainContext)
    
    return PlayGeneratorView().modelContainer(container)
}
