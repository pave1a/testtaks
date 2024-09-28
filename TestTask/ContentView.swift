//
//  ContentView.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var name: String = ""

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(AppStyles.Fonts.heading)
            PrimaryButton(title: "Normal", action: {}, disabled: false)
            FloatingTextField(text: $name, fieldType: .basic, title: "Title", validationMessage: "No", isValid: false, onSubmit: {})

            Spacer()
        }
        .padding()
        .background(AppStyles.Colors.background)
    }
}

#Preview {
    ContentView()
}
