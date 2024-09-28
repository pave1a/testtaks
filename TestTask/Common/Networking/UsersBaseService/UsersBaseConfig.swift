//
//  UsersBaseConfig.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import Foundation

struct UsersBaseConfig: APIConfiguration {
    var baseURL: String = "https://frontend-test-assignment-api.abz.agency/api/v1"
    var defaultHeaders: [String : String] = [:]
}
