//
//  AddNewCell.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 28.11.2023.
//

import UIKit
import SnapKit
import DeviceKit

class AddNewCell_e0Q04: UICollectionViewCell {
    
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .customBlue
        view.layer.cornerRadius = 18
        view.layer.borderWidth = Configs_e0Q04.shared.currentDevice.isPad ? 6 : 4
        view.layer.borderColor = UIColor.customDarkBlue.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Add New"
        
        let device = Device.current
        if device.isOneOf([.iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadMini6, .iPadPro11Inch, .iPadPro11Inch2, .simulator(.iPadPro11Inch2), .iPadPro11Inch3, .simulator(.iPadPro11Inch3), .iPadPro11Inch4, .simulator(.iPadPro11Inch4),
                           .simulator(.iPadMini), .simulator(.iPadMini2), .simulator(.iPadMini3),
                           .simulator(.iPadMini4), .simulator(.iPadMini5), .simulator(.iPadMini6)]) {

            let fontSize: CGFloat = 40
            label.font = Assets.Fredoka.regular(fontSize)

            
        } else if device.isPad {
            
            let fontSize: CGFloat = 58
            label.font = Assets.Fredoka.regular(fontSize)


        } else if device.isOneOf([.iPadPro11Inch, .iPadPro11Inch2, .iPadPro11Inch3, .iPadPro11Inch4, .simulator(.iPadPro11Inch2), .simulator(.iPadPro11Inch3), .simulator(.iPadPro11Inch4)]) {
                                      
            let fontSize: CGFloat = 40
            label.font = Assets.Fredoka.regular(fontSize)


        } else {
            let fontSize: CGFloat = 38
            label.font = Assets.Fredoka.regular(fontSize)

        }
        
        label.textColor = .customWhite
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews_e0Q04()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews_e0Q04() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
