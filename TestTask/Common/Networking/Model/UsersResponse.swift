//
//  UsersResponse.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import Foundation

struct UsersResponse: Codable {
    let success: Bool
    let page: Int
    let totalPages: Int
    let totalUsers: Int
    let count: Int
    let links: Links
    let users: [User]

    enum CodingKeys: String, CodingKey {
        case success, page, count, links, users
        case totalPages = "total_pages"
        case totalUsers = "total_users"
    }
}
