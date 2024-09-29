//
//  DashboardTabItemView.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 29.09.2024.
//

import SwiftUI

struct DashboardTabItemView: View {
    let tab: DashboardTabItem
    @Binding var selected: DashboardTabItem

    private var foregroundColor: Color {
        selected == tab ? AppStyles.Colors.secondary : AppStyles.Colors.secondaryDarkText
    }

    var body: some View {
        HStack {
            Image(tab.iconName)
                .renderingMode(.template)
                .resizable()
            Text(tab.title)
                .padding(.leading, 8)
        }
        .foregroundColor(foregroundColor)
    }
}
