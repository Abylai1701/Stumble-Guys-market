import UIKit
import SnapKit
import DeviceKit

final class BackElementView_e0Q04: UIView {
    
    lazy var mainView: BlueViewWithStroke_e0Q04 = {
        let view = BlueViewWithStroke_e0Q04()
        view.layer.borderColor = UIColor.grayColor2.cgColor
        view.backgroundColor = .lightGreen
        if Configs_e0Q04.shared.currentDevice.isPad {
            view.layer.cornerRadius = 40
        }else{
            view.layer.cornerRadius = 20
        }
        
        return view
    }()
    
    lazy var backImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = Assets.Icon.iconBack4
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
        mainView.addSubview(backImage)
        backImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.size.equalTo(48)
            }else{
                make.size.equalTo(24)
            }
        }
    }
}
