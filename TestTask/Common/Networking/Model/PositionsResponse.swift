//
//  PositionResponse.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 29.09.2024.
//

import Foundation

struct PositionResponse: Codable {
    let success: Bool
    let positions: [Position]
}

struct Position: Codable, Identifiable {
    let id: Int
    let name: String
}

extension Position: Equatable {
    static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.id == rhs.id
    }
}
