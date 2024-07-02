//
//  ContentView.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 27/6/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Text("Hello World")
    }
}

#Preview {
    ContentView()
}
