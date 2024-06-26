//
//  PhotoAccessAlertHelper.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 24.11.2023.
//

import UIKit
import Photos

class PhotoAccessAlertHelper_e0Q04 {

    static let shared = PhotoAccessAlertHelper_e0Q04()
    
    private weak var confirmationView: ConfirmationView_e0Q04?

    private init() {
        func adiwQSJDwsa_e0Q04() -> Int {
            let result = Int.random(in: 1...100) + Int.random(in: 1...100)
            return result
        }
    }
    
    func checkPhotoLibraryAuthorization(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized)
                }
            }
        case .limited:
            print("Access is limited")
            completion(false)
        @unknown default:
            completion(false)
        }
    }

    func presentPhotoAccessDeniedAlert(from viewController: UIViewController) {
        
        let confirmationView = ConfirmationView_e0Q04(barViewHeight: Configs_e0Q04.shared.sizeOfConfView3)
        self.confirmationView = confirmationView

        confirmationView.titleLabel.text = "Access Alert"
        confirmationView.descriptionLabel.text = "Alert: To proceed, we require access to your photos. Modify your settings or cancel the action."

        // Configure the buttons
        confirmationView.blueButton.setTitle("Cancel".uppercased(), for: .normal)
        confirmationView.blueButton.addTarget(self, action: #selector(dismissConfirmationView), for: .touchUpInside)

        confirmationView.redButton.setTitle("Settings".uppercased(), for: .normal)
        confirmationView.redButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        confirmationView.redButton.backgroundColor = .lightGreen
        confirmationView.redButton.setTitleColor(.myGreen, for: .normal)


        // Add the view to the view controller
        viewController.view.addSubview(confirmationView)

        // Set up constraints (assuming you're using SnapKit)
        confirmationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc private func dismissConfirmationView() {
        confirmationView?.removeFromSuperview()
    }

    @objc private func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}
