//
//  PrimaryButton.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import SwiftUI

private enum Constants {
    static let cornerRadius: CGFloat = AppStyles.Spacing.xl
    static let horizontalPadding: CGFloat = AppStyles.Spacing.xxl
    static let verticalPadding: CGFloat = AppStyles.Spacing.m
    static let minWidth: CGFloat = 140 // Value from Figma

    static let textColor = AppStyles.Colors.primaryText
    static let disabledTextColor = AppStyles.Colors.secondaryText
    static let buttonColor = AppStyles.Colors.primary
    static let tappedButtonColor = AppStyles.Colors.action
    static let disabledButtonColor = AppStyles.Colors.disabledBackground
}

struct PrimaryButton: View {
    private let title: String
    private let action: () -> Void
    private var disabled: Bool

    init(title: String, action: @escaping () -> Void, disabled: Bool = false) {
        self.title = title
        self.action = action
        self.disabled = disabled
    }

    var body: some View {
        Button(action: action, label: buttonLabel)
            .buttonStyle(PrimaryButtonStyle(disabled: disabled))
            .disabled(disabled)
    }
}

private extension PrimaryButton {
    func buttonLabel() -> some View {
        Text(title)
    }
}

private struct PrimaryButtonStyle: ButtonStyle {
    let disabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, Constants.verticalPadding)
            .frame(minWidth: Constants.minWidth)
            .background(
                disabled
                ? Constants.disabledButtonColor
                : (configuration.isPressed ? Constants.tappedButtonColor : Constants.buttonColor)
            )
            .foregroundColor(disabled ? Constants.disabledTextColor : Constants.textColor)
            .font(AppStyles.Fonts.semiBoldBody1)
            .cornerRadius(Constants.cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: configuration.isPressed ? 0.1 : 0.5), value: configuration.isPressed)
    }
}


