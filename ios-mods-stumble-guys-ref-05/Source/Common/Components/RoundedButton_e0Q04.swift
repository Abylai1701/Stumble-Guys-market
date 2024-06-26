//
//  RoundedButton.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 24.11.2023.
//

import UIKit
import DeviceKit

class RoundedButton_e0Q04: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .myGreen
        updateCornerRadiusAndBorder()
        addShadow_e0Q04()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadiusAndBorder()
        addShadow_e0Q04()

        // Calculate image size, e.g., 50% of button size
        let imageSize = CGSize(width: Device.current.isPad ? 48 : 24,
                               height: Device.current.isPad ? 48 : 24)

        // Center the image in the button
        let imageX = (bounds.width - imageSize.width) / 2
        let imageY = (bounds.height - imageSize.height) / 2

        imageView?.frame = CGRect(x: imageX,
                                  y: imageY,
                                  width: imageSize.width,
                                  height: imageSize.height)
        imageView?.contentMode = .scaleAspectFit  // Maintain the aspect ratio
    }

    private func updateCornerRadiusAndBorder() {
        let buttonSize = min(self.bounds.width, self.bounds.height)
        self.layer.cornerRadius = buttonSize / 2
        let borderWidth: CGFloat = Configs_e0Q04.shared.currentDevice.isPad ? 4 : 2
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    private func addShadow_e0Q04() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.customBlack.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 2
    }
}
