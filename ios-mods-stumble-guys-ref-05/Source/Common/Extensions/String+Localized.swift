//
//  String+Localized.swift
//  ios-sims-4-mods
//
//  Created by Alisher on 20.10.2023.
//

import Foundation
extension String {
    var localizedUI: String {
        return NSLocalizedString(self, tableName: "UserInterface", bundle: .main, value: "", comment: "")
    }
}
