//
//  ContentView.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import SwiftUI

struct UsersListView: View {
    @StateObject private var viewModel: UsersListViewModel

    private let service = UsersBaseService()

    init(viewModel: UsersListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
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
    }
}

class UsersListViewModel: ObservableObject {
    
}


struct UserCard: View {
    let user: User
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: URL(string: user.photo)) { image in
                image
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 50)
            }
            .padding(.top, 24)
            .padding(.leading, 16)

            VStack(alignment: .leading, spacing: 8) {
                Text(user.name)
                    .font(.headline)
                
                Text(user.position)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(user.email)
                    .font(.subheadline)
                
                Text(user.phone)
                    .font(.subheadline)
            }
            .padding(.top, 24)
            .padding(.trailing, 16)
        }
        .padding(.vertical, 24)
    }
}


#Preview {
    ContentView()
}
