//
//  RadioGroupView.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 30.09.2024.
//

import SwiftUI

private enum Constants {
    static let imageSize = CGFloat(40)
    static let selectedImageName = "selectedRadio"
    static let emptyImageName = "emptyRadio"
}

struct RadioButtonView: View {
    let label: String
    let isSelected: Bool
    let onSelect: () -> Void

    private var imageName: String {
        isSelected ? Constants.selectedImageName : Constants.emptyImageName
    }

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                Image(imageName)
                    .resizable()
                    .frame(width: Constants.imageSize, height: Constants.imageSize)
                Text(label)
                    .foregroundColor(AppStyles.Colors.primaryText)
                    .font(AppStyles.Fonts.body2)
            }
        }
    }
}

struct RadioGroupView<Element: Identifiable & Equatable>: View {
    let title: String
    let options: [Element]
    let label: (Element) -> String

    @Binding var selectedOption: Element?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(AppStyles.Fonts.body1)

            ForEach(options) { option in
                RadioButtonView(
                    label: label(option),
                    isSelected: selectedOption == option,
                    onSelect: {
                        selectedOption = option
                    }
                )
            }
        }
        .onAppear {
            // Pre-Select first option if existed
            if selectedOption == nil, let firstOption = options.first {
                selectedOption = firstOption
            }
        }
    }
}
