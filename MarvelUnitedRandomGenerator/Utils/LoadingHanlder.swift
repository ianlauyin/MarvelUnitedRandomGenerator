//
//  LoadingHanlder.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 3/7/2024.
//


import Foundation
import SwiftUI

struct LoadingModifier: ViewModifier {
    @Binding var isLoading : Bool
    
    func body(content: Content) -> some View {
        content.overlay{
            if isLoading{
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
    func loadingCover(_ isLoading: Binding<Bool>) -> some View {
        self.modifier(LoadingModifier(isLoading: isLoading))
    }
}

