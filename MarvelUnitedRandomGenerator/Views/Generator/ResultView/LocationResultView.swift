//
//  LocationResultView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 16/7/2024.
//

import SwiftUI

struct LocationResultView: View {
    var locations : [Location]
    
    var body: some View {
        ForEach(locations,id:\.self){
            Text($0.name)
        }
    }
}

