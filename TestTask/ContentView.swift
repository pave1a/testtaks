//
//  ContentView.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(AppStyles.Fonts.heading)
        }
        .padding()
        .background(AppStyles.Colors.background)
    }
}

#Preview {
    ContentView()
}
