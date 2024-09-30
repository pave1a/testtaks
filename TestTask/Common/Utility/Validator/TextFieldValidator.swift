//
//  TextFieldValidator.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 29.09.2024.
//

import Foundation

struct TextFieldValidator {
    static func isValidName(_ name: String) -> Bool {
        let nameRegEx = "^[A-Za-z]+( [A-Za-z]+)*$"
        let namePredicate = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePredicate.evaluate(with: name)
    }

    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }

    static func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegEx = "^\\+380\\d{9}$"
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phonePredicate.evaluate(with: phoneNumber)
    }
}
