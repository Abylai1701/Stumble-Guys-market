import UIKit
import SnapKit
import DeviceKit
import SDWebImage

class BaseSingleController: UIViewController {
        
    var header = HeaderView_e0Q04()
    var containerStackView = UIView()
    var contentStackView = UIStackView()
    var contentScrollView = UIScrollView()
    var completeView = CompleteView()
    var loadingView = LoadingView_e0Q04()
    var downloader = DropboxDownloader_e0Q04()
    var backgroundImageView = UIImageView()
    var configs = Configs_e0Q04.shared

    lazy var mainView: BlueViewWithStroke_e0Q04 = {
        let view = BlueViewWithStroke_e0Q04()
        if Configs_e0Q04.shared.currentDevice.isPad {
            view.layer.cornerRadius = 36
        }else{
            view.layer.cornerRadius = 22
        }
        view.layer.masksToBounds = false
        return view
    }()
    
    lazy var mainDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGreen
        if Configs_e0Q04.shared.currentDevice.isPad {
            view.layer.cornerRadius = 36
        } else {
            view.layer.cornerRadius = 18
        }
        return view
    }()
    
    lazy var previewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        if Configs_e0Q04.shared.currentDevice.isPad {
            imageView.layer.cornerRadius = 36
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
            view.layer.cornerRadius = 36
        } else {
            view.layer.cornerRadius = 18
        }
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
            label.font = Assets.Fredoka.semiBold(24)
        } else if device.isPad {
            label.font = Assets.Fredoka.semiBold(30)
        } else {
            label.font = Assets.Fredoka.semiBold(20)
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
            label.font = Assets.Fredoka.regular(16)
            label.numberOfLines = 0
        } else if device.isPad {
            label.font = Assets.Fredoka.regular(22)
            label.numberOfLines = 0
        } else {
            label.font = Assets.Fredoka.regular(14)
            label.numberOfLines = 0
        }
        label.textAlignment = .center
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("DOWNLOAD", for: .normal)
        button.setTitleColor(.myGreen, for: .normal)
        button.layer.shadowColor = UIColor.customBlack.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 2
        if Configs_e0Q04.shared.currentDevice.isPad {
            button.titleLabel?.font = Assets.Fredoka.semiBold(30)
            button.layer.cornerRadius = 34
        }else{
            button.titleLabel?.font = Assets.Fredoka.semiBold(20)
            button.layer.cornerRadius = 26
        }
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews_e0Q04()
        setupButtonActions_e0Q04()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func backButtonTapped_e0Q04() {
        print("Back button tapped")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func downloadButtonTapped_e0Q04() {
        print("Download button tapped")
    }
    @objc func favoriteButtonTapped() {
        print("Favorite button tapped")
    }
    
    func setupViews_e0Q04() {
        view.backgroundColor = .customWhite
        
        backgroundImageView.image = Assets.Background.clouds
        
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(header)
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            if configs.currentDevice.isPad {
                make.leading.trailing.equalToSuperview().inset(85)
                make.height.equalTo(130)
            }else{
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(80)
            }
        }
        
        header.leftButton.setImage(Assets.Icon.back2, for: .normal)

        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            if configs.currentDevice.isPad {
                make.left.equalToSuperview().offset(85)
                make.right.equalToSuperview().offset(-85)
            }else{
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
        }
        mainView.addSubview(mainDescriptionView)
        mainDescriptionView.snp.makeConstraints { make in
            if configs.currentDevice.isPad {
                make.top.left.equalToSuperview().offset(24)
                make.right.equalToSuperview().offset(-24)
//                make.height.equalTo(420)
            }else{
//                make.height.equalTo(333)
                make.top.left.equalToSuperview().offset(12)
                make.right.equalToSuperview().offset(-12)
            }
//            if configs.currentDevice.isPad {
//                make.top.equalTo(previewImage.snp.bottom).offset(16)
//                make.right.bottom.equalToSuperview().offset(-24)
//                make.left.equalToSuperview().offset(24)
//            }else{
//                make.top.equalTo(previewImage.snp.bottom).offset(8)
//                make.right.bottom.equalToSuperview().offset(-12)
//                make.left.equalToSuperview().offset(12)
//            }
        }
        
        mainDescriptionView.addSubview(previewImage)
        previewImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            
            let device = Device.current
            if device.isOneOf([.iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadMini6,
                               .simulator(.iPadMini), .simulator(.iPadMini2), .simulator(.iPadMini3),
                               .simulator(.iPadMini4), .simulator(.iPadMini5), .simulator(.iPadMini6)]) {
                make.height.equalTo(350)
                make.top.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().offset(-20)
            } else if device.isPhone {
                make.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
                make.height.equalTo(313)
                make.width.equalTo(196)
            }else{
                make.height.equalTo(500)
                make.top.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().offset(-20)
            }
        }
        
        mainView.addSubview(cardDescriptionView)
        cardDescriptionView.snp.makeConstraints { make in
            if configs.currentDevice.isPad {
                make.top.equalTo(mainDescriptionView.snp.bottom).offset(16)
                make.right.bottom.equalToSuperview().offset(-24)
                make.left.equalToSuperview().offset(24)
            }else{
                make.top.equalTo(mainDescriptionView.snp.bottom).offset(8)
                make.right.bottom.equalToSuperview().offset(-12)
                make.left.equalToSuperview().offset(12)
            }
        }
        
        cardDescriptionView.addSubview(titleLabel)
        cardDescriptionView.addSubview(descriptionLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.right.bottom.equalToSuperview().offset(-12)
            make.left.equalToSuperview().offset(12)
        }
        
        view.addSubview(downloadButton)
        downloadButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-54)
            if configs.currentDevice.isPad {
                make.height.equalTo(72)
                make.right.equalToSuperview().offset(-85)
                make.left.equalToSuperview().offset(85)
            }else{
                make.height.equalTo(52)
                make.right.equalToSuperview().offset(-20)
                make.left.equalToSuperview().offset(20)
            }
        }
        view.addSubview(loadingView)
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingView.isHidden = true
        loadingView.backgroundColor = .clear
        loadingView.backgroundImageView.isHidden = true
//        loadingView.backgroundView.isHidden = true

        
        view.addSubview(completeView)
        completeView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            if configs.currentDevice.isPad {
                make.height.equalTo(140)
                make.width.equalTo(568)
            }else{
                make.height.equalTo(69)
                make.width.equalTo(284)
            }
        }
        view.addSubview(completeView)
        completeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        completeView.isHidden = true
    }
}

extension BaseSingleController {
    private func setupButtonActions_e0Q04() {
        header.leftButton.addTarget(self, action: #selector(backButtonTapped_e0Q04), for: .touchUpInside)
        header.rightButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped_e0Q04), for: .touchUpInside)
    }
}
