//
//  ConnectionAlertHelperWithDoubleReturn.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 19.12.2023.
//

import UIKit

class ConnectionAlertHelperWithDoubleReturn_e0Q04 {
    static var shared = ConnectionAlertHelperWithDoubleReturn_e0Q04()
    
    private var connectivityView: ConnectivityView_e0Q04?
    private var hideViewWorkItem: DispatchWorkItem?

    func show() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }

        if connectivityView == nil {
            connectivityView = ConnectivityView_e0Q04(frame: window.bounds)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
            connectivityView?.addGestureRecognizer(tapGesture)
        }

        if let connectivityView = connectivityView, !connectivityView.isDescendant(of: window) {
            window.addSubview(connectivityView)

            // Cancel the previous work item if it was not completed
            hideViewWorkItem?.cancel()

            // Create a new work item to hide the view
            let workItem = DispatchWorkItem { [weak self] in
                self?.hide()
            }
            hideViewWorkItem = workItem

            // Execute the work item after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: workItem)
        }
    }

    func hide() {
        connectivityView?.removeFromSuperview()

        if let navigationController = SceneDelegate.shared?.window?.topViewController?.navigationController {
            var viewControllers = navigationController.viewControllers
            let count = viewControllers.count
            if count > 2 {
                viewControllers.removeLast(2) // Remove the last two view controllers
                navigationController.setViewControllers(viewControllers, animated: true)
            } else {
                navigationController.popViewController(animated: true)
            }
        }
    }

    @objc private func viewTapped() {
        hideViewWorkItem?.cancel()
        hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.hide()
        }
    }

    private init() {
        func adiwQSJDwsa_e0Q04() -> Int {
            let result = Int.random(in: 1...100) + Int.random(in: 1...100)
            return result
        }
    }
}
