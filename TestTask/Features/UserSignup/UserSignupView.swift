//
//  UserSignupView.swift.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 29.09.2024.
//

import SwiftUI

struct UserSignupView: View {
    @State var selectedImage: UIImage?

    var body: some View {
        VStack {
            UploadButton(selectedImage: selectedImage, isValid: true) {}
                .padding()
        }
    }
}
