//
//  ViewController.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 20.11.2023.
//

import UIKit
import SnapKit
import DataCache

enum ScreenType {
    case mods, hacks, tips, characters, locations, editor
    
    var title: String {
        switch self {
        case .mods:
            return "MODS".localizedUI
        case .hacks:
            return "HACKS".localizedUI
        case .tips:
            return "SKINS".localizedUI
        case .characters:
            return "CHARACTERS".localizedUI
        case .locations:
            return "LOCATIONS".localizedUI
        case .editor:
            return "EDITOR".localizedUI
        }
    }
}

class HomeViewController_e0Q04: UIViewController {
    
    var backgroundImageView = UIImageView()
    var header = HeaderView_e0Q04()
    var menuStackView = UIStackView()
    var modsButton = MenuButton_e0Q04()
    var hacksButton = MenuButton_e0Q04()
    var editorButton = MenuButton_e0Q04()
    var tipsButton = MenuButton_e0Q04()
    var charactersButton = MenuButton_e0Q04()
    var locationsButton = MenuButton_e0Q04()
    var configs = Configs_e0Q04.shared
    let cacheManager = DataCacheManager_e0Q04.shared
    var blurEffectView: UIVisualEffectView?
    
    var popAction: (()->())?
    var tapAction: (()->())?
    
