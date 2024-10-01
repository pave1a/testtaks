//
//  ValidationResult.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 01.10.2024.
//

enum ValidationResult<ValidationError> {
    case success
    case failure(ValidationError)
}

enum ValidationError {
    case empty
    case invalid
}
