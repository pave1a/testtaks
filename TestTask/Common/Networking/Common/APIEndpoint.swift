//
//  APIEndpoint.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import Foundation

enum UsersBaseAPIEndpoint {
    case getUsers(page: Int, count: Int)
    case getPositions
    
    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        case .getPositions:
            return "/positions"
        }
    }
}
