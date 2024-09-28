//
//  NetworkError.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse(String)
    case decodingFailed(Error)
    case apiError(message: String)
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .requestFailed(let error):
            return "Request failed with error: \(error.localizedDescription)"
        case .invalidResponse(let description):
            return "Received invalid response: \(description)"
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .apiError(let message):
            return "API error occurred: \(message)"
        case .unknown(let error):
            return "An unknown error occurred: \(error)"
        }
    }
}
