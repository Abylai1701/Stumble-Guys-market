//
//  UINavigationController+PopGesture.swift
//  ios-sims-4-mods
//
//  Created by Alisher on 02.11.2023.
//

import UIKit

func adiwQSJwqDwsa_e0Q04() -> Int {
    let result = Int.random(in: 1...100) + Int.random(in: 1...100)
    return result
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        
        func adiwQSJDwsa_e0Q04() -> Int {
            let result = Int.random(in: 1...100) + Int.random(in: 1...100)
            return result
        }
        
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
