# Documentation

## Project Overview

The project follows the **MVVM (Model-View-ViewModel)** architecture to ensure a clean separation of concerns between the user interface (UI), business logic, and data management layers. This structure helps in maintaining a clear and scalable codebase.

### Features of the Application:
1. **User Signup**: A feature allowing users to sign up via a form that collects personal data, position, and a profile photo.
2. **Users List**: Displays a paginated list of users fetched from an external API. Users are sorted by registration date.

## Project Setup

- **Xcode Version**: Xcode 15.4.
- **Swift Version**: Swift 5.10.
- **Test Devices**: The app was tested on the following device:
  - iPhone 12 Pro, iOS 17.5.1

## Code Structure

### 1. **Features**
This directory contains feature-specific views and view models, organized by functionality.

- **UserSignup**:
  - `UserSignupView.swift`: The view for the user signup form, using SwiftUI.
  - `UserSignupViewModel.swift`: Manages the business logic for user signup, including form validation and API calls for registration.

- **UsersList**:
  - `UsersListView.swift`: Displays the list of users in a paginated format, fetching users from the API.
  - `UsersListViewModel.swift`: Contains the logic for fetching users and handling pagination, while maintaining the list's state.
  - `Cell/UserCard.swift`: A reusable component that represents individual user information within the list.

- **Root**:
  - `RootView.swift`: The main entry point for the app's tab-based navigation.
  - `RootViewModel.swift`: Handles navigation logic and manages the state of the app's tabs.

### 2. **Common**
This folder contains shared utilities, services, and models used across the app.

- **Networking**:
  - `HTTPClient.swift`, `APIConfiguration.swift`, `Endpoint.swift`: Handles API requests and network errors.
  - `NetworkError.swift`: Handles errors that may arise during network requests.

- **Models**:
  - `UserResponse.swift`, `TokenResponse.swift`, `PositionsResponse.swift`, etc.: Data models used to parse and store API response data.

- **UsersBaseService**:
 - `UsersBaseService.swift`: Manages network requests related to user data, including fetching users and registering new users. This service is responsible for making API requests to fetch the user list and handle user registration, ensuring that these operations are abstracted from the views and handled consistently across the app.
  - **Requests**: Contains API request models such as `UserRegistrationRequest.swift`.

### 3. **UI Components**
Reusable UI components built with SwiftUI, such as:
- `FloatingTextField.swift`: A text input field with floating labels and validation logic.
- `PrimaryButton.swift`: A styled primary action button used throughout the app.
- `StatusScreen.swift`: A status screen to handle error or offline states.

### 4. **Styles**
- `AppStyles.swift`: Centralized styles and design tokens (e.g., colors, fonts, spacing) to maintain consistency across the app.

### 5. **Utility**
Utility classes and helpers:
- **Validator**: Contains validation logic for text fields (`TextFieldValidator.swift`).
- **Reachability**: Manages network status via `ReachabilityManager.swift`.
- **Extensions**: Adds useful methods to existing Swift types, like `String+Empty.swift`.

## External APIs and Libraries

### External APIs
- **No External Dependencies**: This application does not rely on any external dependencies or third-party libraries. All functionality is implemented using native iOS tools and frameworks such as `URLSession` for networking and `SwiftUI` for building the user interface.
### Libraries
- **URLSession**: Used for network requests due to its simplicity and the fact that it is natively supported in iOS without the need for additional dependencies.
- **SwiftUI**: The primary framework for building the user interface, chosen for its modern, declarative approach.

## MVVM Architecture

The project follows the MVVM pattern, ensuring a clear separation between the UI (Views), business logic (ViewModels), and data models (Models):

- **Models**: Represent the data structures received from the API, such as `User`, `Positions`.
  
- **ViewModels**: Manage the business logic and the interaction between the models and views. For example, `UsersListViewModel` handles fetching users and managing pagination, while `UserSignupViewModel` manages form validation and user registration.

- **Views**: Built with SwiftUI, these are responsible for displaying the data to the user and reacting to changes in the view models. For example, `UsersListView` shows a list of users and triggers loading more data when needed.

---

This structure provides a modular and scalable foundation, where each feature is decoupled from the others, making the codebase easy to maintain and extend.
