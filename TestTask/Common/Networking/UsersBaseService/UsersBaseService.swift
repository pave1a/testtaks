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
    func registerUser(name: String, email: String, phone: String, positionId: Int, photo: Data) async throws -> RegistrationResponse
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
            headers: config.defaultHeaders,
            baseURL: config.baseURL
        )

        do {
            let response: PositionResponse = try await client.sendRequest(endpoint: endpoint, responseModel: PositionResponse.self)
            return response
        } catch {
            throw NetworkError.apiError(message: "Failed to fetch positions")
        }
    }

    /// Post request on creation new user
    ///
    /// - Parameters:
    ///   - name: User's name. Should be 2-60 characters long.
    ///   - email: User's email address. Must be a valid email according to RFC2822 standard.
    ///   - phone: User's phone number. Should start with the code of Ukraine (+380).
    ///   - position_id: User's position ID. You can get a list of all positions and their IDs using the API method `GET /api/v1/positions`.
    ///   - photo: User's photo. Must be a jpg/jpeg image with a resolution of at least 70x70 pixels, and its size must not exceed 5MB.
    func registerUser(name: String, email: String, phone: String, positionId: Int, photo: Data) async throws -> RegistrationResponse {
        do {
            let token = try await getToken()

            let request = UserRegistrationRequest(
                name: name,
                email: email,
                phone: phone,
                positionId: positionId,
                photo: photo
            )

            let boundary = "Boundary-\(UUID().uuidString)"
            let headers = [
                "Content-Type": "multipart/form-data; boundary=\(boundary)",
                "Token": token
            ]

            let body = request.toFormData(boundary: boundary)

            let endpoint = Endpoint(
                path: UsersBaseAPIEndpoint.registerUser.path,
                method: .POST,
                headers: headers,
                body: body,
                baseURL: config.baseURL
            )

            let response: RegistrationResponse = try await client.sendRequest(endpoint: endpoint, responseModel: RegistrationResponse.self)

            return response
        } catch {
            print("Failed to register user with error: \(error.localizedDescription)")
            throw NetworkError.apiError(message: "Failed to register user")
        }
    }

    // For private needs. Use only for registration new user.
    // Token valid for 40 minutes and is used for 1 registration
    private func getToken() async throws -> String {
        let endpoint = Endpoint(
            path: UsersBaseAPIEndpoint.getToken.path,
            headers: config.defaultHeaders,
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

