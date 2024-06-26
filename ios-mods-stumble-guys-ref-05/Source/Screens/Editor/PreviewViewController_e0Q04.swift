import UIKit
import SnapKit

class PreviewViewController_e0Q04: UIViewController {
    
    var backgroundImage = UIImageView()
    var backButton = RoundedButton_e0Q04()
    var deleteButton = SaveButton_e0Q04()
    var editButton = SaveButton_e0Q04()
    var downloadButton = RoundedButton_e0Q04()
    var headerView = UIView()
    var confirmationView = ConfirmationView_e0Q04(barViewHeight: Configs_e0Q04.shared.sizeOfConfView)
    var platformImageView = UIImageView()
    var characterImage = UIImageView()
    var viewModel: EditorViewModel_e0Q04!
    var configs = Configs_e0Q04.shared
    var loadingView = LoadingView_e0Q04()
    var completeView = CompleteView()

    lazy var whiteDownloadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("DOWNLOAD", for: .normal)
        button.setTitleColor(.myGreen, for: .normal)
        button.layer.shadowColor = UIColor.customBlack.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 2
        if Configs_e0Q04.shared.currentDevice.isPad {
            button.layer.cornerRadius = 48
            button.titleLabel?.font = Assets.Fredoka.semiBold(40)
        }else{
            button.layer.cornerRadius = 26
            button.titleLabel?.font = Assets.Fredoka.semiBold(20)
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
        updateCharacterPhoto_e0Q04()
        viewModel.resetGender_e0Q04()
        viewModel.resetItems_e0Q04()
        print("Default Items")
        print(viewModel.defaultItems)
        print("PredefinedI Items")
        print(viewModel.predefinedItemIds)
        print("Initial Items")
        print(viewModel.initialItems)
        print("Character Type")
        print(viewModel.characterType)
        print("Initial Character Type")
        print(viewModel.initialCharacterGender as Any)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func updateCharacterPhoto_e0Q04() {
        if let uuid = viewModel.characterUUID, let character = CoreDataManager_e0Q04.shared.fetchCharacter_e0Q04(with: uuid) {
            let imagePath = getDocumentsDirectory().appendingPathComponent(character.photo ?? "").path
            if FileManager.default.fileExists(atPath: imagePath) {
                characterImage.image = UIImage(contentsOfFile: imagePath)
            } else {
                print("Image file does not exist at path: \(imagePath)")
            }
        } else {
            print("No UUID found for character or character not found in Core Data.")
        }
    }


    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func deleteCharacterPopUp_e0Q04() {
        confirmationView.isHidden = false
        confirmationView.titleLabel.text = "Caution"
        confirmationView.descriptionLabel.text = "Deleting means saying goodbye to your character permanently."
    }
    
    @objc func noButtonTapped_e0Q04() {
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        confirmationView.isHidden = true
    }
    
    @objc func yesButtonTapped_e0Q04() {
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        let characterId = viewModel.characterUUID
        CoreDataManager_e0Q04.shared.deleteCharacter(with: characterId!)
        viewModel.characterList.removeAll { $0.uuid == characterId }
        viewModel.clearCharacterData_e0Q04()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func backButtonTapped_e0Q04() {
        print("Back Button Tapped")
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }

        if let navigationController = navigationController {
            // Пытаемся найти CharacterListViewController в стеке
            if let characterListVC = navigationController.viewControllers.first(where: { $0 is CharacterListViewController_e0Q04 }) {
                navigationController.popToViewController(characterListVC, animated: true)
            } else {
                // Создаем новый экземпляр и делаем его корнем стека
                let newCharacterListVC = CharacterListViewController_e0Q04()
                navigationController.setViewControllers([newCharacterListVC], animated: true)
            }
        }
    }

    
    @objc private func deleteButtonTapped_e0Q04() {
        print("Delete button tapped")
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        deleteCharacterPopUp_e0Q04()
    }
    
    @objc private func editButtonTapped_e0Q04() {
        print("Edit button tapped")
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        viewModel.resetGender_e0Q04()
        
        let editorVC: UIViewController
        
            editorVC = EditorViewController_e0Q04()
            (editorVC as? EditorViewController_e0Q04)?.viewModel = viewModel
        
        
//        let editorVC = EditorViewController()
//        editorVC.viewModel = self.viewModel
        navigationController?.pushViewController(editorVC, animated: true)
    }
    
    @objc private func downloadButtonTapped_e0Q04() {
        print("Download button tapped")
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        
        PhotoAccessAlertHelper_e0Q04.shared.checkPhotoLibraryAuthorization { [weak self] authorized in
            guard let self = self else { return }

            if authorized, let image = self.characterImage.image {
                self.loadingView.isHidden = false

                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            } else {
                if !authorized {
                    PhotoAccessAlertHelper_e0Q04.shared.presentPhotoAccessDeniedAlert(from: self)
                } else {
                    print("No image available to save.")
                }
            }
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        self.loadingView.isHidden = true  // Показываем индикатор загрузки

        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
        } else {
            print("Image saved successfully.")
            self.completeView.isHidden = false  // Показываем "успех" view
            
            // Скрываем "успех" view через 2 секунды
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.completeView.isHidden = true
            }
            
        }
    }
    
