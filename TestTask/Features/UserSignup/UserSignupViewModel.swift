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

    // TextFields data source
    @Published var textFieldsData = [FloatingTextFieldData]()

    // Status screen
    @Published var showStatusScreen = false
    @Published var statusScreenType: StatusScreenType = .userRegistered
    @Published var statusScreenAction: EmptyClosure = {}

    // UploadButton
    @Published var isImageValid: Bool = true
    @Published var photoValidationErrorMessage: String?

    // Positions RadioGroup
    @Published var positions: [Position] = []
    @Published var selectedPosition: Position?

    private let usersBaseService: UsersBaseProtocol

    private var isTextFieldsValid: Bool {
        textFieldsData.allSatisfy { $0.isValid }
    }

    var isSignupButtonEnabled: Bool {
        textFieldsData.allSatisfy { textField in
            if textField.fieldType == .phone && textField.text == Constants.numberPrefix {
                return false
            } else {
                return !textField.text.isEmpty
            }
        }
    }

    init(usersBaseService: UsersBaseProtocol) {
        self.usersBaseService = usersBaseService
        setupTextFields()
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

    func tapSignUp() {
        validateImage()
        validateTextFields()

        if isTextFieldsValid && isImageValid {
            registerUser()
        }
    }
}

// MARK: - Private

// Helpers
private extension UserSignupViewModel {
    func setupTextFields() {
        textFieldsData = [
            FloatingTextFieldData(text: .empty, title: "Name", fieldType: .name, validationMessage: nil, isValid: true),
            FloatingTextFieldData(text: .empty, title: "Email", fieldType: .email, validationMessage: nil, isValid: true),
            FloatingTextFieldData(text: .empty, title: "Phone number", fieldType: .phone, validationMessage: nil, isValid: true)
        ]
    }

    @MainActor
    func showImagePicker(for type: PermissionType) async {
        sourceType = type == .camera ? .camera : .photoLibrary
        showImagePicker = true
    }
}

// Validation
private extension UserSignupViewModel {
    func validateTextFields() {
        TextFieldType.allCases.forEach {
            validateTextField(type: $0)
        }
    }

    func validateTextField(type: TextFieldType) {
        guard let index = textFieldsData.firstIndex(where: { $0.fieldType == type }) else { return }

        let validationValue = textFieldsData[index].text
        let validationInput = ValidationInput(value: validationValue, type: type.validationType)
        let validationResult = Validator.validate(input: validationInput)
        let validationResultMessage = configureMessage(with: validationResult)

        textFieldsData[index].validationMessage = validationResultMessage
        textFieldsData[index].isValid = validationResultMessage == nil
    }

    func configureMessage(with validationResult: ValidationResult<ValidationError>) -> String? {
        switch validationResult {
        case .success:
            return nil
        case .failure(let validationError):
            switch validationError {
            case .empty:
                return "Required field"
            case .invalid:
                return "Invalid field"
            }
        }
    }

    func isImageUnderSizeLimit(_ image: UIImage) -> Bool {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return false }
        return imageData.count <= Constants.maxImageSize
    }
}

// Networking
private extension UserSignupViewModel {
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
        guard let nameTextField = textFieldsData.first(where: { $0.fieldType == .name }),
              let emailTextField = textFieldsData.first(where: { $0.fieldType == .email }),
              let phoneNumberTextField = textFieldsData.first(where: { $0.fieldType == .phone }),
              let selectedPosition = selectedPosition,
              let selectedImage = selectedImage,
              let imageJpegData = selectedImage.jpegData(compressionQuality: 1.0)
        else { return }

        let name = nameTextField.text
        let email = emailTextField.text
        let phoneNumber = phoneNumberTextField.text

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
                        statusScreenAction = retryRegistrationClosure
                    }

                    showStatusScreen = true
                }
            } catch {
                await MainActor.run {
                    statusScreenType = .registrationFailed(errorMessage: "Registration failed")
                    statusScreenAction = retryRegistrationClosure
                    showStatusScreen = true
                }
                print("Failed to create new user: \(error.localizedDescription)")
            }
        }
    }

    func retryRegistrationClosure() {
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

// Maps `TextFieldType` to its corresponding `ValidationType`.
// This extension simplifies the retrieval of the appropriate validation rule based on the type of text field (e.g., email, name, or phone).
private extension TextFieldType {
    var validationType: ValidationType {
        switch self {
        case .email:
            return .email
        case .name:
            return .name
        case .phone:
            return .phoneNumber
        }
    }
}
