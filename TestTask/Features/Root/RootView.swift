//
//  RootView.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 29.09.2024.
//

import SwiftUI

struct RootView: View {
    @State private var selectedTab: DashboardTabItem = .users
    @StateObject private var viewModel: RootViewModel

    init(viewModel: RootViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        // TODO: Fix tab items vertical style
        TabView(selection: $selectedTab) {
            UsersListView(viewModel: viewModel.usersListViewModel)
                .tabItem {
                    DashboardTabItemView(tab: .users, selected: $selectedTab)
                }
                .tag(DashboardTabItem.users)

            UserSignupView(viewModel: viewModel.userSignupViewModel)
                .tabItem {
                    DashboardTabItemView(tab: .signUp, selected: $selectedTab)
                }
                .tag(DashboardTabItem.signUp)
        }
    }
}
