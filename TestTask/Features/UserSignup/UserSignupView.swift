//
//  UserSignupView.swift.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 29.09.2024.
//

import SwiftUI

struct UserSignupView: View {
    @StateObject private var viewModel: UserSignupViewModel

    init(viewModel: UserSignupViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Spacer()

                    VStack(spacing: AppStyles.Spacing.l) {
                        // TODO: Create Data Source and remove duplication
                        FloatingTextField(
                            text: $viewModel.name,
                            title: "Name",
                            fieldType: .name,
                            validationMessage: $viewModel.nameErrorMessage,
                            isValid: $viewModel.isNameValid
                        )
                        
                        FloatingTextField(
                            text: $viewModel.email,
                            title: "Email",
                            fieldType: .email,
                            validationMessage: $viewModel.emailErrorMessage,
                            isValid: $viewModel.isEmailValid
                        )
                        
                        FloatingTextField(
                            text: $viewModel.phoneNumber,
                            title: "Phone number",
                            fieldType: .phone,
                            validationMessage: $viewModel.phoneNumberErrorMessage,
                            isValid: $viewModel.isPhoneNumberValid
                        )
                    }
                    .padding(.top, 16)
                    
                    RadioGroupView(
                        title: Constants.Strings.radioGroupTitle,
                        options: viewModel.positions,
                        label: { $0.name },
                        selectedOption: $viewModel.selectedPositions
                    )
                    .padding(.top, 8)

                    UploadButton(
                        selectedImage: viewModel.selectedImage,
                        isValid: viewModel.isImageValid,
                        validationMessage: viewModel.photoValidationErrorMessage
                    ) {
                        viewModel.showActionSheet = true
                    }
                    .padding(.top, 16)

                    HStack {
                        Spacer()

                        PrimaryButton(title: Constants.Strings.signUpButton, disabled: viewModel.isButtonDisabled) {
                            viewModel.validateData()
                            hideKeyboard()
                        }

                        Spacer()
                    }
                    .padding(.top, 16)
                }
                .padding(.horizontal, 16)
                .background(AppStyles.Colors.background)
                .navigationTitle(Constants.Strings.title)
                .navigationBarTitleDisplayMode(.inline)
                .onTapGesture {
                    hideKeyboard()
                }
                .confirmationDialog(Constants.Strings.dialogTitle, isPresented: $viewModel.showActionSheet, titleVisibility: .visible) {
                    confirmationDialogButtons
                }
                .sheet(isPresented: $viewModel.showImagePicker) {
                    ImagePicker(sourceType: viewModel.sourceType, selectedImage: $viewModel.selectedImage)
                        .onDisappear {
                            viewModel.validateImage()
                        }
                }
                .permissionAlert(showAlert: $viewModel.showSettingsAlert)
            }
        }
    }
}

private extension UserSignupView {
    @ViewBuilder
    var confirmationDialogButtons: some View {
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

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

private enum Constants {
    enum Strings {
        static let camera = "Camera"
        static let library = "Library"
        static let cancel = "Cancel"
        static let dialogTitle = "Select Photo"
        static let signUpButton = "Sign Up"
        static let radioGroupTitle = "Select position"
        static let title = "Working with POST request"
    }
}
