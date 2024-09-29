//
//  UsersListViewModel.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import SwiftUI

class UsersListViewModel: ObservableObject {
    @Published var users = [User]()

    private let userService: UsersBaseProtocol

    private var currentPage = 1
    private var hasMorePages = true

    var isLoading = false

    init(userService: UsersBaseProtocol = UsersBaseService()) {
        self.userService = userService
    }
    
    func fetchUsers() {
        guard !isLoading, hasMorePages else { return }
        isLoading = true

        Task {
            do {
                let fetchedUsersResponse = try await userService.getUsers(page: currentPage, count: 6)
                DispatchQueue.main.async {
                    let sortedUsers = fetchedUsersResponse.users.sorted { $0.registrationTimestamp > $1.registrationTimestamp }
                    self.users.append(contentsOf: sortedUsers)

                    self.currentPage += 1
                    self.hasMorePages = self.currentPage <= fetchedUsersResponse.totalPages
                    
                    self.isLoading = false
                }
            } catch {
                print("Error fetching users: \(error)")
                isLoading = false
            }
        }
    }
}
