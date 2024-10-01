//
//  BorderedViewModifier.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 01.10.2024.
//

import SwiftUI

private enum Constants {
    static let borderWidth = AppStyles.Spacing.xxxs
    static let cornerRadius = AppStyles.Spacing.xs
}

struct BorderedViewModifier: ViewModifier {
    let isValid: Bool
    let isFocused: Bool?

    init(isValid: Bool, isFocused: Bool? = nil) {
        self.isValid = isValid
        self.isFocused = isFocused
    }

    func body(content: Content) -> some View {
        content
            .overlay(RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(borderColor, lineWidth: Constants.borderWidth))
    }

    var borderColor: Color {
        guard let isFocused = isFocused else {
            return isValid ? AppStyles.Colors.border : AppStyles.Colors.error
        }
    
        return isFocused ? AppStyles.Colors.secondary : isValid ? AppStyles.Colors.border : AppStyles.Colors.error
    }
}
