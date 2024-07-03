//
//  SubListView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 3/7/2024.
//

import SwiftUI

struct SubListView: View {
    var data : Data
    var body: some View {
        Text(data.name)
    }
}

#Preview {
    SubListView(data: Data.hero)
}
