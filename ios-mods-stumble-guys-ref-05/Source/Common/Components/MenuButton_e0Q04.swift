//
//  MenuButton.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 20.11.2023.
//

import UIKit
import DeviceKit

final class MenuButton_e0Q04: UIButton {
    
    var lockImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Assets.Icon.lock2
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtonStyling()
        addShadow_e0Q04()
        configureImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButtonStyling()
        addShadow_e0Q04()
        configureImageView()
    }
    
    private func setupButtonStyling() {
        backgroundColor = .lightGreen
        setTitleColor(UIColor.myGreen, for: .normal)
        if Configs_e0Q04.shared.currentDevice.isPad {
            layer.cornerRadius = 50
            titleLabel?.font = Assets.Fredoka.bold(36)
        }else{
            layer.cornerRadius = 30
            titleLabel?.font = Assets.Fredoka.bold(24)
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
    
    private func configureImageView() {
        addSubview(lockImage)
        
        lockImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-18)
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.height.width.equalTo(64)
            }else{
                make.height.width.equalTo(32)
            }
        }
    }
}
