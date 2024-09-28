//
//  UsersBaseService.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import Foundation

protocol UsersBaseProtocol {
    func getUsers(page: Int, count: Int) async throws -> UsersResponse
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
            path: UserAPIEndpoint.getUsers(page: page, count: count).path,
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
}

