import UIKit
import SnapKit
import DeviceKit
import FLAnimatedImage

class HacksCardCell_e0Q04: UICollectionViewCell {
    
    lazy var mainView: BlueViewWithStroke_e0Q04 = {
        let view = BlueViewWithStroke_e0Q04()
        if Configs_e0Q04.shared.currentDevice.isPad {
            view.layer.cornerRadius = 33
        }else{
            view.layer.cornerRadius = 22
        }
        view.layer.masksToBounds = false
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews_e0Q04()
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
        addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainView.addSubview(previewImage)
        previewImage.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(164)
        }
        
        mainView.addSubview(cardDescriptionView)
        cardDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(previewImage.snp.bottom).offset(8)
            make.right.bottom.equalToSuperview().offset(-12)
            make.left.equalToSuperview().offset(12)
//            make.height.equalTo(90)
        }
        
        cardDescriptionView.addSubview(titleLabel)
        cardDescriptionView.addSubview(descriptionLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.right.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
        }
    }
}
