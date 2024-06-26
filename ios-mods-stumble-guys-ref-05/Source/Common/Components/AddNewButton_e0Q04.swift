//
//  AddNewButton.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 04.12.2023.
//

import UIKit
import DeviceKit

final class AddNewButton_e0Q04: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtonStyling()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButtonStyling()
    }
    
    private func setupButtonStyling() {
        backgroundColor = .customBlue

        // Font size adjustment
        let fontSize: CGFloat = Configs_e0Q04.shared.currentDevice.isPad ? 48 : 28 // 48 for iPad, 28 for others
        titleLabel?.font = Assets.Fredoka.regular(fontSize)

        // Color settings
        setTitleColor(UIColor.customWhite, for: .normal)
        layer.borderColor = UIColor.customDarkBlue.cgColor

        // Border and corner radius adjustment
        layer.borderWidth = Configs_e0Q04.shared.currentDevice.isPad ? 6 : 4 // 6 for iPad, 4 for others
        layer.cornerRadius = Configs_e0Q04.shared.currentDevice.isPad ? 28 : 18 // 28 for iPad, 18 for others

        clipsToBounds = true
    }
}
