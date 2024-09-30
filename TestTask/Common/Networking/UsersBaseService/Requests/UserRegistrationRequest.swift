//
//  UserRegistrationRequest.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 30.09.2024.
//

import Foundation

struct UserRegistrationRequest {
    let name: String
    let email: String
    let phone: String
    let positionId: Int
    let photo: Data

    func toFormData(boundary: String) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"

        func addTextField(name: String, value: String) {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }

        addTextField(name: "name", value: self.name)
        addTextField(name: "email", value: self.email)
        addTextField(name: "phone", value: self.phone)
        addTextField(name: "position_id", value: "\(self.positionId)")

        let photoFilename = "img.jpg"
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"photo\"; filename=\"\(photoFilename)\"\r\n")
        body.appendString("Content-Type: image/jpeg\r\n\r\n")
        body.append(photo)
        body.appendString("\r\n")

        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
}


private extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
