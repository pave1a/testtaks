//
//  APIRequestParams.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import Foundation

protocol APIRequestParams {
    func toDictionary() -> [String: String]
}

struct UsersParams: APIRequestParams {
    let page: Int
    let count: Int
    
    func toDictionary() -> [String: String] {
        return ["page": "\(page)", "count": "\(count)"]
    }
}
