//
//  CharacterCellButton.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 08.12.2023.
//

import UIKit

class CharacterCellButton_e0Q04: UIButton {

    // Initialize the button with default styling
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        layer.cornerRadius = 8
        layer.borderWidth = Configs_e0Q04.shared.currentDevice.isPad ? 5 : 3
        layer.borderColor = UIColor.customDarkBlue.cgColor
        contentMode = .scaleAspectFit
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Calculate image size, e.g., 50% of button size
        let imageEdgeSize = min(bounds.width, bounds.height) * 0.5
        let imageSize = CGSize(width: imageEdgeSize, height: imageEdgeSize)

        // Center the image in the button
        let imageX = (bounds.width - imageSize.width) / 2
        let imageY = (bounds.height - imageSize.height) / 2
        imageView?.frame = CGRect(x: imageX, y: imageY, width: imageSize.width, height: imageSize.height)
    }
}
