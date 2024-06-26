//
//  HeaderView.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 20.11.2023.
//

import UIKit
import SnapKit
import DeviceKit

class HeaderView_e0Q04: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        let fontSize = Device.current.isPad ? 42 : 28
        label.font = Assets.Fredoka.bold(CGFloat(fontSize))
        label.textColor = .white
        return label
    }()
    
    var leftButton: RoundedButton_e0Q04 = {
        let button = RoundedButton_e0Q04()
        button.setImage(Assets.Icon.menu, for: .normal)
        return button
    }()
    
    var rightButton: RoundedButton_e0Q04 = {
        let button = RoundedButton_e0Q04()
        button.setImage(Assets.Icon.download, for: .normal)
        return button
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews_e0Q04()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews_e0Q04() {
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        addSubview(leftButton)
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            let buttonSize = Device.current.isPad ? 72 : 40
            make.size.equalTo(buttonSize)
        }

        addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            let buttonSize = Device.current.isPad ? 72 : 40
            make.size.equalTo(buttonSize)
        }
    }
}
