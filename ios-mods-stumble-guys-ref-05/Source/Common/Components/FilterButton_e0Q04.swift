//
//  FilterButton.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 01.12.2023.
//

import UIKit
import DeviceKit

final class FilterButton_e0Q04: UIButton {
    
    let fontSize: CGFloat = Device.current.isPad ? 28 : 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtonStyling()
        addShadow_e0Q04()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButtonStyling()
        addShadow_e0Q04()
    }
    
    private func setupButtonStyling() {
        backgroundColor = .myGreen // You can change the default color here
        titleLabel?.font = Assets.Fredoka.semiBold(fontSize)
        setTitleColor(UIColor.customWhite, for: .normal) // Default title color
        layer.borderColor = UIColor.white.cgColor
        
        if Configs_e0Q04.shared.currentDevice.isPad {
            layer.borderWidth = 5
            layer.cornerRadius = 40
        } else {
            layer.borderWidth = 2
            layer.cornerRadius = 20
        }
        clipsToBounds = true
        
    }
    
    private func addShadow_e0Q04() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.customBlack.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 2
    }
}
