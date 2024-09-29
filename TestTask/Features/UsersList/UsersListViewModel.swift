//
//  UsersListViewModel.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import SwiftUI

class UsersListViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var isLoading = false

    private let usersBaseService: UsersBaseProtocol

    private let countToFetch = 6
    private var currentPage = 1
    private var hasMorePages = true

    init(usersBaseService: UsersBaseProtocol) {
        self.usersBaseService = usersBaseService
    }

    func fetchUsers() {
        guard !isLoading, hasMorePages else { return }
        isLoading = true

        Task {
            defer {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }

            do {
                let fetchedUsersResponse = try await usersBaseService.getUsers(page: currentPage, count: countToFetch)

                if fetchedUsersResponse.users.isEmpty || currentPage > fetchedUsersResponse.totalPages {
                    hasMorePages = false
                } else {
                    appendSortedUsers(fetchedUsersResponse.users)
                    currentPage += 1
                }
            } catch {
                print("Error fetching users: \(error)")
            }
        }
    }

    private func appendSortedUsers(_ newUsers: [User]) {
        let sortedUsers = newUsers.sorted { $0.registrationTimestamp > $1.registrationTimestamp }
        DispatchQueue.main.async {
            self.users.append(contentsOf: sortedUsers)
        }
    }
}
