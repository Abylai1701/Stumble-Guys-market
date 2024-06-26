//
//  ListViewController.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 20.11.2023.
//

import UIKit
import SnapKit
import DeviceKit

class CharacterListViewController_e0Q04: UIViewController {
    
    var header = HeaderView_e0Q04()
    var backgroundImage = UIImageView()
    var emptyCharacterView = FavoriteDidNotFountView_e0Q04()
    var addCharacterButton = AddNewButton_e0Q04()
    var viewModel = SceneDelegate.shared.viewModel
    var loadingScreen = LoadingScreenHelper_e0Q04()
    var collectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout!
    var confirmationView = ConfirmationView_e0Q04(barViewHeight: Configs_e0Q04.shared.sizeOfConfView)
    var configs = Configs_e0Q04.shared
    var imagePlatform = UIImageView()
    var currentCharacter: Int = 0
    
    lazy var backButton: BackButtonView_e0Q04 = {
        let button = BackButtonView_e0Q04()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backCharacterTapped))
        button.addGestureRecognizer(tapGesture)
        return button
    }()
    
    lazy var nextButton: NextButtonView_e0Q04 = {
        let button = NextButtonView_e0Q04()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextCharacterTapped))
        button.addGestureRecognizer(tapGesture)
        return button
    }()
    
    lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(prewiewTapped))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    lazy var blurEffectMenu: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectMenu = UIVisualEffectView(effect: blurEffect)
        blurEffectMenu.frame = view.bounds
        blurEffectMenu.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectMenu
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("EDIT", for: .normal)
        button.setTitleColor(.myGreen, for: .normal)
        button.layer.shadowColor = UIColor.customBlack.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 2
        if Configs_e0Q04.shared.currentDevice.isPad {
            button.titleLabel?.font = Assets.Fredoka.semiBold(24)
            button.layer.cornerRadius = 40
        }else{
            button.titleLabel?.font = Assets.Fredoka.semiBold(16)
            button.layer.cornerRadius = 20
        }
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .redColor
        button.setTitle("DELETE", for: .normal)
        button.layer.shadowColor = UIColor.customBlack.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 2
        button.setTitleColor(.white, for: .normal)
        if Configs_e0Q04.shared.currentDevice.isPad {
            button.titleLabel?.font = Assets.Fredoka.semiBold(24)
            button.layer.cornerRadius = 40
        }else{
            button.titleLabel?.font = Assets.Fredoka.semiBold(16)
            button.layer.cornerRadius = 20
        }
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchCharactersFromCoreData_e0Q04()
        setupViews_e0Q04()
        setupButtonActions_e0Q04()
        header.titleLabel.text = "EDITOR".localizedUI

        if viewModel.showLoaderOneTime && !viewModel.dataLoaded {
            DispatchQueue.main.async {
                self.loadingScreen.show()
            }
            animateCountLabel_REFACTOR()
        }else if viewModel.showLoaderOneTime && viewModel.dataLoaded {
            DispatchQueue.main.async {
                self.loadingScreen.show()
            }
            animateCountLabel_REFACTOR()
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                self.loadingScreen.hide()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: Notification.Name("MyNotification"), object: nil)
        showEmptyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        viewModel.fetchCharactersFromCoreData_e0Q04()
        viewModel.sortCharacterList_e0Q04()
        viewModel.clearCharacterData_e0Q04()
        showEmptyView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    deinit {
        viewModel.showLoaderOneTime = false
        NotificationCenter.default.removeObserver(self, name: Notification.Name("MyNotification"), object: nil)
    }
    private func showEmptyView() {
        if viewModel.characterList == [] {
            emptyCharacterView.isHidden = false
            imagePlatform.isHidden = true
            deleteButton.isHidden = true
            editButton.isHidden = true
            backButton.isHidden = true
            nextButton.isHidden = true
            characterImageView.isHidden = true
        } else {
            emptyCharacterView.isHidden = true
            imagePlatform.isHidden = false
            deleteButton.isHidden = false
            editButton.isHidden = false
            backButton.isHidden = false
            nextButton.isHidden = false
            characterImageView.isHidden = false
            returnCharacter()
        }
    }
    
    private func getImageURL(for imageName: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsDirectory.appendingPathComponent(imageName)
    }
    private func animateCountLabel_REFACTOR() {
        let countStart: Int = 1
        let countEnd: Int = 99
        var currentCount: Int = countStart

        // Создание таймера, который обновляет UILabel на главном потоке
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            self.loadingScreen.loadingView?.loadingLabel.text = String(format: "Loading... %d%%", currentCount)

            if currentCount < countEnd {
                currentCount += 1
            } else {
                timer.invalidate()  // Остановка таймера, когда достигнут конечный счет
            }
        }
    }

    @objc private func addCharacterButtonTapped_e0Q04() {
        print("Add New Character Button Tapped!")
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        viewModel.setDefaultItems_e0Q04()
        viewModel.saveInitialItems_e0Q04()
        
        let editorVC: UIViewController
        if configs.currentDevice.isPad {
            editorVC = EditorViewController_e0Q04()
            (editorVC as? EditorViewController_e0Q04)?.viewModel = viewModel
        } else {
            editorVC = EditorViewController_e0Q04()
            (editorVC as? EditorViewController_e0Q04)?.viewModel = viewModel
        }
        
        //        let editorVC = EditorViewController()
        //        editorVC.viewModel = self.viewModel
        navigationController?.pushViewController(editorVC, animated: true)
    }
    @objc func handleNotification(){
        self.loadingScreen.hide()
    }
    
    
    @objc private func backCharacterTapped(_ sender: UITapGestureRecognizer) {
        guard currentCharacter != 0 else { return }
        guard !(viewModel.characterList.isEmpty) else { return }
        
        currentCharacter -= 1
        let character = viewModel.characterList[currentCharacter]
        
        if let photoName = character.photo, let imageURL = getImageURL(for: photoName) {
            characterImageView.image = UIImage(contentsOfFile: imageURL.path)
        }
        
        if currentCharacter == 0 {
            backButton.mainView.backgroundColor = .lightGreen
            backButton.titleLabel.textColor = .grayColor2
            backButton.mainView.layer.borderColor = UIColor.grayColor2.cgColor
            backButton.nextImage.image = Assets.Icon.iconBack4
        }
        
        if currentCharacter < viewModel.characterList.count - 1 {
            nextButton.mainView.backgroundColor = .myGreen
            nextButton.titleLabel.textColor = .white
            nextButton.mainView.layer.borderColor = UIColor.white.cgColor
            nextButton.nextImage.image = Assets.Icon.iconNext
        }
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    private func returnCharacter() {
        currentCharacter = 0
        let character = viewModel.characterList[currentCharacter]
        
        if let photoName = character.photo, let imageURL = getImageURL(for: photoName) {
            characterImageView.image = UIImage(contentsOfFile: imageURL.path)
        }
        if viewModel.characterList.count == 1 {
            backButton.mainView.backgroundColor = .lightGreen
            backButton.titleLabel.textColor = .grayColor2
            backButton.mainView.layer.borderColor = UIColor.grayColor2.cgColor
            backButton.nextImage.image = Assets.Icon.iconBack4
            
            nextButton.mainView.backgroundColor = .lightGreen
            nextButton.titleLabel.textColor = .grayColor2
            nextButton.mainView.layer.borderColor = UIColor.grayColor2.cgColor
            nextButton.nextImage.image = Assets.Icon.iconNext2
        }else{
            backButton.mainView.backgroundColor = .lightGreen
            backButton.titleLabel.textColor = .grayColor2
            backButton.mainView.layer.borderColor = UIColor.grayColor2.cgColor
            backButton.nextImage.image = Assets.Icon.iconBack4
            
            nextButton.mainView.backgroundColor = .myGreen
            nextButton.titleLabel.textColor = .white
            nextButton.mainView.layer.borderColor = UIColor.white.cgColor
            nextButton.nextImage.image = Assets.Icon.iconNext
        }
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    @objc private func nextCharacterTapped(_ sender: UITapGestureRecognizer) {
        guard !(currentCharacter == viewModel.characterList.count - 1) else { return }
        guard !(viewModel.characterList.isEmpty) else { return }
        
        currentCharacter += 1
        let character = viewModel.characterList[currentCharacter]
        
        if let photoName = character.photo, let imageURL = getImageURL(for: photoName) {
            characterImageView.image = UIImage(contentsOfFile: imageURL.path)
        }
        
        if currentCharacter == viewModel.characterList.count - 1{
            nextButton.mainView.backgroundColor = .lightGreen
            nextButton.titleLabel.textColor = .grayColor2
            nextButton.mainView.layer.borderColor = UIColor.grayColor2.cgColor
            nextButton.nextImage.image = Assets.Icon.iconNext2
        }
        
        if currentCharacter > 0{
            backButton.mainView.backgroundColor = .myGreen
            backButton.titleLabel.textColor = .white
            backButton.mainView.layer.borderColor = UIColor.white.cgColor
            backButton.nextImage.image = Assets.Icon.iconBack3
        }
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    @objc private func prewiewTapped(_ sender: UITapGestureRecognizer) {
        guard !(viewModel.characterList.isEmpty) else { return }
        
        let character = viewModel.characterList[currentCharacter]
        
        viewModel.characterUUID = character.uuid
        viewModel.characterPhoto = character.photo ?? ""
        
        if let itemsString = character.items,
           let data = itemsString.data(using: .utf8),
           let itemsDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
            viewModel.predefinedItemIds = itemsDict
            viewModel.saveInitialItems_e0Q04()
        } else {
            viewModel.predefinedItemIds = [:]
        }
        if let genderString = character.gender?.lowercased() {
            viewModel.characterType = CharacterType(rawValue: genderString) ?? .boy
            viewModel.saveInitialGender_e0Q04()
        } else {
            viewModel.characterType = .boy
        }
        
        let viewController: UIViewController
        if configs.currentDevice.isPad {
            viewController = PreviewViewController_e0Q04()
            (viewController as? PreviewViewController_e0Q04)?.viewModel = viewModel
        } else {
            viewController = PreviewViewController_e0Q04()
            (viewController as? PreviewViewController_e0Q04)?.viewModel = viewModel
        }
        
        //            let previewVC = PreviewViewController()
        //            previewVC.viewModel = self.viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    @objc private func deleteButtonTapped_e0Q04() {
        let characterToDelete = viewModel.characterList[currentCharacter]
        CoreDataManager_e0Q04.shared.deleteCharacter(with: characterToDelete.uuid!)
        viewModel.characterList.remove(at: currentCharacter)
        showEmptyView()
        if currentCharacter == 0 {
            showEmptyView()
        } else if currentCharacter > 0 {
            currentCharacter -= 1
            let character = viewModel.characterList[currentCharacter]
            
            if let photoName = character.photo, let imageURL = getImageURL(for: photoName) {
                characterImageView.image = UIImage(contentsOfFile: imageURL.path)
            }
            
            if currentCharacter == 0 {
                backButton.mainView.backgroundColor = .lightGreen
                backButton.titleLabel.textColor = .grayColor2
                backButton.mainView.layer.borderColor = UIColor.grayColor2.cgColor
                backButton.nextImage.image = Assets.Icon.iconBack4
                
                nextButton.mainView.backgroundColor = .lightGreen
                nextButton.titleLabel.textColor = .grayColor2
                nextButton.mainView.layer.borderColor = UIColor.grayColor2.cgColor
                nextButton.nextImage.image = Assets.Icon.iconNext2
            }
            
            if currentCharacter < viewModel.characterList.count - 1 {
                nextButton.mainView.backgroundColor = .myGreen
                nextButton.titleLabel.textColor = .white
                nextButton.mainView.layer.borderColor = UIColor.white.cgColor
                nextButton.nextImage.image = Assets.Icon.iconNext
            }
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
        confirmationView.isHidden = true
        
        view.layoutIfNeeded()
    }
    
    @objc private func cancelButtonTapped() {
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        confirmationView.isHidden = true
        viewModel.selectedCharacterIndexPath = nil
    }
    
    open func setupViews_e0Q04() {
        view.backgroundColor = .customWhite
        backgroundImage.image = Assets.Background.gradient
        header.rightButton.setImage(Assets.Icon.iconAddCharacter, for: .normal)
        
        view.addSubview(backgroundImage)
        
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(imagePlatform)
        imagePlatform.image = Assets.Image.platform
        imagePlatform.snp.makeConstraints { make in
            
            let device = Device.current
            
            if device.isPhone {
                // Settings for other iPhone models
                make.centerY.equalToSuperview().offset(UIScreen.main.bounds.height * 0.235)
                make.centerX.equalToSuperview()
                make.width.equalTo(210)
                make.height.equalTo(50)
            }else if device.isPad {
                make.centerY.equalToSuperview().offset(UIScreen.main.bounds.height * 0.2)
                make.centerX.equalToSuperview()
                make.width.equalTo(420)
                make.height.equalTo(100)
            }
        }
        
        view.addSubview(characterImageView)
        if !viewModel.characterList.isEmpty{
            let character = viewModel.characterList[currentCharacter]
            
            if let photoName = character.photo, let imageURL = getImageURL(for: photoName) {
                characterImageView.image = UIImage(contentsOfFile: imageURL.path)
            }
        }
        
        characterImageView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(195)
//            make.left.equalToSuperview().offset(18)
//            make.right.equalToSuperview().offset(-18)
//            make.bottom.equalToSuperview().offset(-160)
            make.centerY.equalToSuperview().offset(UIScreen.main.bounds.height * 0.03)
            make.centerX.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(1.08)

        }
        
        view.addSubview(backButton)
        view.addSubview(nextButton)
        view.addSubview(header)
        view.addSubview(editButton)
        view.addSubview(deleteButton)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(imagePlatform.snp.bottom).offset(20)
            if configs.currentDevice.isPad {
                make.left.equalToSuperview().offset(85)
                make.height.equalTo(70)
                make.width.equalTo(140)
            }else{
                make.left.equalToSuperview().offset(20)
                make.height.equalTo(40)
                make.width.equalTo(83)
            }
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(imagePlatform.snp.bottom).offset(20)
            if configs.currentDevice.isPad {
                make.right.equalToSuperview().offset(-85)
                make.height.equalTo(70)
                make.width.equalTo(140)
            }else{
                make.right.equalToSuperview().offset(-20)
                make.height.equalTo(40)
                make.width.equalTo(83)
            }
        }
        
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
        
        editButton.snp.makeConstraints { make in
            if configs.currentDevice.isPad {
                make.left.equalToSuperview().offset(85)
                make.top.equalTo(backButton.snp.bottom).offset(30)
                make.height.equalTo(80)
                make.width.equalTo(240)
            }else{
                make.left.equalToSuperview().offset(20)
                make.top.equalTo(backButton.snp.bottom).offset(60)
                make.height.equalTo(41)
                make.width.equalTo(165)
            }
        }
        
        deleteButton.snp.makeConstraints { make in
            if configs.currentDevice.isPad {
                make.right.equalToSuperview().offset(-85)
                make.top.equalTo(backButton.snp.bottom).offset(30)
                make.height.equalTo(80)
                make.width.equalTo(240)
            }else{
                make.right.equalToSuperview().offset(-20)
                make.top.equalTo(backButton.snp.bottom).offset(60)
                make.height.equalTo(41)
                make.width.equalTo(165)
            }
        }
        
        view.addSubview(emptyCharacterView)
        emptyCharacterView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            if configs.currentDevice.isPad {
                make.width.equalTo(500)
            }else{
                make.width.equalTo(284)
            }
        }
        
        emptyCharacterView.titleLabel.numberOfLines = 2
        emptyCharacterView.titleLabel.text = "No characters were identified in relation to your search"
        emptyCharacterView.isHidden = true
        
        view.addSubview(confirmationView)
        confirmationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        confirmationView.isHidden = true
        
    }
}

