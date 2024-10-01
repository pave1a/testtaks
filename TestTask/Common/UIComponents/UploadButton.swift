//
//  UploadButton.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 29.09.2024.
//

import SwiftUI

private enum Constants {
    static let imageSize = AppStyles.Spacing.xxl
    static let borderWidth = AppStyles.Spacing.xxxs
    static let horizontalSpacing = AppStyles.Spacing.l
    static let frameHeigh = CGFloat(56)

    enum Strings {
        static let title = "Upload photo"
        static let actionString = "Upload"
        static let defaultErrorMessage = "Required field"
    }
}

struct UploadButton: View {
    let selectedImage: UIImage?
    let isValid: Bool
    let validationMessage: String?
    let action: EmptyClosure

    init(
        selectedImage: UIImage?,
        isValid: Bool,
        validationMessage: String?,
        action: @escaping EmptyClosure
    ) {
        self.selectedImage = selectedImage
        self.isValid = isValid
        self.validationMessage = validationMessage
        self.action = action
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(Constants.Strings.title)
                    .foregroundColor(tintColor)
                    .font(AppStyles.Fonts.body2)
                
                Spacer()

                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(AppStyles.Colors.border, lineWidth: Constants.borderWidth))
                } else {
                    Text(Constants.Strings.actionString)
                        .foregroundColor(AppStyles.Colors.secondary)
                        .font(AppStyles.Fonts.semiBoldBody2)
                }
            }
            .padding(AppStyles.Spacing.l)
            .frame(height: Constants.frameHeigh)
            .onTapGesture(perform: action)
            .modifier(BorderedViewModifier(isValid: isValid))

            errorLabel
                .padding(.horizontal, Constants.horizontalSpacing)
        }
    }
}

private extension UploadButton {
    var tintColor: Color {
        isValid ? AppStyles.Colors.border : AppStyles.Colors.error
    }

    var errorLabel: some View {
        ValidationMessageView(isValid: isValid, validationMessage: validationMessage)
    }
}
