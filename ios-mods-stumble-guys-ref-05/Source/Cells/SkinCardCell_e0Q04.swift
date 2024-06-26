import UIKit
import SnapKit
import DeviceKit
import FLAnimatedImage

class SkinCardCell_e0Q04: UICollectionViewCell {
    
    lazy var mainView: BlueViewWithStroke_e0Q04 = {
        let view = BlueViewWithStroke_e0Q04()
        if Configs_e0Q04.shared.currentDevice.isPad {
            view.layer.cornerRadius = 36
        }else{
            view.layer.cornerRadius = 24
        }
        view.layer.masksToBounds = false
        return view
    }()
    lazy var cardImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGreen
        if Configs_e0Q04.shared.currentDevice.isPad {
            view.layer.cornerRadius = 30
        } else {
            view.layer.cornerRadius = 18
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
        if Configs_e0Q04.shared.currentDevice.isPad {
            view.layer.cornerRadius = 24
        } else {
            view.layer.cornerRadius = 16
        }
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
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
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    lazy var downloadButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 2
        view.layer.masksToBounds = false
        return view
    }()

    lazy var downloadButtonImage: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = Assets.Icon.downloadGreen
        imageView.image = Assets.Icon.downloadGreen
        return imageView
    }()
    lazy var buttonDownload: UIButton = {
        let imageView = UIButton()
        return imageView
    }()
    lazy var favoriteButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = view.bounds.width / 2
        view.layer.shadowColor = UIColor.customBlack.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 2
        view.layer.masksToBounds = false
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        favoriteButtonView.layer.cornerRadius = favoriteButtonView.bounds.width / 2
        favoriteButtonView.layer.masksToBounds = false
    }
    private func setupStyleIPhone_setupViews_e0Q04() {
        
    }
    
    private func setupStyleIPad_setupViews_e0Q04() {
        
    }
    
    private func setupStyleIPadMini_setupViews_e0Q04() {
        
    }
    
    private func setupViews_e0Q04() {
        addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainView.addSubview(cardImageView)
        cardImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(184)
        }
        
        cardImageView.addSubview(previewImage)
        previewImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-19)
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(19)
        }
        
        mainView.addSubview(cardDescriptionView)
        cardDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(cardImageView.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-12)
            make.left.equalToSuperview().offset(12)
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.height.equalTo(50)
            }else{
                make.height.equalTo(31)
            }
        }
        
        cardDescriptionView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }

        mainView.addSubview(favoriteButtonView)
        favoriteButtonView.snp.makeConstraints { make in
            make.top.equalTo(cardDescriptionView.snp.bottom).offset(8)
            make.right.bottom.equalToSuperview().offset(-12)
            make.size.equalTo(41)
        }
        
        favoriteButtonView.addSubview(favoriteButton)
        favoriteButtonView.addSubview(favoriteButtonImage)
        
        favoriteButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        favoriteButtonImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(21)
        }
        
        mainView.addSubview(downloadButtonView)
        downloadButtonView.snp.makeConstraints { make in
            make.top.equalTo(cardDescriptionView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.right.equalTo(favoriteButtonView.snp.left).offset(-8)
            make.height.equalTo(41)
        }
        
        downloadButtonView.addSubview(downloadButtonImage)
        downloadButtonImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(21)
        }
        downloadButtonView.addSubview(buttonDownload)
        buttonDownload.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
