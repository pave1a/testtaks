//
//  UserSignupViewModel.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 29.09.2024.
//

import SwiftUI

class UserSignupViewModel: ObservableObject {
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var selectedImage: UIImage?
    @Published var showActionSheet = false
    @Published var showSettingsAlert = false
    @Published var showImagePicker = false
    @Published var isPhotoValid: Bool = true

    func handlePermissionCheck(for type: PermissionType) async {
        let currentStatus = await PermissionManager.getCurrentPermissionStatus(for: type)

        switch currentStatus {
        case .authorized:
            await showImagePicker(for: type)

        case .denied:
            await MainActor.run {
                showSettingsAlert = true
            }

        case .notDetermined:
            let status = await PermissionManager.requestPermission(for: type)
            if status == .authorized {
                await showImagePicker(for: type)
            }
        }
    }

    @MainActor
    private func showImagePicker(for type: PermissionType) async {
        sourceType = type == .camera ? .camera : .photoLibrary
        showImagePicker = true
    }
}
