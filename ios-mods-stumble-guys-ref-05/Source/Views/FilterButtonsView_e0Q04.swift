import UIKit
import SnapKit
import DeviceKit

final class FilterButtonsView_e0Q04: UIView {
    
    lazy private var mainView: BlueViewWithStroke_e0Q04 = {
        let view = BlueViewWithStroke_e0Q04()
        view.backgroundColor = .lightGreen
        if Configs_e0Q04.shared.currentDevice.isPad {
            view.layer.cornerRadius = 44
        }else{
            view.layer.cornerRadius = 22
        }
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Filter"
        if Configs_e0Q04.shared.currentDevice.isPad {
            label.font = Assets.Fredoka.medium(28)
        }else{
            label.font = Assets.Fredoka.medium(16)
        }
        return label
    }()
    
    lazy var discardFilterImageView: UIImageView = {
        let view = UIImageView()
        view.image = Assets.Icon.iconDiscard2
        return view
    }()

    lazy var discardButton: UIButton = {
        let button = UIButton()
//        button.isHidden = true
        
        return button
    }()
    var allButton: FilterButton_e0Q04 = {
        let button = FilterButton_e0Q04()
        button.setTitle("ALL".localizedUI, for: .normal)
        return button
    }()

    var favoriteButton: FilterButton_e0Q04 = {
        let button = FilterButton_e0Q04()
        button.setTitle("FAVORITES".localizedUI, for: .normal)
        button.backgroundColor = .lightGreen
        button.setTitleColor(UIColor.myGreen, for: .normal)
        return button
    }()
    
    var newButton: FilterButton_e0Q04 = {
        let button = FilterButton_e0Q04()
        button.setTitle("NEW".localizedUI, for: .normal)
        button.backgroundColor = .lightGreen
        button.setTitleColor(UIColor.myGreen, for: .normal)
        return button
    }()
    
    var topButton: FilterButton_e0Q04 = {
        let button = FilterButton_e0Q04()
        button.setTitle("TOP".localizedUI, for: .normal)
        button.backgroundColor = .lightGreen
        button.setTitleColor(UIColor.myGreen, for: .normal)
        return button
    }()
    
    var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        if Configs_e0Q04.shared.currentDevice.isPad {
            stackView.spacing = 24
        } else {
            stackView.spacing = 12
        }
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        if Configs_e0Q04.shared.currentDevice.isPad {
            stackView.spacing = 24
        } else {
            stackView.spacing = 12
        }
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews_e0Q04()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews_e0Q04() {
        let horizontalStackView1 = UIStackView(arrangedSubviews: [allButton, newButton])
        horizontalStackView1.axis = .horizontal
        horizontalStackView1.distribution = .fillEqually
        if Configs_e0Q04.shared.currentDevice.isPad {
            horizontalStackView1.spacing = 24
        } else {
            horizontalStackView1.spacing = 12
        }

        let horizontalStackView2 = UIStackView(arrangedSubviews: [topButton, favoriteButton])
        horizontalStackView2.axis = .horizontal
        horizontalStackView2.distribution = .fillEqually
        if Configs_e0Q04.shared.currentDevice.isPad {
            horizontalStackView2.spacing = 24
        } else {
            horizontalStackView2.spacing = 12
        }
        
        if Configs_e0Q04.shared.currentDevice.isPad {
            allButton.snp.makeConstraints { make in
                make.height.equalTo(80)
                make.width.equalTo(240)
            }
            newButton.snp.makeConstraints { make in
                make.height.equalTo(80)
                make.width.equalTo(240)
            }
            topButton.snp.makeConstraints { make in
                make.height.equalTo(80)
                make.width.equalTo(240)
            }
            favoriteButton.snp.makeConstraints { make in
                make.height.equalTo(80)
                make.width.equalTo(240)
            }
        }else{
            allButton.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(120)
            }
            newButton.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(120)
            }
            topButton.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(120)
            }
            favoriteButton.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(120)
            }
        }
        verticalStackView.addArrangedSubview(horizontalStackView1)
        verticalStackView.addArrangedSubview(horizontalStackView2)
        
        addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.left.equalToSuperview().offset(40)
                make.top.equalToSuperview().offset(40)
            }else{
                make.left.equalToSuperview().offset(20)
                make.top.equalToSuperview().offset(20)
            }
        }
        
        mainView.addSubview(discardFilterImageView)
        
        discardFilterImageView.snp.makeConstraints { make in
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.top.equalToSuperview().offset(40)
                make.right.equalToSuperview().offset(-40)
                make.size.equalTo(48)
            }else{
                make.top.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.size.equalTo(24)
            }
        }
        mainView.addSubview(discardButton)
        discardButton.snp.makeConstraints { make in
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.top.equalToSuperview().offset(40)
                make.right.equalToSuperview().offset(-40)
                make.size.equalTo(48)
            }else{
                make.top.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.size.equalTo(24)
            }
        }
        mainView.addSubview(verticalStackView)
        
        verticalStackView.snp.makeConstraints { make in
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.top.equalTo(titleLabel.snp.bottom).offset(40)
                make.right.equalToSuperview().offset(-40)
                make.left.equalToSuperview().offset(40)
                make.bottom.equalToSuperview().offset(-40)
            }else{
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
                make.right.equalToSuperview().offset(-20)
                make.left.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().offset(-20)
            }
        }
    }
}
