//
//  UsersBaseService.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import Foundation

protocol UsersBaseProtocol {
    func getUsers(page: Int, count: Int) async throws -> UsersResponse
    func getPositions() async throws -> PositionResponse
    func getToken() async throws -> String
}

final class UsersBaseService: UsersBaseProtocol {
    private let client: HTTPClientProtocol
    private let config: APIConfiguration

    init(client: HTTPClientProtocol = HTTPClient(), config: APIConfiguration = UsersBaseConfig()) {
        self.client = client
        self.config = config
    }

    func getUsers(page: Int, count: Int) async throws -> UsersResponse {
        let params = UsersParams(page: page, count: count)

        let endpoint = Endpoint(
            path: UsersBaseAPIEndpoint.getUsers(page: page, count: count).path,
            method: .GET,
            headers: config.defaultHeaders,
            queryParams: params.toDictionary(),
            baseURL: config.baseURL
        )

        do {
            let response: UsersResponse = try await client.sendRequest(endpoint: endpoint, responseModel: UsersResponse.self)
            return response
        } catch {
            throw NetworkError.apiError(message: "Failed to fetch users")
        }
    }

    func getPositions() async throws -> PositionResponse {
        let endpoint = Endpoint(
            path: UsersBaseAPIEndpoint.getPositions.path,
            method: .GET,
            headers: config.defaultHeaders,
            queryParams: nil,
            baseURL: config.baseURL
        )

        do {
            let response: PositionResponse = try await client.sendRequest(endpoint: endpoint, responseModel: PositionResponse.self)
            return response
        } catch {
            throw NetworkError.apiError(message: "Failed to fetch positions")
        }
    }

    func getToken() async throws -> String {
        let endpoint = Endpoint(
            path: UsersBaseAPIEndpoint.getToken.path,
            method: .GET,
            headers: config.defaultHeaders,
            queryParams: nil,
            baseURL: config.baseURL
        )

        do {
            let response: TokenResponse = try await client.sendRequest(endpoint: endpoint, responseModel: TokenResponse.self)
            guard response.success else {
                throw NetworkError.apiError(message: "Failed to fetch token")
            }
            return response.token
        } catch {
            throw NetworkError.apiError(message: "Failed to fetch token")
        }
    }
}

