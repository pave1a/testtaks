//
//  Validator.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 29.09.2024.
//

import Foundation

// Validator simplified for test app purposes.
// Provides only 2 error cases - .empty and .invalid for types: name, email and phoneNumber.
struct Validator {
    static func validate(input: ValidationInput) -> ValidationResult<ValidationError> {
        guard !input.value.isEmpty else { return .failure(.empty) }

        let isValid = NSPredicate(format:"SELF MATCHES %@", input.type.validationPattern).evaluate(with: input.value)

        // Specific name validation case.
        if input.type == .name, input.value.count < 2 || input.value.count > 60 {
            return .failure(.invalid)
        }

        return isValid ? .success : .failure(.invalid)
    }
}

private extension ValidationType {
    var validationPattern: String {
        switch self {
        case .name:
            return "^[A-Za-z]+( [A-Za-z]+)*$"
        case .email:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case .phoneNumber:
            return "^\\+380\\d{9}$"
        }
    }
}
