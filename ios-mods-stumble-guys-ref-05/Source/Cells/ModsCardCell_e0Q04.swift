import UIKit
import SnapKit
import DeviceKit
import FLAnimatedImage

class ModsCardCell_e0Q04: UICollectionViewCell {
    
    lazy var mainView: BlueViewWithStroke_e0Q04 = {
        let view = BlueViewWithStroke_e0Q04()
        if Configs_e0Q04.shared.currentDevice.isPad {
            view.layer.cornerRadius = 33
        }else{
            view.layer.cornerRadius = 22
        }
        return view
    }()
    
    lazy var previewImage: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.contentMode = .scaleAspectFill
        if Configs_e0Q04.shared.currentDevice.isPad {
            imageView.layer.cornerRadius = 20
        } else {
            imageView.layer.cornerRadius = 18
        }
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var cardDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGreen
        view.layer.cornerRadius = 18
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        let device = Device.current
        if device.isOneOf([.iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadMini6,
                           .simulator(.iPadMini), .simulator(.iPadMini2), .simulator(.iPadMini3),
                           .simulator(.iPadMini4), .simulator(.iPadMini5), .simulator(.iPadMini6)]) {
            label.font = Assets.Fredoka.semiBold(18)
        } else if device.isPad {
            label.font = Assets.Fredoka.semiBold(24)
        } else {
            label.font = Assets.Fredoka.semiBold(16)
        }
        
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        let device = Device.current
        if device.isOneOf([.iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadMini6,
                           .simulator(.iPadMini), .simulator(.iPadMini2), .simulator(.iPadMini3),
                           .simulator(.iPadMini4), .simulator(.iPadMini5), .simulator(.iPadMini6)]) {
            label.font = Assets.Fredoka.regular(14)
        } else if device.isPad {
            label.font = Assets.Fredoka.regular(18)
        } else {
            label.font = Assets.Fredoka.regular(12)
        }
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.setTitle("DOWNLOAD", for: .normal)
        button.setTitleColor(.myGreen, for: .normal)
        if Configs_e0Q04.shared.currentDevice.isPad {
            button.titleLabel?.font = Assets.Fredoka.semiBold(24)
        }else{
            button.titleLabel?.font = Assets.Fredoka.semiBold(16)
        }
        button.layer.shadowColor = UIColor.customBlack.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 2
        return button
    }()
    lazy var favoriteButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.customBlack.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 2
        return view
    }()

    lazy var favoriteButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Assets.Icon.favorite1
        return imageView
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews_e0Q04()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        favoriteButtonView.layer.cornerRadius = favoriteButtonView.bounds.width / 2
        favoriteButtonView.layer.masksToBounds = false
        layer.shadowColor = UIColor.customBlack.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private func setupViews_e0Q04() {
        addSubview(mainView)
        mainView.addSubview(previewImage)
        mainView.addSubview(cardDescriptionView)
        cardDescriptionView.addSubview(titleLabel)
        cardDescriptionView.addSubview(descriptionLabel)
        mainView.addSubview(favoriteButtonView)
        favoriteButtonView.addSubview(favoriteButton)
        favoriteButtonView.addSubview(favoriteButtonImage)
        mainView.addSubview(downloadButton)
        
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        previewImage.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(124)
        }
        
        cardDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(previewImage.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-12)
            make.left.equalToSuperview().offset(12)
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.height.equalTo(135)
            }else{
                make.height.equalTo(90)
            }
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.right.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
        }
        
        favoriteButtonView.snp.makeConstraints { make in
            make.top.equalTo(cardDescriptionView.snp.bottom).offset(8)
            make.right.bottom.equalToSuperview().offset(-12)
            make.size.equalTo(41)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        favoriteButtonImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(21)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(cardDescriptionView.snp.bottom).offset(8)
            make.right.equalTo(favoriteButtonView.snp.left).offset(-8)
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(41)
        }
    }
}
