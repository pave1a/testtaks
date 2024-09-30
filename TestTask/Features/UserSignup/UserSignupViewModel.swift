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

    // Status screen
    @Published var showStatusScreen = false
    @Published var statusScreenType: StatusScreenType = .userRegistered
    @Published var statusScreenAction: EmptyClosure = {}

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
    @Published var photoValidationErrorMessage: String?

    // Positions RadioGroup
    @Published var positions: [Position] = []
    @Published var selectedPosition: Position?

    private let usersBaseService: UsersBaseProtocol

    var isButtonDisabled: Bool {
        name.isEmpty || email.isEmpty || phoneNumber == Constants.numberPrefix
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
            photoValidationErrorMessage = "Image exceeds 5MB size limit"
        } else {
            isImageValid = true
            photoValidationErrorMessage = nil
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

    func tapSignUp() {
        validateImage()
        validateData()

        if isNameValid && isEmailValid && isPhoneNumberValid && isImageValid {
            registerUser()
        }
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
            return imageData.count <= Constants.maxImageSize
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
            if name.count < Constants.minNameLength || name.count > Constants.maxNameLength {
                return "Name must be between 2 and 60 characters long."
            }
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
                }
            } catch {
                print("Failed to fetch positions: \(error.localizedDescription)")
            }
        }
    }

    func registerUser() {
        if let selectedPosition = selectedPosition,
           let selectedImage = selectedImage,
           let imageJpegData = selectedImage.jpegData(compressionQuality: 1.0)
        {
            Task {
                do {
                    let registrationResponse = try await usersBaseService.registerUser(
                        name: name,
                        email: email,
                        phone: phoneNumber,
                        positionId: selectedPosition.id,
                        photo: imageJpegData
                    )

                    await MainActor.run {
                        if registrationResponse.success {
                            statusScreenType = .userRegistered
                            statusScreenAction = { [weak self] in
                                self?.showStatusScreen = false
                            }
                        } else {
                            statusScreenType = .registrationFailed(errorMessage: registrationResponse.message)
                            statusScreenAction = retryRegistration
                        }

                        showStatusScreen = true
                    }
                } catch {
                    await MainActor.run {
                        statusScreenType = .registrationFailed(errorMessage: "Registration failed")
                        statusScreenAction = retryRegistration
                        showStatusScreen = true
                    }
                    print("Failed to create new user: \(error.localizedDescription)")
                }
            }
            
        }
    }

    func retryRegistration() {
        showStatusScreen = false
        tapSignUp()
    }
}

private enum Constants {
    static let minNameLength = 2
    static let maxNameLength = 60
    static let maxImageSize: Int = 5 * 1024 * 1024
    static let numberPrefix = "+380" 
}
