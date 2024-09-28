//
//  APIConfiguration.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

protocol APIConfiguration {
    var baseURL: String { get }
    var defaultHeaders: [String: String] { get }
}
