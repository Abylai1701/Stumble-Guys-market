//
//  BlueViewWithStroke.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 22.11.2023.
//

import UIKit
import DeviceKit

class BlueViewWithStroke_e0Q04: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .myGreen
        if Configs_e0Q04.shared.currentDevice.isPad {
            layer.borderWidth = 4
            layer.cornerRadius = 30
        } else {
            layer.borderWidth = 2
            layer.cornerRadius = 20
        }
        layer.borderColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.customBlack.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 2
        clipsToBounds = true
    }
}
