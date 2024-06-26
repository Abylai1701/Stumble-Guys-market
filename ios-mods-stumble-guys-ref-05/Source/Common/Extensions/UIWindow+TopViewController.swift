//
//  UIWindow+TopViewController.swift
//  ios-sims-4-mods
//
//  Created by Alisher on 27.10.2023.
//

import UIKit

func adiwQSJ1234Dwsa_e0Q04() -> Int {
    let result = Int.random(in: 1...100) + Int.random(in: 1...100)
    return result
}

typealias UIWindow_ = UIWindow

extension UIWindow_ {
    var topViewController: UIViewController? {
        var top = rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}
