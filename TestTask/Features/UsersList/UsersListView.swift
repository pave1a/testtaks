//
//  UsersListView.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import SwiftUI

struct UsersListView: View {
    @StateObject private var viewModel: UsersListViewModel

    private let service = UsersBaseService()

    init(viewModel: UsersListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.users) { user in
                    UserCard(user: user)
                        .listRowBackground(Color.clear)
                        .onAppear {
                            if user == viewModel.users.last {
                                viewModel.fetchUsers()
                            }
                        }
                    // TODO: - Add Loader
                }
                .listStyle(.plain)
                .onAppear {
                    viewModel.fetchUsers()
                }
            }
            .navigationTitle(Constants.Strings.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private enum Constants {
    enum Strings {
        static let title = "Working with GET request"
    }
}

#Preview {
    UsersListView(viewModel: UsersListViewModel(usersBaseService: UsersBaseService()))
}
