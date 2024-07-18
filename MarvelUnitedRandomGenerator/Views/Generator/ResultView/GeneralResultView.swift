//
//  LocationResultView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 16/7/2024.
//

import SwiftUI

struct GeneralResultView: View {
    var names : [String]
    
    var body: some View {
        ForEach(names,id:\.self){name in
            HStack {
                Text("Name: ")
                Spacer()
                Text(name)
            }
        }
    }
}