extension CharacterListViewController_e0Q04: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.characterList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.addNew, for: indexPath) as? AddNewCell_e0Q04 else {
                fatalError("Unable to dequeue AddNewCell")
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.character, for: indexPath) as? CharacterCell_e0Q04 else {
                fatalError("Unable to dequeue CharacterCell")
            }
            
            let adjustedIndex = indexPath.row - 1
            let character = viewModel.characterList[adjustedIndex]
            
            if let photoName = character.photo, let imageURL = getImageURL(for: photoName) {
                cell.characterImageView.image = UIImage(contentsOfFile: imageURL.path)
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("Add New Cell tapped")
            guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
            viewModel.setDefaultItems_e0Q04()
            viewModel.saveInitialItems_e0Q04()
            
            let editorVC: UIViewController
            editorVC = EditorViewController_e0Q04()
            (editorVC as? EditorViewController_e0Q04)?.viewModel = viewModel
            
            //            let editorVC = EditorViewController()
            //            editorVC.viewModel = self.viewModel
            navigationController?.pushViewController(editorVC, animated: true)
        } else {
            let adjustedIndex = indexPath.row - 1
            guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
            let character = viewModel.characterList[adjustedIndex]
            print("Character Cell tapped for character: \(character)")
            
            viewModel.characterUUID = character.uuid
            viewModel.characterPhoto = character.photo ?? ""
            
            if let itemsString = character.items,
               let data = itemsString.data(using: .utf8),
               let itemsDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                viewModel.predefinedItemIds = itemsDict
                viewModel.saveInitialItems_e0Q04()
            } else {
                viewModel.predefinedItemIds = [:]
            }
            
            print("Raw gender string from Core Data: \(character.gender as Any)")
            if let genderString = character.gender?.lowercased() {
                viewModel.characterType = CharacterType(rawValue: genderString) ?? .boy
                print("Processed gender string: \(genderString)")
                print("Updated character type: \(viewModel.characterType)")
                viewModel.saveInitialGender_e0Q04()
            } else {
                viewModel.characterType = .boy
                print("Defaulting to boy due to nil gender")
            }
            
            let viewController: UIViewController
            
            viewController = PreviewViewController_e0Q04()
            (viewController as? PreviewViewController_e0Q04)?.viewModel = viewModel
            
            
            //            let previewVC = PreviewViewController()
            //            previewVC.viewModel = self.viewModel
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension CharacterListViewController_e0Q04 {
    @objc func didTapDeleteButton() {
        confirmationView.isHidden = false
        confirmationView.titleLabel.text = "Caution"
        confirmationView.descriptionLabel.text = "Deleting means saying goodbye to your character permanently."
    }
    
    @objc func didTapEditButton() {
        let characterToEdit = viewModel.characterList[currentCharacter]
        
        viewModel.characterUUID = characterToEdit.uuid
        viewModel.characterPhoto = characterToEdit.photo ?? ""
        
        if let genderString = characterToEdit.gender?.lowercased() {
            viewModel.characterType = CharacterType(rawValue: genderString) ?? .boy
            print("Gender from Core Data")
            print(CharacterType(rawValue: genderString) as Any)
            viewModel.saveInitialGender_e0Q04()
        } else {
            viewModel.characterType = .boy
        }
        
        if let itemsString = characterToEdit.items,
           let data = itemsString.data(using: .utf8),
           let itemsDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
            viewModel.predefinedItemIds = itemsDict
        } else {
            viewModel.predefinedItemIds = [:]
        }
        
        viewModel.saveInitialItems_e0Q04()
        
        let editorVC: UIViewController
        
        editorVC = EditorViewController_e0Q04()
        (editorVC as? EditorViewController_e0Q04)?.viewModel = viewModel
        
        
        //        let editorVC = EditorViewController()
        //        editorVC.viewModel = viewModel
        navigationController?.pushViewController(editorVC, animated: true)
    }
}

