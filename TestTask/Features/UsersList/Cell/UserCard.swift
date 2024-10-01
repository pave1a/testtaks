//
//  UserCard.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 28.09.2024.
//

import SwiftUI

private enum Constants {
    static let imageSize = CGFloat(50) // Size from Figma
    static let placeholderName = "photoPlaceholder"
}

struct UserCard: View {
    let user: User
    
    var body: some View {
        HStack(alignment: .top, spacing: AppStyles.Spacing.l) {
            AsyncImage(url: URL(string: user.photo)) { image in
                image
                    .resizable()
                    .frame(width: Constants.imageSize, height: Constants.imageSize)
                    .clipShape(Circle())
            } placeholder: {
                Image(Constants.placeholderName)
                    .resizable()
                    .frame(width: Constants.imageSize, height: Constants.imageSize)
            }

            VStack(alignment: .leading, spacing: 0) {
                Text(user.name)
                    .font(AppStyles.Fonts.body1)
                    .foregroundStyle(AppStyles.Colors.primaryText)
                    .padding(.bottom, AppStyles.Spacing.xs)
                
                Text(user.position)
                    .font(AppStyles.Fonts.body3)
                    .foregroundColor(AppStyles.Colors.secondaryText)
                    .padding(.bottom, AppStyles.Spacing.s)
                
                Text(user.email)
                    .font(AppStyles.Fonts.body3)
                    .padding(.bottom, AppStyles.Spacing.xs)
                
                Text(user.phone)
                    .font(AppStyles.Fonts.body3)
            }
        }
        .padding(.vertical, AppStyles.Spacing.xl)
        .padding(.horizontal, AppStyles.Spacing.l)
    }
}