    var selectedMenu: Int
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        if Configs_e0Q04.shared.currentDevice.isPad {
            label.font = Assets.Fredoka.semiBold(48)
        }else{
            label.font = Assets.Fredoka.semiBold(32)
        }
        label.textColor = .white
        label.text = "MENU"
        return label
    }()
    
    lazy var discardButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Assets.Icon.iconDiscard3
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hiddenHomeVC))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    init(selectedMenu: Int) {
        self.selectedMenu = selectedMenu
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews_e0Q04()
        setupButtonActions_e0Q04()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ThirdPartyServicesManager.shared.makeATT_REFACTOR()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func blurEffect_e0Q04() {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(blurEffectView!)
    }
  
    open func navigateToDestination(for screenType: ScreenType) {
        hiddenHomeVC2()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            var viewController: UIViewController!
            switch screenType {
            case .mods:
                viewController = ModsViewController_e0Q04()
            case .hacks:
                viewController = HacksViewController_e0Q04()
            case .editor:
                viewController = CharacterListViewController_e0Q04()
            case .tips:
                viewController = TipsViewController_e0Q04()
            case .characters:
                viewController = CharactersViewController_eQ04()
            case .locations:
                viewController = LocationsViewController_e0Q04()
            }
            
            
            viewController.title = screenType.title.capitalized
            self.navigationController?.pushViewController(viewController, animated: false)
            
            self.popAction?()
            
            // Удаляем homeVC из родительского контроллера
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    
    
    @objc private func modsButtonTapped() {
        print("Mods button tapped")
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        navigateToDestination(for: .mods)
    }
    
    @objc private func hacksButtonTapped() {
        print("Hacks button tapped")
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        navigateToDestination(for: .hacks)
    }
    
    @objc private func editorButtonTapped() {
        print("Editor button tapped")
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        navigateToDestination(for: .editor)
    }
    
    @objc private func tipsButtonTapped() {
        print("Tips & Tricks button tapped")
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        navigateToDestination(for: .tips)
    }
    
    @objc private func charactersButtonTapped() {
        print("Characters button tapped")
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        navigateToDestination(for: .characters)
    }
    
    @objc private func locationsButtonTapped() {
        print("Location button tapped")
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        navigateToDestination(for: .locations)
    }
    
    @objc func hiddenHomeVC() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: self.view.frame.height)
        }) { _ in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
            print("HomeController удалился(")
        }
        
        tapAction?()
    }
    
    @objc func hiddenHomeVC2() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: self.view.frame.height)
        })
        print("HomeController удалился(")
        
        tapAction?()
    }
    
    func setupViews_e0Q04() {
        view.backgroundColor = .myGreen
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.top.equalToSuperview().offset(30)
            }else{
                make.top.equalToSuperview().offset(22.5)
            }
            make.centerX.equalToSuperview()
        }
        view.addSubview(discardButtonImage)
        discardButtonImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.right.equalToSuperview().offset(-85)
                make.height.equalTo(96)
                make.width.equalTo(88)
            }else{
                make.height.equalTo(48)
                make.width.equalTo(44)
                make.right.equalToSuperview().offset(-26)
            }
        }
        
        menuStackView.axis = .vertical
        menuStackView.spacing = 32
        
        modsButton = MenuButton_e0Q04()
        if selectedMenu == 1 {
            modsButton.backgroundColor = .white
            modsButton.isUserInteractionEnabled = false
        }
        modsButton.lockImage.isHidden = true
        
        modsButton.setTitle("MODS".localizedUI, for: .normal)
        menuStackView.addArrangedSubview(modsButton)
        
        hacksButton = MenuButton_e0Q04()
        if selectedMenu == 2 {
            hacksButton.backgroundColor = .white
            hacksButton.isUserInteractionEnabled = false
        }
        hacksButton.lockImage.isHidden = true
        
        hacksButton.setTitle("HACKS".localizedUI, for: .normal)
        menuStackView.addArrangedSubview(hacksButton)
        
        tipsButton = MenuButton_e0Q04()
        if selectedMenu == 3 {
            tipsButton.backgroundColor = .white
            tipsButton.isUserInteractionEnabled = false
        }
        tipsButton.lockImage.isHidden = true
        
        tipsButton.setTitle("SKINS".localizedUI, for: .normal)
        menuStackView.addArrangedSubview(tipsButton)
        
        charactersButton = MenuButton_e0Q04()
        if selectedMenu == 4 {
            charactersButton.backgroundColor = .white
            charactersButton.isUserInteractionEnabled = false
        }
        charactersButton.lockImage.isHidden = true
        
        charactersButton.setTitle("CHARACTERS".localizedUI, for: .normal)
        menuStackView.addArrangedSubview(charactersButton)
        
        locationsButton = MenuButton_e0Q04()
        if selectedMenu == 5 {
            locationsButton.backgroundColor = .white
            locationsButton.isUserInteractionEnabled = false
        }
        locationsButton.lockImage.isHidden = true
        locationsButton.setTitle("LOCATIONS".localizedUI, for: .normal)
        
        menuStackView.addArrangedSubview(locationsButton)
        view.addSubview(menuStackView)
        
        editorButton = MenuButton_e0Q04()
        if selectedMenu == 6 {
            editorButton.backgroundColor = .white
            editorButton.isUserInteractionEnabled = false
        }
        editorButton.lockImage.isHidden = true
        editorButton.setTitle("EDITOR".localizedUI, for: .normal)
        menuStackView.addArrangedSubview(editorButton)
        
        menuStackView.snp.makeConstraints { make in
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.leading.equalToSuperview().inset(85)
                make.trailing.equalToSuperview().inset(85)
                make.top.equalTo(titleLabel.snp.bottom).offset(50)
            }else{
                make.leading.equalToSuperview().inset(30)
                make.trailing.equalToSuperview().inset(30)
                make.top.equalTo(titleLabel.snp.bottom).offset(30)
            }
        }
        
        let arrayOfMenu = [modsButton,hacksButton,editorButton,tipsButton,charactersButton,locationsButton]
        let heightOfMenu = Configs_e0Q04.shared.currentDevice.isPad ? 100 : 61
        for i in arrayOfMenu {
            i.snp.makeConstraints { make in
                make.height.equalTo(heightOfMenu)
            }
        }
    }
}

extension HomeViewController_e0Q04 {
    private func setupButtonActions_e0Q04() {
        modsButton.addTarget(self, action: #selector(modsButtonTapped), for: .touchUpInside)
        hacksButton.addTarget(self, action: #selector(hacksButtonTapped), for: .touchUpInside)
        editorButton.addTarget(self, action: #selector(editorButtonTapped), for: .touchUpInside)
        tipsButton.addTarget(self, action: #selector(tipsButtonTapped), for: .touchUpInside)
        charactersButton.addTarget(self, action: #selector(charactersButtonTapped), for: .touchUpInside)
        locationsButton.addTarget(self, action: #selector(locationsButtonTapped), for: .touchUpInside)
    }
}

