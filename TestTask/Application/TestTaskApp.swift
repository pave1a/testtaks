//
//  TestTaskApp.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import SwiftUI

@main
struct TestTaskApp: App {
    var body: some Scene {
        WindowGroup {
            let usersBaseService = UsersBaseService()
//            UsersListView(viewModel: UsersListViewModel(usersBaseService: usersBaseService))
            RootView()
        }
    }
}
