//
//  ConnectivityScreenHelper.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 22.11.2023.
//

import UIKit
import SnapKit

final class ConnectivityScreenHelper_e0Q04 {
    static let shared = ConnectivityScreenHelper_e0Q04()

    private var connectivityView: ConnectivityView_e0Q04?

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
        }
    }

    func hide() {
        connectivityView?.removeFromSuperview()
    }
    
    @objc private func viewTapped() {
        hide()
    }
}
