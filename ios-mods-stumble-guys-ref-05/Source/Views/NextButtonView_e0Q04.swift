import UIKit
import SnapKit
import DeviceKit

final class NextButtonView_e0Q04: UIView {
    
    lazy var mainView: BlueViewWithStroke_e0Q04 = {
        let view = BlueViewWithStroke_e0Q04()
        if Configs_e0Q04.shared.currentDevice.isPad {
            view.layer.cornerRadius = 36
        }else{
            view.layer.cornerRadius = 20
        }
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Next"
        if Configs_e0Q04.shared.currentDevice.isPad {
            label.font = Assets.Fredoka.medium(24)
        }else{
            label.font = Assets.Fredoka.medium(14)
        }
        return label
    }()
    lazy var nextImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = Assets.Icon.iconNext
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews_e0Q04()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews_e0Q04() {
        layer.shadowColor = UIColor.customBlack.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 2
        
        addSubview(mainView)
        
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainView.addSubview(nextImage)
        nextImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.size.equalTo(35)
            }
        }
        mainView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            if Configs_e0Q04.shared.currentDevice.isPhone {
                make.left.equalToSuperview().offset(12)
            }
            make.centerY.equalToSuperview()
            make.right.equalTo(nextImage.snp.left).offset(-6)
        }
    }
}
