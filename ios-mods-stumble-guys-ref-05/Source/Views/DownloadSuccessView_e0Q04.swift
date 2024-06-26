//
//  DownloadSuccessView.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 22.11.2023.
//

import UIKit
import SnapKit

final class DownloadSuccessView_e0Q04: UIView {
    
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customLightBlue.withAlphaComponent(0.2)
        return view
    }()
    
    var barView: BlueViewWithStroke_e0Q04 = {
        let view = BlueViewWithStroke_e0Q04()
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "downloadedTitle".localizedUI
        label.font = Assets.Inter.black(20)
        label.textColor = .customWhite
        return label
    }()
    
    var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Assets.Icon.check
        return imageView
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
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
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(checkImageView)
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(barView)
        }
        
        checkImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
    }
    
    private func setupViewsIPad_e0Q04() {
        titleLabel.font = Assets.Inter.black(36)
        
        addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(barView)
        
        barView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(637)
            make.height.equalTo(102)
        }
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(checkImageView)
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(barView)
        }
        
        checkImageView.snp.makeConstraints { make in
            make.size.equalTo(36)
        }
    }
}
