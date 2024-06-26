//
//  ButtonCell.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 28.11.2023.
//

import UIKit
import SnapKit

class ResetButtonCell_e0Q04: UICollectionViewCell {
    
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .customWhite
        if Configs_e0Q04.shared.currentDevice.isPad {
            view.layer.borderWidth = 4
        }else{
            view.layer.borderWidth = 2
        }
        view.layer.borderColor = UIColor.myGreen.cgColor
        return view
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Assets.Icon.iconDiscard4
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if Configs_e0Q04.shared.currentDevice.isPad {
            setupViewsIPad_e0Q04()
        } else {
            setupViews_e0Q04()
        }
        layer.shadowColor = UIColor.customBlack.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 2
        layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews_e0Q04() {
        backgroundColor = .clear
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(74)
        }
        
        containerView.layoutIfNeeded()
        
        containerView.layer.cornerRadius = containerView.bounds.width / 2
        containerView.clipsToBounds = true
        
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalTo(containerView)
            make.size.equalTo(46)
        }
    }
    
    private func setupViewsIPad_e0Q04() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(165)
        }
        
        containerView.layoutIfNeeded()
        
        containerView.layer.cornerRadius = containerView.bounds.width / 2
        containerView.clipsToBounds = true
        
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalTo(containerView)
            make.size.equalTo(100)
        }
    }
}
