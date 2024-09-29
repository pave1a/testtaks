//
//  PermissionManager.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 29.09.2024.
//

import AVFoundation
import Photos
import UIKit

enum PermissionType {
    case camera
    case photoLibrary
}

enum PermissionStatus {
    case authorized
    case denied
    case notDetermined
}

// Working with statics for simplifying current app flow
struct PermissionManager {
    static func getCurrentPermissionStatus(for type: PermissionType) async -> PermissionStatus {
        switch type {
        case .camera:
            return checkCameraCurrentStatus()
        case .photoLibrary:
            return checkPhotoLibraryCurrentStatus()
        }
    }

    static func requestPermission(for type: PermissionType) async -> PermissionStatus {
        switch type {
        case .camera:
            return await getCameraPermissionStatus()
        case .photoLibrary:
            return await getPhotoLibraryPermissionStatus()
        }
    }

    static func openSettings() {
        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettingsURL) {
                UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
            }
        }
    }
}

// MARK: Helper methods

private extension PermissionManager {
    static func checkCameraCurrentStatus() -> PermissionStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            return .authorized
        case .denied, .restricted:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .denied
        }
    }

    static func checkPhotoLibraryCurrentStatus() -> PermissionStatus {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            return .authorized
        case .denied, .restricted:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .denied
        }
    }

    static func getCameraPermissionStatus() async -> PermissionStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            return .authorized
        case .notDetermined:
            let granted = await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    continuation.resume(returning: granted)
                }
            }
            return granted ? .authorized : .denied
        case .denied, .restricted:
            return .denied
        @unknown default:
            return .denied
        }
    }

    static func getPhotoLibraryPermissionStatus() async -> PermissionStatus {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            return .authorized
        case .notDetermined:
            let newStatus = await withCheckedContinuation { continuation in
                PHPhotoLibrary.requestAuthorization { newStatus in
                    continuation.resume(returning: newStatus)
                }
            }
            return (newStatus == .authorized || newStatus == .limited) ? .authorized : .denied
        case .denied, .restricted:
            return .denied
        @unknown default:
            return .denied
        }
    }
}
