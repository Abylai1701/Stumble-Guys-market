//
//  ConnectivityView.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 22.11.2023.
//

import UIKit
import SnapKit

final class ConnectivityView_e0Q04: UIView {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customLightBlue.withAlphaComponent(0.5)
        return view
    }()
    
    private let barView: BlueViewWithStroke_e0Q04 = {
        let view = BlueViewWithStroke_e0Q04()
        view.layer.cornerRadius = 24
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Connection Dropped"
        label.font = Assets.Fredoka.bold(24)
        label.textAlignment = .center
        label.textColor = .customWhite
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Verify your internet connectivity and give it another shot."
        label.font = Assets.Inter.regular(16)
        label.textColor = .customWhite
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
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
            make.leading.trailing.equalToSuperview().inset(53)
            make.height.equalTo(119)
        }
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(barView)
            make.leading.trailing.equalTo(barView).inset(20)
        }
    }
    
    private func setupViewsIPad_e0Q04() {
        titleLabel.font = Assets.Inter.black(36)
        descriptionLabel.font = Assets.Inter.regular(24)
        stackView.spacing = 20
        
        addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(barView)
        
        barView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(637)
            make.height.equalTo(170)
        }
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(barView)
            make.leading.trailing.equalTo(barView).inset(20)
        }
    }
}