    func setupViews_e0Q04() {
        backgroundImage.image = Assets.Background.gradient
        
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            if configs.currentDevice.isPad {
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.leading.trailing.equalToSuperview().inset(85)
                make.height.equalTo(130)
            }else{
                make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                make.height.equalTo(80)
            }
        }

        backButton.setImage(Assets.Icon.back2, for: .normal)
        headerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            if configs.currentDevice.isPad {
                make.size.equalTo(80)
                make.leading.equalToSuperview().inset(20)
            }else{
                make.leading.equalToSuperview().inset(20)
                make.size.equalTo(40)
            }
        }
        editButton.setTitle("EDIT".localizedUI, for: .normal)
        headerView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            if configs.currentDevice.isPad {
                make.width.equalTo(160)
                make.height.equalTo(80)
            }else{
                make.width.equalTo(80)
                make.height.equalTo(40)
            }
        }
        
        deleteButton.setTitle("DELETE".localizedUI, for: .normal)
        deleteButton.backgroundColor = .redColor
        headerView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(editButton.snp.leading).inset(-20)
            if configs.currentDevice.isPad {
                make.width.equalTo(160)
                make.height.equalTo(80)
            }else{
                make.width.equalTo(80)
                make.height.equalTo(40)
            }
        }
        
        view.addSubview(whiteDownloadButton)
        whiteDownloadButton.snp.makeConstraints { make in
            if configs.currentDevice.isPad {
                make.right.equalToSuperview().offset(-85)
                make.left.equalToSuperview().offset(85)
                make.height.equalTo(104)
            }else{
                make.right.equalToSuperview().offset(-20)
                make.left.equalToSuperview().offset(20)
                make.height.equalTo(52)
            }
            make.bottom.equalToSuperview().offset(-54)
        }
        
        platformImageView.image = Assets.Image.platform
        platformImageView.contentMode = .scaleAspectFit
        view.addSubview(platformImageView)
        platformImageView.snp.makeConstraints { make in
            
            if configs.currentDevice.isPad {
                make.centerY.equalToSuperview().offset(UIScreen.main.bounds.height * 0.24)
                make.centerX.equalToSuperview()
                make.width.equalTo(488)
                make.height.equalTo(112)
            }else{
                make.centerY.equalToSuperview().offset(UIScreen.main.bounds.height * 0.26)
                make.centerX.equalToSuperview()
                make.width.equalTo(244)
                make.height.equalTo(56)
            }
        }
        
        characterImage.contentMode = .scaleAspectFit
        view.addSubview(characterImage)
        characterImage.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(142)
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-143)
            make.centerY.equalToSuperview().offset(UIScreen.main.bounds.height * 0.03)
            make.centerX.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(1.25)
        }
        
        view.addSubview(confirmationView)
        confirmationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        confirmationView.isHidden = true
        
        view.addSubview(loadingView)
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingView.isHidden = true
        loadingView.backgroundColor = .clear
        loadingView.backgroundImageView.isHidden = true
        
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

extension PreviewViewController_e0Q04 {
    private func setupButtonActions_e0Q04() {
        backButton.addTarget(self, action: #selector(backButtonTapped_e0Q04), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped_e0Q04), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonTapped_e0Q04), for: .touchUpInside)
        whiteDownloadButton.addTarget(self, action: #selector(downloadButtonTapped_e0Q04), for: .touchUpInside)
        confirmationView.blueButton.addTarget(self, action: #selector(noButtonTapped_e0Q04), for: .touchUpInside)
        confirmationView.redButton.addTarget(self, action: #selector(yesButtonTapped_e0Q04), for: .touchUpInside)
    }
}
