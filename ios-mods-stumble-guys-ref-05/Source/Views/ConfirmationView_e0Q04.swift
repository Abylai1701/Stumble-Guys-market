//
//  ConfirmationView.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 24.11.2023.
//

import UIKit
import SnapKit

final class ConfirmationView_e0Q04: UIView {
    
    var height: CGFloat
    
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customLightBlue.withAlphaComponent(0.5)
        return view
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
        label.text = "reminderTitle".localizedUI
        label.font = Assets.Fredoka.bold(24)
        label.textAlignment = .center
        label.textColor = .customWhite
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
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

    lazy var blueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("CANCEL", for: .normal)
        button.setTitleColor(.myGreen, for: .normal)
        button.layer.shadowColor = UIColor.customBlack.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 2
        if Configs_e0Q04.shared.currentDevice.isPad {
            button.titleLabel?.font = Assets.Fredoka.semiBold(20)
            button.layer.cornerRadius = 28
        }else{
            button.titleLabel?.font = Assets.Fredoka.semiBold(16)
            button.layer.cornerRadius = 20
        }
        return button
    }()
    
    lazy var redButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .redColor
        button.setTitle("DELETE", for: .normal)
        button.layer.shadowColor = UIColor.customBlack.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 2
        button.setTitleColor(.white, for: .normal)
        if Configs_e0Q04.shared.currentDevice.isPad {
            button.titleLabel?.font = Assets.Fredoka.semiBold(20)
            button.layer.cornerRadius = 28
        }else{
            button.titleLabel?.font = Assets.Fredoka.semiBold(16)
            button.layer.cornerRadius = 20
        }
        return button
    }()
    var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
 
    // Инициализатор с заданием высоты для barView без использования frame
    init(barViewHeight: CGFloat) {
        self.height = barViewHeight // Преобразуем CGFloat в Int для соответствия типов
        super.init(frame: .zero) // Создаём с нулевым frame
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
            make.height.equalTo(height)
        }
        
        buttonStackView.addArrangedSubview(blueButton)
        buttonStackView.addArrangedSubview(redButton)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(buttonStackView)
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(barView)
            make.leading.trailing.equalTo(barView).inset(20)
        }
        
        blueButton.snp.makeConstraints { make in
            make.height.equalTo(41)
        }
        
        redButton.snp.makeConstraints { make in
            make.height.equalTo(41)
        }
    }
    
    private func setupViewsIPad_e0Q04() {
        titleLabel.font = Assets.Fredoka.bold(36)
        descriptionLabel.font = Assets.Inter.regular(24)
        stackView.spacing = 20
        buttonStackView.spacing = 20
        blueButton.titleLabel?.font = Assets.Fredoka.semiBold(24)
        redButton.titleLabel?.font = Assets.Fredoka.semiBold(24)
        
        addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(barView)
        
        barView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(590)
            make.height.equalTo(height)
        }
        
        buttonStackView.addArrangedSubview(blueButton)
        buttonStackView.addArrangedSubview(redButton)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(buttonStackView)
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(barView)
            make.leading.trailing.equalTo(barView).inset(20)
        }
        
        blueButton.snp.makeConstraints { make in
            make.height.equalTo(57)
        }
        
        redButton.snp.makeConstraints { make in
            make.height.equalTo(57)
        }
    }
}


