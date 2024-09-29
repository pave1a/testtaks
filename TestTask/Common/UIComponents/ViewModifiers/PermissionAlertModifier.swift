//
//  PermissionAlertModifier.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 29.09.2024.
//

import SwiftUI

private enum Strings {
    static let title = "Permission Denied"
    static let message = "You can change your access preferences in Settings."
    static let primaryButtonText = "Settings"
}

struct PermissionAlertModifier: ViewModifier {
    @Binding var showAlert: Bool

    func body(content: Content) -> some View {
        content
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(Strings.title),
                    message: Text(Strings.message),
                    primaryButton: .default(
                        Text(Strings.primaryButtonText),
                        action: {
                            PermissionManager.openSettings()
                        }
                    ),
                    secondaryButton: .cancel()
                )
            }
    }
}

extension View {
    func permissionAlert(showAlert: Binding<Bool>) -> some View {
        self.modifier(PermissionAlertModifier(showAlert: showAlert))
    }
}
