//
//  FloatingTextField.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import SwiftUI

struct FloatingTextFieldData {
    var text: String
    var title: String
    var fieldType: TextFieldType
    var validationMessage: String?
    var isValid: Bool
}

struct FloatingTextField: View {
    @FocusState private var isFocused: Bool
    @Binding var data: FloatingTextFieldData

    var shouldShowTitle: Bool { isFocused || !data.text.isEmpty }

    private let phonePrefix = "+380"

    // TODO: Clarify toolbar issue
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.validationMessageTopPadding) {
            ZStack(alignment: .leading) {
                titleLabel
                textField
                    .padding(.top, AppStyles.Spacing.m)
            }
            .padding(.horizontal, Constants.horizontalSpacing)
            .frame(height: Constants.textFieldHeigh)
            .modifier(BorderedViewModifier(isValid: data.isValid, isFocused: isFocused))

            errorLabel
                .padding(.horizontal, Constants.horizontalSpacing)
        }
        .onAppear {
            if data.fieldType == .phone && !data.text.hasPrefix(phonePrefix) {
                data.text = phonePrefix
            }
        }
        .onChange(of: isFocused) { focused in
            if focused {
                data.isValid = true
            }
        }
        .onChange(of: data.text) { newValue in
            if data.fieldType == .phone {
                enforcePrefix(for: newValue)
            }
        }
    }
}

private extension FloatingTextField {
    var borderColor: Color {
        isFocused
        ? AppStyles.Colors.secondary
        : data.isValid ? Constants.borderColor : Constants.errorColor
    }

    var titleColor: Color {
        isFocused
        ? AppStyles.Colors.secondary
        : data.isValid ? Constants.secondaryTextColor : Constants.errorColor
    }

    var errorLabel: some View {
        ValidationMessageView(isValid: data.isValid, validationMessage: data.validationMessage)
    }

    var titleLabel: some View {
        Text(data.title)
            .foregroundColor(titleColor)
            .font(shouldShowTitle ? AppStyles.Fonts.body4 : AppStyles.Fonts.body2)
            .offset(y: shouldShowTitle ? Constants.titleLabelOffset : 0)
    }

    var textField: some View {
        TextField("", text: $data.text)
            .keyboardType(data.fieldType.keyboardType)
            .textInputAutocapitalization(data.fieldType.autocapitalization)
            .autocorrectionDisabled(true)
            .focused($isFocused)
            .font(AppStyles.Fonts.body2)
            .foregroundStyle(Constants.textColor)
            .accentColor(Constants.textColor)
    }

    private func enforcePrefix(for newValue: String) {
        if !newValue.hasPrefix(phonePrefix) {
            data.text = phonePrefix
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

enum TextFieldType: CaseIterable {
    case email, name, phone
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .email:
            return .emailAddress
        case .name:
            return .default
        case .phone:
            return .phonePad
        }
    }

    var autocapitalization: TextInputAutocapitalization {
        switch self {
        case .email, .phone:
            return .never
        case .name:
            return .words
        }
    }
}

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
