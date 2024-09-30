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
    @ObservedObject private var reachability: ReachabilityManager

    init(viewModel: RootViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _reachability = ObservedObject(wrappedValue: viewModel.reachability)
    }

    var body: some View {
        ZStack {
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

            if !reachability.isConnected {
                StatusScreen(screenType: .noInternet)
                    .transition(.opacity)
            }
        }
        .onAppear {
            reachability.startMonitoring()
        }
    }
}
