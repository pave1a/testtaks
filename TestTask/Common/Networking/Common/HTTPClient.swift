//
//  HTTPClient.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import Foundation

protocol HTTPClientProtocol {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T
}

final class HTTPClient: HTTPClientProtocol {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T {
        guard let url = endpoint.url else {
            print("Invalid URL: \(endpoint.baseURL + endpoint.path)")
            throw NetworkError.invalidURL
        }

        print("Sending request to URL: \(url.absoluteString)")
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse("Unexpected response code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
            } catch {
                print("Decoding failed with error: \(error.localizedDescription)")
                throw NetworkError.decodingFailed(error)
            }
        } catch {
            print("Request failed with error: \(error.localizedDescription)")
            throw NetworkError.requestFailed(error)
        }
    }
}
