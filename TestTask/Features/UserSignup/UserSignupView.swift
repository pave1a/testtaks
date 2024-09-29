//
//  UserSignupView.swift.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 29.09.2024.
//

import SwiftUI

struct UserSignupView: View {
    @StateObject private var viewModel = UserSignupViewModel()

    var body: some View {
        VStack {
            UploadButton(selectedImage: viewModel.selectedImage, isValid: viewModel.isPhotoValid) {
                viewModel.showActionSheet = true
            }
            .confirmationDialog("Select Photo", isPresented: $viewModel.showActionSheet, titleVisibility: .visible) {
                Button("Camera") {
                    Task {
                        await viewModel.handlePermissionCheck(for: .camera)
                    }
                }
                Button("Gallery") {
                    Task {
                        await viewModel.handlePermissionCheck(for: .photoLibrary)
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(sourceType: viewModel.sourceType, selectedImage: $viewModel.selectedImage)
            }
            .alert(isPresented: $viewModel.showSettingsAlert) {
                Alert(title: Text("Permission Denied"), message: Text("Permission Denied"), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }
}
