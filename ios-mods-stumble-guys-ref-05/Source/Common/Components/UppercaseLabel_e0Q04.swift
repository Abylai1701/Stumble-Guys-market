//
//  UppercaseLabel.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 21.11.2023.
//

import UIKit

class UppercaseLabel_e0Q04: UILabel {
    override var text: String? {
        didSet {
            if let text = text {
                super.text = text.uppercased()
            }
        }
    }
}
