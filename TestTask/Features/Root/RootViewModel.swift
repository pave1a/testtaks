//
//  RootViewModel.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 29.09.2024.
//

import Foundation

class RootViewModel: ObservableObject {
    @Published var usersListViewModel: UsersListViewModel
    @Published var userSignupViewModel: UserSignupViewModel

    var reachability = ReachabilityManager()

    init(usersBaseService: UsersBaseProtocol) {
        self.usersListViewModel = UsersListViewModel(usersBaseService: usersBaseService)
        self.userSignupViewModel = UserSignupViewModel(usersBaseService: usersBaseService)
    }
}
