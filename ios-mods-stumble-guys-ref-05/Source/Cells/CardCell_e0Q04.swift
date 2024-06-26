import UIKit
import SnapKit
import DeviceKit

class CardCell_e0Q04: UICollectionViewCell {
    
    var contentHorizontalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        let device = Device.current
        if device.isOneOf([.iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadMini6,
                           .simulator(.iPadMini), .simulator(.iPadMini2), .simulator(.iPadMini3),
                           .simulator(.iPadMini4), .simulator(.iPadMini5), .simulator(.iPadMini6)]) {
            stackView.spacing = 10

        } else if device.isPad {
            stackView.spacing = 10

        } else {
            stackView.spacing = 20
        }
        
        return stackView
    }()
    
    var containerView: BlueViewWithStroke_e0Q04 = {
        let view = BlueViewWithStroke_e0Q04()
        return view
    }()

    var previewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        if Configs_e0Q04.shared.currentDevice.isPad {
            imageView.layer.cornerRadius = 20
        } else {
            imageView.layer.cornerRadius = 12
        }
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var titleLabel: UppercaseLabel_e0Q04 = {
        let label = UppercaseLabel_e0Q04()
        
        let device = Device.current
        if device.isOneOf([.iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadMini6,
                           .simulator(.iPadMini), .simulator(.iPadMini2), .simulator(.iPadMini3),
                           .simulator(.iPadMini4), .simulator(.iPadMini5), .simulator(.iPadMini6)]) {
            label.font = Assets.Fredoka.regular(18)
            label.numberOfLines = 2
        } else if device.isPad {
            label.font = Assets.Fredoka.regular(24)
            label.numberOfLines = 2
        } else {
            label.font = Assets.Fredoka.regular(18)
            label.numberOfLines = 2
        }
        
        label.textColor = .customWhite
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        
        let device = Device.current
        if device.isOneOf([.iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadMini6,
                           .simulator(.iPadMini), .simulator(.iPadMini2), .simulator(.iPadMini3),
                           .simulator(.iPadMini4), .simulator(.iPadMini5), .simulator(.iPadMini6)]) {
            label.font = Assets.Fredoka.regular(16)
            label.numberOfLines = 3
        } else if device.isPad {
            label.font = Assets.Fredoka.regular(18)
            label.numberOfLines = 3
        } else {
            label.font = Assets.Fredoka.regular(16)
            label.numberOfLines = 2
        }
        
        label.textColor = .customWhite
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        if Configs_e0Q04.shared.currentDevice.isPad {
            stackView.spacing = 5
        } else {
            stackView.spacing = 5
        }
        return stackView
    }()
    
    var favoriteButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Assets.Icon.favorite1
        return imageView
    }()
    
    var favoriteButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var favoriteButtonView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews_e0Q04()
        setupConstraints_e0Q04()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyleIPhone_setupViews_e0Q04() {
        
    }
    
    private func setupStyleIPad_setupViews_e0Q04() {
        
    }
    
    private func setupStyleIPadMini_setupViews_e0Q04() {
        
    }
    
    private func setupViews_e0Q04() {
        addSubview(containerView)
        contentHorizontalStack.addArrangedSubview(previewImage)
        contentHorizontalStack.addArrangedSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        contentHorizontalStack.addArrangedSubview(favoriteButtonView)
        containerView.addSubview(contentHorizontalStack)
        favoriteButtonView.addSubview(favoriteButtonImage)
        favoriteButtonView.addSubview(favoriteButton)
    }
    
    private func setupConstraints_e0Q04() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentHorizontalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        previewImage.snp.makeConstraints { make in
            
            let device = Device.current
            if device.isOneOf([.iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadMini6,
                               .simulator(.iPadMini), .simulator(.iPadMini2), .simulator(.iPadMini3),
                               .simulator(.iPadMini4), .simulator(.iPadMini5), .simulator(.iPadMini6)]) {
                make.width.equalTo(123)
            } else if device.isPad {
                make.width.equalTo(140)
            } else {
                make.width.equalTo(123)

            }
            
        }
        
        favoriteButtonView.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
        
        favoriteButtonImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(24)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }
}
