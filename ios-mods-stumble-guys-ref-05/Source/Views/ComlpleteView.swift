//
//  ConfirmationView.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 24.11.2023.
//

import UIKit
import SnapKit

final class CompleteView: UIView {
        
    lazy var backgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = layer.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.85
        return blurEffectView
    }()
    
    private var barView: BlueViewWithStroke_e0Q04 = {
        let view = BlueViewWithStroke_e0Q04()
        if Configs_e0Q04.shared.currentDevice.isPad {
            view.layer.cornerRadius = 50
        }else{
            view.layer.cornerRadius = 24
        }
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Complete"
        label.font = Assets.Fredoka.bold(24)
        label.textAlignment = .center
        label.textColor = .customWhite
        return label
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        if Configs_e0Q04.shared.currentDevice.isPad {
            setupViewsIPad_e0Q04()
        } else {
            setupViews_e0Q04()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews_e0Q04() {
        addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(barView)
        
        barView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(284)
            make.height.equalTo(69)
        }
        
        barView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupViewsIPad_e0Q04() {
        titleLabel.font = Assets.Fredoka.bold(40)
        addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(barView)
        
        barView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(500)
            make.height.equalTo(130)
        }
        
        barView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
}


