//
//  ValidationMessageView.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 01.10.2024.
//

import SwiftUI

private enum Strings {
    static let defaultErrorMessage = "Required field"
}

struct ValidationMessageView: View {
    let isValid: Bool
    let validationMessage: String?

    var body: some View {
        Text(validationMessage ?? Strings.defaultErrorMessage)
            .foregroundColor(AppStyles.Colors.error)
            .font(AppStyles.Fonts.body4)
            .opacity(isValid ? 0 : 1)
    }
}
