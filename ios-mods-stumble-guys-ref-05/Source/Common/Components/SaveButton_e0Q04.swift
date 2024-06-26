//
//  SaveButton.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 04.12.2023.
//

import UIKit

final class SaveButton_e0Q04: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if Configs_e0Q04.shared.currentDevice.isPad {
            setupButtonStylingIPad()
        } else {
            setupButtonStyling()
        }
        addShadow_e0Q04()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        if Configs_e0Q04.shared.currentDevice.isPad {
            setupButtonStylingIPad()
        } else {
            setupButtonStyling()
        }
        addShadow_e0Q04()
    }
    
    private func setupButtonStyling() {
        backgroundColor = .myGreen
        titleLabel?.font = Assets.Fredoka.medium(14)
        setTitleColor(UIColor.customWhite, for: .normal)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    private func setupButtonStylingIPad() {
        backgroundColor = .myGreen
        titleLabel?.font = Assets.Fredoka.medium(25)
        setTitleColor(UIColor.customWhite, for: .normal)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 4
        layer.cornerRadius = 30
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
