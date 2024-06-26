//
//  LoadingScreenHelper.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 22.11.2023.
//

import UIKit
import SnapKit

final class LoadingScreenHelper_e0Q04 {
    var loadingView: LoadingView_e0Q04?

    func show() {
        guard let topViewController = getTopViewController() else { return }

        if loadingView == nil {
            loadingView = LoadingView_e0Q04(frame: topViewController.view.bounds)
        }

        if let loadingView = loadingView, !loadingView.isDescendant(of: topViewController.view) {
            topViewController.view.addSubview(loadingView)
            
            loadingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }

    private func getTopViewController(base: UIViewController? = nil) -> UIViewController? {
        // Определяем базовый контроллер, если он не передан
        let base = base ?? UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }.first?.rootViewController

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
    

    func hide() {
        loadingView?.removeFromSuperview()
    }
}
