//
//  DownloadedScreenHelper.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 22.11.2023.
//

import UIKit
import SnapKit

final class DownloadedScreenHelper_e0Q04 {
    static let shared = DownloadedScreenHelper_e0Q04()

    private var downloadedView: DownloadSuccessView_e0Q04?

    func show() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }

        if downloadedView == nil {
            downloadedView = DownloadSuccessView_e0Q04(frame: window.bounds)
        }

        if let downloadedView = downloadedView, !downloadedView.isDescendant(of: window) {
            window.addSubview(downloadedView)
        }
    }

    func hide() {
        downloadedView?.removeFromSuperview()
    }

    private init() {
        func adiwQSJDwsa_e0Q04() -> Int {
            let result = Int.random(in: 1...100) + Int.random(in: 1...100)
            return result
        }
    }
}
