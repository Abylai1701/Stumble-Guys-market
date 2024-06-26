//
//  LoadingView.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 20.11.2023.
//

import UIKit
import SnapKit
import Lottie

final class LoadingViewFromMenu: UIView {
    
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Assets.Background.clouds
        return imageView
    }()

    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customLightBlue.withAlphaComponent(0.5)
        return view
    }()
    
    var loadingBarView: BlueViewWithStroke_e0Q04 = {
        let view = BlueViewWithStroke_e0Q04()
        if Configs_e0Q04.shared.currentDevice.isPad {
            view.layer.cornerRadius = 50
        }
        return view
    }()
    
    var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading".localizedUI
        label.font = Assets.Inter.black(20)
        label.textColor = .customWhite
        return label
    }()
    
    var animationView: LottieAnimationView = {
        let animView = LottieAnimationView(name: Animation.dots)
        animView.loopMode = .loop
        return animView
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
        animationView.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews_e0Q04() {
        backgroundColor = .customWhite
        
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(loadingBarView)
        loadingBarView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
        
        stackView.addArrangedSubview(loadingLabel)
        stackView.addArrangedSubview(animationView)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalTo(loadingBarView)
        }
        
        animationView.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
    }
    
    private func setupViewsIPad_e0Q04() {
        loadingLabel.font = Assets.Inter.black(36)
        stackView.spacing = 20
        
        backgroundColor = .customWhite
        
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(loadingBarView)
        loadingBarView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(637)
            make.height.equalTo(102)
        }
        
        stackView.addArrangedSubview(loadingLabel)
        stackView.addArrangedSubview(animationView)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalTo(loadingBarView)
            make.height.equalTo(102)
        }
        
        animationView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
    }
}
