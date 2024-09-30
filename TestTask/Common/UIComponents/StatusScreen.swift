//
//  StatusScreen.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 30.09.2024.
//

import SwiftUI

enum StatusScreenType {
    case noInternet
    case userRegistered
    case registrationFailed(errorMessage: String)
    
    var imageName: String {
        switch self {
        case .noInternet:
            return "noWifi"
        case .userRegistered:
            return "dataFromDevice"
        case .registrationFailed:
            return "dataFromDeviceFailed"
        }
    }
    
    var title: String {
        switch self {
        case .noInternet:
            return "There is no Internet connection"
        case .userRegistered:
            return "User successfully registered"
        case .registrationFailed(let errorMessage):
            return errorMessage
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .noInternet, .registrationFailed:
            return "Try again"
        case .userRegistered:
            return "Continue"
        }
    }
}

struct StatusScreen: View {
    @State var screenType: StatusScreenType = .noInternet
    @Environment(\.presentationMode) var presentationMode

    var action: EmptyClosure

    init(screenType: StatusScreenType, action: @escaping EmptyClosure = {}) {
        self.screenType = screenType
        self.action = action
    }
    
    var body: some View {
        VStack {
            if screenType != .noInternet {
                closeButton
            }

            Spacer()

            contentForState()

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppStyles.Colors.background)
    }

    var closeButton: some View {
        HStack {
            Spacer()
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
                    .padding()
            }
        }
    }

    private func contentForState() -> some View {
        VStack {
            Image(screenType.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .padding()
            
            Text(screenType.title)
                .font(AppStyles.Fonts.heading)
                .padding()

            PrimaryButton(title: screenType.buttonTitle) {
                action()
            }
        }
    }
}

extension StatusScreenType: Equatable {
    static func == (lhs: StatusScreenType, rhs: StatusScreenType) -> Bool {
        switch (lhs, rhs) {
        case (.noInternet, .noInternet):
            return true
        case (.userRegistered, .userRegistered):
            return true
        case (.registrationFailed(let lhsMessage), .registrationFailed(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

#Preview {
    StatusScreen(screenType: .userRegistered, action: {})
}

