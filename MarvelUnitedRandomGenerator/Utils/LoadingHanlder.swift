//
//  LoadingHanlder.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 3/7/2024.
//


import Foundation
import SwiftUI

class LoadingHandler : ObservableObject{
    static let shared = LoadingHandler()
    @Published private(set) var isLoading : Bool = false
    
    func closeLoading(){
        isLoading = false
    }
    
    func showLoading(){
        isLoading = true
    }
}

struct LoadingModifier: ViewModifier {
    @StateObject var loadingHandler = LoadingHandler.shared
    
    func body(content: Content) -> some View {
        content.overlay{
            if loadingHandler.isLoading{
                ZStack{
                    ProgressView()
                    Rectangle()
                        .foregroundStyle(.opacity(0.8))
                        .ignoresSafeArea()
                }
            }
        }
    }
}

extension View {
    func loadingCover() -> some View {
        self.modifier(LoadingModifier())
    }
}

