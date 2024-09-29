//
//  DashboardTabItem.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 29.09.2024.
//

enum DashboardTabItem {
    case users, signUp

    var title: String {
        switch self {
        case .users:
            return "Users"
        case .signUp:
            return "Sign up"
        }
    }

    var iconName: String {
        switch self {
        case .users:
            return "usersGroup"
        case .signUp:
            return "userPlus"
        }
    }
}
