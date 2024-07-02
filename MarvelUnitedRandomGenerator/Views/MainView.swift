//
//  MainView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack{
            Button("Test 1"){
                ErrorHandler.shared.showError("111")
            }
            Button("Test 2"){
                ErrorHandler.shared.showError("222")
            }
        }.errorAlert()
    }
}

#Preview {
    MainView()
}
