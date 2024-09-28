//
//  Endpoint.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import Foundation

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    let body: Data?
    let queryParams: [String: String]?
    let baseURL: String

    init(
        path: String,
        method: HTTPMethod,
        headers: [String : String],
        body: Data? = nil,
        queryParams: [String : String]?,
        baseURL: String
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
        self.queryParams = queryParams
        self.baseURL = baseURL
    }
    
    var url: URL? {
        var components = URLComponents(string: baseURL + path)!
        if let queryParams = queryParams {
            components.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        return components.url
    }
}
