//
//  UserSignupViewModel.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 29.09.2024.
//

import SwiftUI

struct TextFieldData: Identifiable {
    let id = UUID()
    var text: Binding<String>
    var title: String
    var fieldType: TextFieldType
    var validationMessage: Binding<String?>
    var isValid: Binding<Bool>
}

class UserSignupViewModel: ObservableObject {
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var selectedImage: UIImage?
    @Published var showActionSheet = false
    @Published var showSettingsAlert = false
    @Published var showImagePicker = false

    // TextFields
    @Published var name: String = .empty
    @Published var isNameValid: Bool = true
    @Published var nameErrorMessage: String?

    @Published var email: String = .empty
    @Published var isEmailValid: Bool = true
    @Published var emailErrorMessage: String?

    @Published var phoneNumber: String = .empty
    @Published var isPhoneNumberValid: Bool = true
    @Published var phoneNumberErrorMessage: String?

    // UploadButton
    @Published var isImageValid: Bool = true
    @Published var photoValidationErrorMessage: String = .empty

    // Positions RadioGroup
    @Published var positions: [Position] = []
    @Published var selectedPositions: Position?

    private let maxImageSize: Int = 4 * 1024 * 1024

    private let usersBaseService: UsersBaseProtocol

    var isButtonDisabled: Bool {
        name.isEmpty || email.isEmpty || phoneNumber == "+380"
    }

    init(usersBaseService: UsersBaseProtocol) {
        self.usersBaseService = usersBaseService

        loadPositions()
    }

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

    func validateImage() {
        guard let image = selectedImage else {
            isImageValid = false
            photoValidationErrorMessage = "Photo is required"
            return
        }

        if !isImageUnderSizeLimit(image) {
            isImageValid = false
            photoValidationErrorMessage = "Image exceeds 4MB size limit"
        } else {
            isImageValid = true
            photoValidationErrorMessage = .empty
        }
    }

    func validateData() {
        let nameErrorMessageResult = checkValidationMessage(with: name, using: .name)
        isNameValid = nameErrorMessageResult == nil
        nameErrorMessage = nameErrorMessageResult

        let emailErrorMessageResult = checkValidationMessage(with: email, using: .email)
        isEmailValid = emailErrorMessageResult == nil
        emailErrorMessage = emailErrorMessageResult

        let phoneNumberErrorMessageResult = checkValidationMessage(with: phoneNumber, using: .phone)
        isPhoneNumberValid = phoneNumberErrorMessageResult == nil
        phoneNumberErrorMessage = phoneNumberErrorMessageResult
    }
}

// MARK: - Private

private extension UserSignupViewModel {
    @MainActor
    func showImagePicker(for type: PermissionType) async {
        sourceType = type == .camera ? .camera : .photoLibrary
        showImagePicker = true
    }

    func isImageUnderSizeLimit(_ image: UIImage) -> Bool {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            return imageData.count <= maxImageSize
        }

        return false
    }

    func checkValidationMessage(with text: String, using type: TextFieldType) -> String? {
        switch type {
        case .email:
            guard !text.isEmpty else { return "Required field" }
            return TextFieldValidator.isValidEmail(text) ? nil : "Invalid email"

        case .name:
            guard !text.isEmpty else { return "Required field" }
            return TextFieldValidator.isValidName(text) ? nil : "Invalid name"

        case .phone:
            guard !text.isEmpty else { return "Required field" }
            return TextFieldValidator.isValidPhoneNumber(text) ? nil : "Invalid number"
        }
    }

    func loadPositions() {
        Task {
            do {
                let positionsResponse = try await usersBaseService.getPositions()
                await MainActor.run {
                    self.positions = positionsResponse.positions
                    print(positions)
                }
            } catch {
                print("Failed to fetch positions: \(error.localizedDescription)")
            }
        }
    }
}
