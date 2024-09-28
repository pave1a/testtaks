//
//  LinkResponse.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import Foundation

struct Links: Codable {
    let nextUrl: String?
    let prevUrl: String?

    enum CodingKeys: String, CodingKey {
        case nextUrl = "next_url"
        case prevUrl = "prev_url"
    }
}
