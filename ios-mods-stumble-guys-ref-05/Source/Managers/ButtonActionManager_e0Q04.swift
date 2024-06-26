//
//  File.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 24.11.2023.
//

import UIKit

class ButtonActionManager_e0Q04 {
    static let shared = ButtonActionManager_e0Q04()
    
    private(set) var isButtonActionInProgress: Bool = false

    func beginAction() -> Bool {
        if isButtonActionInProgress {
            return false
        }
        isButtonActionInProgress = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isButtonActionInProgress = false
        }

        return true
    }
}

class ButtonActionManager2_e0Q04adf {
    static let shared = ButtonActionManager2_e0Q04adf()
    
    private(set) var isButtonActionInProgress: Bool = false

    func beginAction() -> Bool {
        if isButtonActionInProgress {
            return false
        }
        isButtonActionInProgress = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.isButtonActionInProgress = false
        }

        return true
    }
}
