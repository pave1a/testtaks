//
//  RootView.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 29.09.2024.
//

import SwiftUI

struct RootView: View {
    @State private var selectedTab: DashboardTabItem = .users

    var body: some View {
        // TODO: Fix tab items vertical style
        TabView(selection: $selectedTab) {
            UsersListView(viewModel: UsersListViewModel(usersBaseService: UsersBaseService()))
                .tabItem {
                    DashboardTabItemView(tab: .users, selected: $selectedTab)
                }
                .tag(DashboardTabItem.users)

            UserSignupView()
                .tabItem {
                    DashboardTabItemView(tab: .signUp, selected: $selectedTab)
                }
                .tag(DashboardTabItem.signUp)
        }
    }
}
