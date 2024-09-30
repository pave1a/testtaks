//
//  RegistrationResponse.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 30.09.2024.
//

import Foundation

struct RegistrationResponse: Codable {
    let success: Bool
    let userId: Int?
    let message: String
    let fails: ValidationErrors?

    enum CodingKeys: String, CodingKey {
        case success
        case userId = "user_id"
        case message
        case fails
    }
}

struct ValidationErrors: Codable {
    let name: [String]?
    let email: [String]?
    let phone: [String]?
    let positionId: [String]?
    let photo: [String]?

    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case positionId = "position_id"
        case photo
    }
}
