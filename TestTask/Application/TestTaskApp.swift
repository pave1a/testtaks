//
//  TestTaskApp.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import SwiftUI

@main
struct TestTaskApp: App {

    init() {
        setupNavigationBarAppearance()
    }

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: RootViewModel(usersBaseService: UsersBaseService()))
        }
    }

    func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppStyles.Colors.primary)

        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(AppStyles.Colors.primaryText),
            .font: UIFont(name: "Nunito-Regular", size: 20)!
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = .black
    }
}