//MARK: Back to menu logic
extension CharacterListViewController_e0Q04 {
    private func setupButtonActions_e0Q04() {
        header.leftButton.addTarget(self, action: #selector(backButtonTapped_e0Q04), for: .touchUpInside)
        header.rightButton.addTarget(self, action: #selector(addCharacterButtonTapped_e0Q04), for: .touchUpInside)
        confirmationView.redButton.addTarget(self, action: #selector(deleteButtonTapped_e0Q04), for: .touchUpInside)
        confirmationView.blueButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
    }
    private func createButton(title: String, color: UIColor, backgroundColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.shadowColor = UIColor.customBlack.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 2
        button.titleLabel?.font = configs.currentDevice.isPad ? Assets.Fredoka.semiBold(24) : Assets.Fredoka.semiBold(16)
        button.layer.cornerRadius = configs.currentDevice.isPad ? 40 : 22
        return button
    }
}

//MARK: Back to menu logic
extension CharacterListViewController_e0Q04 {
    @objc private func backButtonTapped_e0Q04() {
        let menuVC = HomeViewController_e0Q04(selectedMenu: 6)
        menuVC.popAction = {
            let vc = self
            vc.removeFromParent()
            vc.view.removeFromSuperview()
        }
        menuVC.tapAction = {
            self.blurEffectMenu.removeFromSuperview()
        }
        presentViewControllerFromBottom(menuVC)
    }
    func presentViewControllerFromBottom(_ viewController: UIViewController) {
        // Рассчитываем начальное положение контроллера
        let homeHeight : CGFloat = Configs_e0Q04.shared.currentDevice.isPad ? 1000 : 680
        let initialY = UIScreen.main.bounds.height - homeHeight
        
        // Устанавливаем начальное положение контроллера
        viewController.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: viewController.view.frame.height)
        
        self.view.addSubview(blurEffectMenu)
        
        // Добавляем контроллер на текущий контроллер
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        
        // Анимация появления контроллера снизу вверх
        UIView.animate(withDuration: 0.2) {
            viewController.view.frame = CGRect(x: 0, y: initialY, width: UIScreen.main.bounds.width, height: viewController.view.frame.height)
        }
    }
}
