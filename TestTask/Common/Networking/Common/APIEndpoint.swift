//
//  APIEndpoint.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import Foundation

enum UserAPIEndpoint {
    case getUsers(page: Int, count: Int)
    
    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        }
    }
}
