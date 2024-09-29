//
//  AppStyles.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import SwiftUI

struct AppStyles {
    struct Spacing {
        /// 1
        static let xxxs: CGFloat = 1
        /// 2
        static let xxs: CGFloat = 2
        /// 4
        static let xs: CGFloat = 4
        /// 8
        static let s: CGFloat = 8
        /// 12
        static let m: CGFloat = 12
        /// 16
        static let l: CGFloat = 16
        /// 24
        static let xl: CGFloat = 24
        /// 32
        static let xxl: CGFloat = 32
        /// 64
        static let xxxl: CGFloat = 64
    }

    struct Colors {
        // Main Palette
        static let primary = Color(red: 244/255, green: 224/255, blue: 64/255)
        static let secondary = Color(red: 0/255, green: 189/255, blue: 211/255, opacity: 0.83)
        static let background = Color(red: 255/255, green: 255/255, blue: 255/255)

        /// Main black text color. Common use cases: enabled button text, textField, navigation bar, label.
        static let primaryText = Color(red: 0/255, green: 0/255, blue: 0/255)
        /// Secondary text color: black with 48% opacity. Common use cases: disabled button text, placeholders, and other secondary text elements.
        static let secondaryText = Color(red: 0/255, green: 0/255, blue: 0/255, opacity: 0.48)
        /// Secondary text color: TabView items tint color
        static let secondaryDarkText = Color(red: 0/255, green: 0/255, blue: 0/255, opacity: 0.6)
        /// Border color. Common use case: textField border.
        static let border = Color(red: 208/255, green: 207/255, blue: 207/255, opacity: 0.82)
        /// Common use case: disabled button background.
        static let disabledBackground = Color(red: 222/255, green: 222/255, blue: 222/255, opacity: 0.87)

        // Helpers
        /// Common use case: tapped button.
        static let action = Color(red: 255/255, green: 199/255, blue: 0/255)
        static let error = Color(red: 203/255, green: 61/255, blue: 64/255, opacity: 0.8)
        
    }

    struct Fonts {
        /// Nunito-Regular, size: 20
        static let heading = Font.custom(regularFont, size: 20)
        /// Nunito-Regular, size: 18
        static let body1 = Font.custom(regularFont, size: 18)
        /// Nunito-Regular, size: 16
        static let body2 = Font.custom(regularFont, size: 16)
        /// Nunito-Regular, size: 14
        static let body3 = Font.custom(regularFont, size: 14)
        /// Nunito-Regular, size: 12
        static let body4 = Font.custom(regularFont, size: 12)

        /// Nunito-SemiBold, size: 18
        static let semiBoldBody1 = Font.custom(semiBoldFont, size: 18)
        /// Nunito-SemiBold, size: 16
        static let semiBoldBody2 = Font.custom(semiBoldFont, size: 16)
    }
}

private extension AppStyles {
    static let regularFont = "Nunito-Regular"
    static let semiBoldFont = "Nunito-SemiBold"
}
