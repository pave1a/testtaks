//
//  FloatingTextField.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import SwiftUI

private enum Constants {
    static let verticalSpacing = AppStyles.Spacing.s
    static let horizontalSpacing = AppStyles.Spacing.l
    static let cornerRadius = AppStyles.Spacing.xs
    static let borderWidth = AppStyles.Spacing.xxxs
    static let validationMessageTopPadding = AppStyles.Spacing.xs
    static let titleLabelOffset = -AppStyles.Spacing.l
    static let textFieldHeigh = CGFloat(56) // Heigh value from Figma

    static let borderColor = AppStyles.Colors.border
    static let errorColor = AppStyles.Colors.error
    static let focusedColor = AppStyles.Colors.secondary
    static let textColor = AppStyles.Colors.primaryText
    static let secondaryTextColor = AppStyles.Colors.secondaryText
}

struct FloatingTextField: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool

    var shouldShowTitle: Bool { isFocused || !text.isEmpty }

    let title: String
    let fieldType: TextFieldType
    let validationMessage: String
    let isValid: Bool
    let onSubmit: EmptyClosure

    init(
        text: Binding<String>,
        fieldType: TextFieldType = .basic,
        title: String,
        validationMessage: String,
        isValid: Bool,
        onSubmit: @escaping EmptyClosure
    ) {
        self._text = text
        self.fieldType = fieldType
        self.title = title
        self.validationMessage = validationMessage
        self.isValid = isValid
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.validationMessageTopPadding) {
            ZStack(alignment: .leading) {
                titleLabel
                textField
                    .padding(.top, AppStyles.Spacing.m)
            }
            .padding(.horizontal, Constants.horizontalSpacing)
            .frame(height: Constants.textFieldHeigh)
            .overlay(RoundedRectangle(cornerRadius: Constants.cornerRadius).stroke(borderColor, lineWidth: Constants.borderWidth))

            errorLabel
                .padding(.horizontal, Constants.horizontalSpacing)
        }
    }
}

private extension FloatingTextField {
    // TODO: Add focused state color
    var borderColor: Color { isValid ? Constants.borderColor : Constants.errorColor }
    var titleColor: Color { isValid ? Constants.secondaryTextColor : Constants.errorColor }

    var errorLabel: some View {
        Text(validationMessage)
            .foregroundColor(Constants.errorColor)
            .font(AppStyles.Fonts.body4)
            .opacity(isValid ? 0 : 1)
    }

    var titleLabel: some View {
        Text(title)
            .foregroundColor(titleColor)
            .font(shouldShowTitle ? AppStyles.Fonts.body4 : AppStyles.Fonts.body2)
            .offset(y: shouldShowTitle ? Constants.titleLabelOffset : 0)
    }

    var textField: some View {
        TextField("", text: $text)
            .keyboardType(fieldType.keyboardType)
            .textInputAutocapitalization(fieldType.autocapitalization)
            .autocorrectionDisabled(true)
            .focused($isFocused)
            .font(AppStyles.Fonts.body2)
            .foregroundStyle(Constants.textColor)
            .accentColor(Constants.textColor)
            .onSubmit(onSubmit)
    }
}

enum TextFieldType {
    case email, name, phone, basic
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .email:
            return .emailAddress
        case .name, .basic:
            return .default
        case .phone:
            return .phonePad
        }
    }

    var autocapitalization: TextInputAutocapitalization {
        switch self {
        case .email, .phone, .basic:
            return .never
        case .name:
            return .words
        }
    }
}

