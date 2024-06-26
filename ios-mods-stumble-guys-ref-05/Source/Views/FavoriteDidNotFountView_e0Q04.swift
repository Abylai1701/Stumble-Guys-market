import UIKit
import SnapKit
import DeviceKit

final class FavoriteDidNotFountView_e0Q04: UIView {
    
    lazy var mainView: BlueViewWithStroke_e0Q04 = {
        let view = BlueViewWithStroke_e0Q04()
        view.clipsToBounds = false
        if Configs_e0Q04.shared.currentDevice.isPad {
            view.layer.cornerRadius = 26
        } else {
            view.layer.cornerRadius = 24
        }
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.text = "You have not added anything to \"Favorites\" yet."
        if Configs_e0Q04.shared.currentDevice.isPad {
            label.font = Assets.Fredoka.medium(24)
        }else{
            label.font = Assets.Fredoka.semiBold(16)
        }
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews_e0Q04()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews_e0Q04() {
        addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(12)
            make.right.bottom.equalToSuperview().offset(-12)
        }
    }
}
