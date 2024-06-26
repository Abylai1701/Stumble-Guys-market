//
//  CharacterCell.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 28.11.2023.
//

import UIKit
import SnapKit
import DeviceKit

protocol CharacterCellDelegate: AnyObject {
    func didTapDeleteButton(in cell: CharacterCell_e0Q04)
    func didTapEditButton(in cell: CharacterCell_e0Q04)
}

class CharacterCell_e0Q04: UICollectionViewCell {
    
    weak var delegate: CharacterCellDelegate?
    
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .customBlue
        view.layer.cornerRadius = 18
        view.layer.borderWidth = Configs_e0Q04.shared.currentDevice.isPad ? 6 : 4
        view.layer.borderColor = UIColor.customDarkBlue.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var deleteButton: CharacterCellButton_e0Q04 = {
        let button = CharacterCellButton_e0Q04()
        button.backgroundColor = .customRed
        button.setImage(Assets.Icon.trash, for: .normal)
        return button
    }()

    var editButton: CharacterCellButton_e0Q04 = {
        let button = CharacterCellButton_e0Q04()
        button.backgroundColor = .customBlue
        button.setImage(Assets.Icon.pen, for: .normal)
        return button
    }()
    
    var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews_e0Q04()
        setupButtonActions_e0Q04()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func deleteButtonTapped_e0Q04() {
        delegate?.didTapDeleteButton(in: self)
    }

    @objc private func editButtonTapped_e0Q04() {
        delegate?.didTapEditButton(in: self)
    }
    
    private func setupButtonActions_e0Q04() {
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped_e0Q04), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonTapped_e0Q04), for: .touchUpInside)
    }
    
    private func setupViews_e0Q04() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        buttonStackView.addArrangedSubview(deleteButton)
        buttonStackView.addArrangedSubview(editButton)
        
        containerView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(containerView).inset(12)
            let stackViewHeight: CGFloat = Configs_e0Q04.shared.currentDevice.isPad ? 64 : 34
            make.height.equalTo(stackViewHeight)
        }
        
        containerView.addSubview(characterImageView)
        characterImageView.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            
            let device = Device.current
            if device.isOneOf([.iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadMini6,
                               .simulator(.iPadMini), .simulator(.iPadMini2), .simulator(.iPadMini3),
                               .simulator(.iPadMini4), .simulator(.iPadMini5), .simulator(.iPadMini6)]) {
                // Settings for iPad Mini
                make.centerY.equalTo(containerView).offset(30)
                make.size.equalTo(630)
            } else if device.isOneOf([.iPadPro11Inch, .iPadPro11Inch2, .iPadPro11Inch3, .iPadPro11Inch4,
                                      .simulator(.iPadPro11Inch), .simulator(.iPadPro11Inch2),
                                      .simulator(.iPadPro11Inch3), .simulator(.iPadPro11Inch4)]) {
                // Settings for iPad Pro 11-inch
                make.centerY.equalTo(containerView).offset(30)
                make.size.equalTo(630)
            } else if device.isPad {
                // Settings for other iPad models
                make.centerY.equalTo(containerView).offset(30)
                make.size.equalTo(630)
            } else if device.isOneOf([.iPhoneSE, .iPhoneSE2, .iPhoneSE3, .simulator(.iPhoneSE), .simulator(.iPhoneSE2), .simulator(.iPhoneSE3)]) {
                // Settings for iPhone SE series
                make.centerY.equalTo(containerView).offset(30)
                make.size.equalTo(470)
            } else if device.isPhone {
                // Settings for other iPhone models
                make.centerY.equalTo(containerView).offset(20)
                make.size.equalTo(480)
            }
        }
    }
}
