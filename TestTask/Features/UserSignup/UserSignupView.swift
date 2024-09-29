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
            .confirmationDialog(Constants.Strings.dialogTitle, isPresented: $viewModel.showActionSheet, titleVisibility: .visible) {
                confirmationDialogButtons
            }
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(sourceType: viewModel.sourceType, selectedImage: $viewModel.selectedImage)
            }
            .permissionAlert(showAlert: $viewModel.showSettingsAlert)
        }
        .padding()
    }
}

private extension UserSignupView {
    @ViewBuilder
    private var confirmationDialogButtons: some View {
        Button(Constants.Strings.camera) {
            Task {
                await viewModel.handlePermissionCheck(for: .camera)
            }
        }
        Button(Constants.Strings.library) {
            Task {
                await viewModel.handlePermissionCheck(for: .photoLibrary)
            }
        }
        Button(Constants.Strings.cancel, role: .cancel) { }
    }
}


private enum Constants {
    enum Strings {
        static let camera = "Camera"
        static let library = "Library"
        static let cancel = "Cancel"
        static let dialogTitle = "Select Photo"
        
    }
}
