//
//  AppStyles.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import SwiftUI

struct AppStyles {
    struct Spacing {
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
        static let primary = Color(red: 244/255, green: 224/255, blue: 64/255)
        static let secondary = Color(red: 0/255, green: 189/255, blue: 211/255)
        static let background = Color(red: 255/255, green: 255/255, blue: 255/255)
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
    }
}

private extension AppStyles {
    static let regularFont = "Nunito-Regular"
}
