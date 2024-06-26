//
//  Created by Alisher on 20.11.2023.
//

import UIKit
import SnapKit
import DataCache
import DeviceKit

class EditorViewController_e0Q04: UIViewController {
    
    var backgroundImage = UIImageView()
    var backButton = RoundedButton_e0Q04()
    var discardChangesButton = RoundedButton_e0Q04()
    var saveButton = SaveButton_e0Q04()
    var headerView = UIView()
    var imagePlatform = UIImageView()
    var confirmationView = ConfirmationView_e0Q04(barViewHeight: Configs_e0Q04.shared.sizeOfConfView2)
    var confirmationView2 = ConfirmationView_e0Q04(barViewHeight: Configs_e0Q04.shared.sizeOfConfView)
    var characterEdited = false
    var wardrobeView = WardrobeView_e0Q04()
    var imageViewContainer = UIView()
    var imageViews: [UIImageView] = []
    var selectedItemPerCategory = [String: IndexPath]()
    var selectedButton: UIButton?
    var returnActionInitiated = false
    var viewModel: EditorViewModel_e0Q04!
    let configs = Configs_e0Q04.shared
        
    var arrayOfElements: [UIButton] = []
    var currentCharacter: Int = 0
    
    var segmentControlContainer: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    var customSegmentControl: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews_e0Q04()
        setupButtonActions_e0Q04()
        setupCollectionViews_e0Q04()
        
        if !viewModel.boyCategories.isEmpty || !viewModel.girlCategories.isEmpty {
            let editorData = EditorModel(editor: Editor(boy: viewModel.boyCategories, girl: viewModel.girlCategories))
            createImageViews(from: editorData)
        }
        
        loadImages()
        updateCustomSegmentControl()
        
        if let genderButton = customSegmentControl.arrangedSubviews.first as? UIButton {
            genderSelectionTapped(genderButton)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        updateButtonAppearance_e0Q04()
        
        viewModel.selectedCategory = "Gender"
        viewModel.resetHistory()
        
        if !NetworkStatusMonitor_e0Q04.shared.isNetworkAvailable {
            print("No internet connection, aborting download task.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ConnectionAlertHelperWithDoubleReturn_e0Q04.shared.show()
            }
            return
        }
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    
    func cancelEditsPopUp() {
        DispatchQueue.main.async {
            self.confirmationView.isHidden = false
            self.confirmationView.titleLabel.text = "Caution: Unsaved Updates"
            self.confirmationView.titleLabel.numberOfLines = 2
            self.confirmationView.descriptionLabel.text = "Leaving now will cancel all your edits."
            self.confirmationView.blueButton.setTitle("CANCEL", for: .normal)
            self.confirmationView.redButton.setTitle("TAKE OFF", for: .normal)
        }
    }
    
    func eraseActionsPopUp() {
        DispatchQueue.main.async {
            self.confirmationView2.isHidden = false
            self.confirmationView2.titleLabel.text = "Notification"
            self.confirmationView2.descriptionLabel.text = "Prior actions will be lost if you proceed. Confirm your choice."
            self.confirmationView2.blueButton.setTitle("NO", for: .normal)
            self.confirmationView2.redButton.setTitle("YES", for: .normal)
        }
    }
    
    private func setupCollectionViews_e0Q04() {
        wardrobeView.itemCollectionView.dataSource = self
        wardrobeView.itemCollectionView.delegate = self
        wardrobeView.itemCollectionView.register(ItemCell_e0Q04.self, forCellWithReuseIdentifier: Cell.item)
        wardrobeView.itemCollectionView.register(ResetButtonCell_e0Q04.self, forCellWithReuseIdentifier: Cell.discardButton)
        
    }
    
    @objc func noButtonTapped_e0Q04() {
        confirmationView.isHidden = true
    }
    @objc func noButtonTapped() {
        confirmationView2.isHidden = true
    }
    
    @objc func yesButtonTapped_e0Q04() {
        if returnActionInitiated {
            // IMPLEMENT ERASE DATA
            characterEdited = false
            returnActionInitiated = false
            confirmationView.isHidden = true
            // viewModel.saveInitialItems()
            navigationController?.popViewController(animated: true)
        } else {
            // IMPLEMENT ERASE DATA
            viewModel.resetItems_e0Q04()
            
            // Reset the selection data
            selectedItemPerCategory.removeAll()
            viewModel.selectedItemIndex = nil
            
            characterEdited = false
            returnActionInitiated = false
            confirmationView.isHidden = true
            
            // Reload images and collection view
            loadImages()
            wardrobeView.itemCollectionView.reloadData()
        }
    }
    @objc func yesButtonTapped() {
        if viewModel.characterType == .boy {
            girlButtonTapped_e0Q04()
        }else{
            boyButtonTapped_e0Q04()
        }
        confirmationView2.isHidden = true
    }
    private func boyButtonTapped_e0Q04() {
        print("Boy button tapped!")
        characterEdited = true
        viewModel.characterType = .boy
        updateButtonAppearance_e0Q04()
        viewModel.resetHistory()
        viewModel.resetItems_e0Q04()
        viewModel.setDefaultItems()
        updateUndoRedoButtons()
        loadImages()
        selectedItemPerCategory.removeAll()
        wardrobeView.itemCollectionView.reloadData()
    }
    
    private func girlButtonTapped_e0Q04() {
        print("Girl button tapped!")
        characterEdited = true
        viewModel.characterType = .girl
        updateButtonAppearance_e0Q04()
        viewModel.resetHistory()
        viewModel.resetItems_e0Q04()
        viewModel.setDefaultItems()
        updateUndoRedoButtons()
        loadImages()
        selectedItemPerCategory.removeAll()
        wardrobeView.itemCollectionView.reloadData()
    }
    @objc private func backButtonTapped_e0Q04() {
        print("Back Button Tapped")
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        
        returnActionInitiated = true
        
        if characterEdited {
            cancelEditsPopUp()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func discardChangesButtonTapped_e0Q04() {
        print("Discard button tapped")
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        
            eraseActionsPopUp()
        
    }
    
    @objc private func saveButtonTapped_e0Q04() {
        print("Save button tapped")
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        characterEdited = false
        // Capture the character screen
        if let characterImage = captureSnapshot(),
           let photoURL = saveImageToDocumentsDirectory(image: characterImage) {
            let savedCharacterUUID = CoreDataManager_e0Q04.shared.saveOrUpdateCharacter(uuid: viewModel.characterUUID,
                                                                                        type: viewModel.characterType,
                                                                                        items: viewModel.predefinedItemIds,
                                                                                        photoURL: photoURL)
            
            viewModel.characterUUID = savedCharacterUUID
        }
        viewModel.saveInitialItems_e0Q04()
        viewModel.fetchCharactersFromCoreData_e0Q04()
        viewModel.sortCharacterList_e0Q04()

        DispatchQueue.main.async {
            self.saveButton.backgroundColor = .customGreen
        }
        
        
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
        viewController = PreviewViewController_e0Q04()
        (viewController as? PreviewViewController_e0Q04)?.viewModel = viewModel
        
        if var viewControllers = navigationController?.viewControllers {
            viewControllers.removeLast()
            viewControllers.append(viewController)
            navigationController?.setViewControllers(viewControllers, animated: true)
        }
    }
    
    @objc private func segmentButtonTapped(_ sender: UIButton) {
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        guard let buttonTitle = sender.titleLabel?.text else { return }
        viewModel.selectedCategory = buttonTitle
        wardrobeView.genderSelectionStackView.isHidden = true
        wardrobeView.boyButton.isHidden = true
        wardrobeView.girlButton.isHidden = true
        wardrobeView.itemCollectionView.isHidden = false
        
        if let button = selectedButton {
            button.isSelected = false
            DispatchQueue.main.async {
                button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
                let fontSize: CGFloat = Configs_e0Q04.shared.currentDevice.isPad ? 22 : 14
                let customFont = Assets.Fredoka.medium(fontSize)
                button.setTitleColor(UIColor.myGreen, for: .normal)
                button.setTitleColor(UIColor.myGreen, for: .selected)
                button.titleLabel?.font = customFont
                button.backgroundColor = .lightGreen
                let radius: CGFloat = Configs_e0Q04.shared.currentDevice.isPad ? 30 : 20
                button.layer.cornerRadius = radius
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.white.cgColor
                button.layer.shadowColor = UIColor.customBlack.cgColor
                button.layer.shadowOpacity = 0.3
                button.layer.shadowOffset = CGSize(width: 0, height: 4)
                button.layer.shadowRadius = 2
            }
        }
        
        DispatchQueue.main.async {
            sender.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            let fontSize: CGFloat = Configs_e0Q04.shared.currentDevice.isPad ? 22 : 14
            let customFont = Assets.Fredoka.medium(fontSize)
            sender.setTitleColor(UIColor.white, for: .normal)
            sender.setTitleColor(UIColor.white, for: .selected)
            sender.titleLabel?.font = customFont
            sender.backgroundColor = .myGreen
            let radius: CGFloat = Configs_e0Q04.shared.currentDevice.isPad ? 30 : 20
            sender.layer.cornerRadius = radius
            sender.layer.borderWidth = 2
            sender.layer.borderColor = UIColor.white.cgColor
            sender.layer.shadowColor = UIColor.customBlack.cgColor
            sender.layer.shadowOpacity = 0.3
            sender.layer.shadowOffset = CGSize(width: 0, height: 4)
            sender.layer.shadowRadius = 2
            
        }
        
        selectedButton = sender
        
        if viewModel.characterType == .boy {
            updateCurrentItems(for: viewModel.boyCategories, matching: buttonTitle)
        } else {
            updateCurrentItems(for: viewModel.girlCategories, matching: buttonTitle)
        }
        
//        wardrobeView.itemCollectionView.reloadData()
//        let indexPath = IndexPath(item: 0, section: 0)
//        wardrobeView.itemCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
//        view.layoutIfNeeded()
                
        guard let category = getCategory(forTitle: buttonTitle) else {
            return
        }
        
        let selectedItemId = Int(viewModel.predefinedItemIds[category.zIndex] ?? "0")
        
        let indexPath: IndexPath
        if selectedItemId == 6 {
            indexPath = IndexPath(item: selectedItemId ?? 0, section: 0)
        }else{
            indexPath = IndexPath(item: ((selectedItemId ?? 1) - 1), section: 0)
        }
        
        wardrobeView.itemCollectionView.reloadData()
        wardrobeView.itemCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        view.layoutIfNeeded()
        
    }
    
    
    @objc private func genderSelectionTapped(_ sender: UIButton) {
        print("Sex Selection button tapped")
        
        wardrobeView.genderSelectionStackView.isHidden = false
        wardrobeView.boyButton.isHidden = false
        wardrobeView.girlButton.isHidden = false
        wardrobeView.itemCollectionView.isHidden = true
        
        guard (sender.titleLabel?.text) != nil else { return }
        viewModel.selectedCategory = "GENDER"
        
        if let button = selectedButton {
            button.isSelected = false
            DispatchQueue.main.async {
                button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
                let fontSize: CGFloat = Configs_e0Q04.shared.currentDevice.isPad ? 22 : 14
                let customFont = Assets.Fredoka.medium(fontSize)
                button.setTitleColor(UIColor.myGreen, for: .normal)
                button.setTitleColor(UIColor.myGreen, for: .selected)
                button.titleLabel?.font = customFont
                button.backgroundColor = .lightGreen
                let radius: CGFloat = Configs_e0Q04.shared.currentDevice.isPad ? 30 : 20
                button.layer.cornerRadius = radius
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.white.cgColor
                button.layer.shadowColor = UIColor.customBlack.cgColor
                button.layer.shadowOpacity = 0.3
                button.layer.shadowOffset = CGSize(width: 0, height: 4)
                button.layer.shadowRadius = 2
            }
        }
        
        DispatchQueue.main.async {
            sender.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            let fontSize: CGFloat = Configs_e0Q04.shared.currentDevice.isPad ? 22 : 14
            let customFont = Assets.Fredoka.medium(fontSize)
            sender.setTitleColor(UIColor.white, for: .normal)
            sender.setTitleColor(UIColor.white, for: .selected)
            sender.titleLabel?.font = customFont
            sender.backgroundColor = .myGreen
            let radius: CGFloat = Configs_e0Q04.shared.currentDevice.isPad ? 30 : 20
            sender.layer.cornerRadius = radius
            sender.layer.borderWidth = 2
            sender.layer.borderColor = UIColor.white.cgColor
            sender.layer.shadowColor = UIColor.customBlack.cgColor
            sender.layer.shadowOpacity = 0.3
            sender.layer.shadowOffset = CGSize(width: 0, height: 4)
            sender.layer.shadowRadius = 2
        }
        
        selectedButton = sender
        
        viewModel.isSexSelectionActive = true
        wardrobeView.itemCollectionView.reloadData()
    }
    
    private func updateButtonAppearance_e0Q04() {
        if viewModel.characterType == .boy {
            DispatchQueue.main.async {
                self.wardrobeView.boyButton.layer.borderColor = UIColor.myGreen.cgColor
                self.wardrobeView.boyButton.setTitleColor(.myGreen, for: .normal)
                
                self.wardrobeView.girlButton.setTitleColor(.grayColor2, for: .normal)
                self.wardrobeView.girlButton.layer.borderColor = UIColor.grayColor2.cgColor
                self.wardrobeView.boyButton.isUserInteractionEnabled = false
                self.wardrobeView.girlButton.isUserInteractionEnabled = true
            }
        } else {
            DispatchQueue.main.async {
                self.wardrobeView.boyButton.layer.borderColor = UIColor.grayColor2.cgColor
                self.wardrobeView.boyButton.setTitleColor(.grayColor2, for: .normal)
                
                self.wardrobeView.girlButton.layer.borderColor = UIColor.myGreen.cgColor
                self.wardrobeView.girlButton.setTitleColor(.myGreen, for: .normal)
                self.wardrobeView.boyButton.isUserInteractionEnabled = true
                self.wardrobeView.girlButton.isUserInteractionEnabled = false
            }
        }
    }
    @objc private func backElementTapped(_ sender: UITapGestureRecognizer) {
        viewModel.undo()
        loadImages()
        updateSelectedCell()
        updateUndoRedoButtons()
//        updateSegmentControlSelection()
        print("Категория" , viewModel.selectedCategory)
        view.layoutIfNeeded()
    }

    @objc private func nextElementTapped(_ sender: UITapGestureRecognizer) {
        viewModel.redo()
        loadImages()
        updateSelectedCell()
        updateUndoRedoButtons()
//        updateSegmentControlSelection()
        print("Категория" , viewModel.selectedCategory)
        view.layoutIfNeeded()
    }

    
    func updateCollectionBasedOnCategory() {
        let buttonTitle = viewModel.selectedCategory
        
        if buttonTitle == "HEADDRESS" {
            var currentCategory = viewModel.characterType == .boy ?
            viewModel.boyCategories.first(where: { $0.title == buttonTitle }) :
            viewModel.girlCategories.first(where: { $0.title == buttonTitle })
            currentCategory?.isResetEnabled = true
        }
        
        if viewModel.characterType == .boy {
            updateCurrentItems(for: viewModel.boyCategories, matching: buttonTitle)
        } else {
            updateCurrentItems(for: viewModel.girlCategories, matching: buttonTitle)
        }
        
        wardrobeView.itemCollectionView.reloadData()
        wardrobeView.itemCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        
        if viewModel.selectedCategory == "Gender" {
            wardrobeView.genderSelectionStackView.isHidden = false
            wardrobeView.boyButton.isHidden = false
            wardrobeView.girlButton.isHidden = false
            wardrobeView.itemCollectionView.isHidden = true
        } else {
            wardrobeView.genderSelectionStackView.isHidden = true
            wardrobeView.boyButton.isHidden = true
            wardrobeView.girlButton.isHidden = true
            wardrobeView.itemCollectionView.isHidden = false
            wardrobeView.itemCollectionView.reloadData()
        }
        
    }
    
    func updateSelectedCell() {
        let selectedCategoryTitle = viewModel.selectedCategory
        
        guard let category = getCategory(forTitle: selectedCategoryTitle) else {
            print("Category not found for title \(selectedCategoryTitle)")
            return
        }
        
        let selectedItemId = Int(viewModel.predefinedItemIds[category.zIndex] ?? "0")
        
        let indexPath: IndexPath
        if selectedItemId == 6 {
            indexPath = IndexPath(item: selectedItemId ?? 0, section: 0)
        }else{
            indexPath = IndexPath(item: ((selectedItemId ?? 1) - 1), section: 0)
        }
        
//        if viewModel.characterType == .boy {
//            updateCurrentItems(for: viewModel.boyCategories, matching: selectedCategoryTitle)
//        } else {
//            updateCurrentItems(for: viewModel.girlCategories, matching: selectedCategoryTitle)
//        }
        selectedItemPerCategory[selectedCategoryTitle] = indexPath
        
        if selectedCategoryTitle == selectedButton?.titleLabel?.text {
            wardrobeView.itemCollectionView.reloadData()
            wardrobeView.itemCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
        
        view.layoutIfNeeded()
    }
    
    private func updateSegmentControlSelection() {
        let category = viewModel.selectedCategory
        for button in arrayOfElements {
            if button.titleLabel?.text == category {
                button.isSelected = true
                selectedButton = button
                updateButtonAppearance(button: button)
            } else {
                button.isSelected = false
                updateButtonAppearance(button: button)
            }
        }
    }

    private func updateButtonAppearance(button: UIButton) {
        DispatchQueue.main.async {
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            let fontSize: CGFloat = Configs_e0Q04.shared.currentDevice.isPad ? 22 : 14
            let customFont = Assets.Fredoka.medium(fontSize)
            let color = button.isSelected ? UIColor.white : UIColor.myGreen
            button.setTitleColor(color, for: .normal)
            button.setTitleColor(color, for: .selected)
            button.titleLabel?.font = customFont
            button.backgroundColor = button.isSelected ? .myGreen : .lightGreen
            let radius: CGFloat = Configs_e0Q04.shared.currentDevice.isPad ? 30 : 20
            button.layer.cornerRadius = radius
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.shadowColor = UIColor.customBlack.cgColor
            button.layer.shadowOpacity = 0.3
            button.layer.shadowOffset = CGSize(width: 0, height: 4)
            button.layer.shadowRadius = 2
        }
    }

    
    private func getCategory(forTitle title: String) -> Category? {
        let categories = viewModel.characterType == .boy ? viewModel.boyCategories : viewModel.girlCategories
        return categories.first(where: { $0.title == title })
    }
    
    private func updateUndoRedoButtons() {
        
        let isUndoAvailable = viewModel.canUndo
        let isRedoAvailable = viewModel.canRedo
        
        print("isUndoAvailable: \(isUndoAvailable)")
        print("isRedoAvailable: \(isRedoAvailable)")
        
        if isUndoAvailable {
            wardrobeView.backButtonView.mainView.layer.borderColor = UIColor.white.cgColor
            wardrobeView.backButtonView.mainView.backgroundColor = .myGreen
            wardrobeView.backButtonView.backImage.image = Assets.Icon.iconBack3
        }else{
            wardrobeView.backButtonView.mainView.layer.borderColor = UIColor.grayColor2.cgColor
            wardrobeView.backButtonView.mainView.backgroundColor = .lightGreen
            wardrobeView.backButtonView.backImage.image = Assets.Icon.iconBack4
        }
        
        if isRedoAvailable {
            wardrobeView.nextButtonView.mainView.layer.borderColor = UIColor.white.cgColor
            wardrobeView.nextButtonView.mainView.backgroundColor = .myGreen
            wardrobeView.nextButtonView.nextImage.image = Assets.Icon.iconNext
        }else{
            wardrobeView.nextButtonView.mainView.layer.borderColor = UIColor.grayColor2.cgColor
            wardrobeView.nextButtonView.mainView.backgroundColor = .lightGreen
            wardrobeView.nextButtonView.nextImage.image = Assets.Icon.iconNext2
        }
        
    }
    
    func setupViews_e0Q04() {
        backgroundImage.image = Assets.Background.gradient
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imagePlatform.image = Assets.Image.platform
        view.addSubview(imagePlatform)
        imagePlatform.snp.makeConstraints { make in
            
            let device = Device.current
            
            if device.isPhone {
                // Settings for other iPhone models
                make.centerY.equalToSuperview().offset(UIScreen.main.bounds.height * 0.18)
                make.centerX.equalToSuperview()
                make.width.equalTo(195)
                make.height.equalTo(45)
            }else if device.isPad {
                make.centerY.equalToSuperview().offset(UIScreen.main.bounds.height * 0.18)
                make.centerX.equalToSuperview()
                make.width.equalTo(390)
                make.height.equalTo(90)
            }
        }
        view.backgroundColor = .white
        view.addSubview(imageViewContainer)
        imageViewContainer.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(30)
//            make.right.equalToSuperview().offset(-30)
//            make.top.equalToSuperview().offset(172)
//            make.bottom.equalToSuperview().offset(-215)
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
                make.size.equalTo(60)
                make.leading.equalToSuperview()
            }else{
                make.size.equalTo(40)
                make.leading.equalToSuperview().inset(20)
            }
        }
        
        saveButton.setTitle("SAVE".localizedUI, for: .normal)
        headerView.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            if configs.currentDevice.isPad {
                make.width.equalTo(120)
                make.height.equalTo(60)
                make.trailing.equalToSuperview()
            }else{
                make.width.equalTo(80)
                make.height.equalTo(40)
                make.trailing.equalToSuperview().inset(20)
            }
        }
        
        view.addSubview(segmentControlContainer)
        
        segmentControlContainer.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview()
            if configs.currentDevice.isPad {
                make.height.equalTo(70)
            }else{
                make.height.equalTo(50)
            }
        }
        segmentControlContainer.addSubview(customSegmentControl)
        customSegmentControl.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            if configs.currentDevice.isPad {
                make.height.equalTo(60)
            }else{
                make.height.equalTo(40)
            }
        }
        
        view.addSubview(confirmationView)
        confirmationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        confirmationView.isHidden = true
        
        view.addSubview(confirmationView2)
        confirmationView2.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        confirmationView2.isHidden = true
        
        view.addSubview(wardrobeView)
        let height = UIScreen.main.bounds.height
        let fractionOfScreenHeight: CGFloat = 0.257
        let wardrobeViewHeight = height * fractionOfScreenHeight
        
        wardrobeView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(wardrobeViewHeight)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backElementTapped))
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(nextElementTapped))
        wardrobeView.backButtonView.addGestureRecognizer(tapGesture)
        wardrobeView.nextButtonView.addGestureRecognizer(tapGesture1)
        wardrobeView.genderSelectionStackView.isHidden = true
        
    }
}

// MARK: - UICollectionViewDataSource
extension EditorViewController_e0Q04: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let currentCategoryTitle = selectedButton?.titleLabel?.text ?? ""
        let currentCategory = viewModel.characterType == .boy ?
        viewModel.boyCategories.first(where: { $0.title == currentCategoryTitle }) :
        viewModel.girlCategories.first(where: { $0.title == currentCategoryTitle })
        
        let isResetEnabled = currentCategory?.isResetEnabled ?? false
        return viewModel.currentItems.count + (isResetEnabled ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        let currentCategoryTitle = selectedButton?.titleLabel?.text ?? ""
//        let currentCategoryTitle = viewModel.selectedCategory

        print("Current category title: \(currentCategoryTitle)")
        
        let currentCategory = viewModel.characterType == .boy ?
        viewModel.boyCategories.first(where: { $0.title == currentCategoryTitle }) :
        viewModel.girlCategories.first(where: { $0.title == currentCategoryTitle })
        
        let isResetEnabled = currentCategory?.isResetEnabled ?? false
        
        print("Is reset button enabled: \(isResetEnabled)")
        print(viewModel.predefinedItemIds)

        // Check if the first cell (discard button) should be displayed
        if indexPath.row == 0 && isResetEnabled {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.discardButton, for: indexPath) as? ResetButtonCell_e0Q04 else {
                fatalError("Unable to dequeue ButtonCell")
            }
            
            var isSelected = selectedItemPerCategory[currentCategoryTitle] == nil
            if viewModel.predefinedItemIds.count < 7 {
                isSelected = true
            } else {
                isSelected = false
            }
            
            if viewModel.predefinedItemIds["6"] == "0" {
                isSelected = true
            }
            print(viewModel.predefinedItemIds.count)
            // Configure the appearance of the discard button
            cell.containerView.layer.borderColor = isSelected ? UIColor.myGreen.cgColor : UIColor.grayColor2.cgColor
            cell.isSelected = isSelected
            print("Reset button cell at indexPath: \(indexPath), isSelected: \(isSelected)")
            
            return cell
        } else {
            // Calculate the adjusted index for other items, considering the discard button
            let adjustedIndex = isResetEnabled ? indexPath.row - 1 : indexPath.row
            print("Adjusted index for cell: \(adjustedIndex)")
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.item, for: indexPath) as? ItemCell_e0Q04 else {
                fatalError("Unable to dequeue ItemCell")
            }
            
            // Fetch the item for the adjusted index
            let item = viewModel.currentItems[adjustedIndex]
            if let cachedData = DataCache.instance.readData(forKey: item.preview),
               let image = UIImage(data: cachedData) {
                cell.imageView.image = image
            }
            // Determine if the cell corresponding to the item is selected
            let isItemSelected = selectedItemPerCategory[currentCategoryTitle] == IndexPath(row: adjustedIndex, section: 0)
            print("Is item selected based on selectedItemPerCategory: \(isItemSelected)")
            let isDefaultItemSelected = viewModel.predefinedItemIds[currentCategory?.zIndex ?? ""] == item.id && selectedItemPerCategory[currentCategoryTitle] == nil
            print("Is default item selected based on predefinedItemIds: \(isDefaultItemSelected)")
            
            let isSelected = isItemSelected || isDefaultItemSelected
            print("Final isSelected state for cell at indexPath: \(indexPath), isSelected: \(isSelected)")
            
            // Configure the appearance of the item cell
            cell.containerView.layer.borderColor = isSelected ? UIColor.myGreen.cgColor : UIColor.grayColor2.cgColor
            cell.isSelected = isSelected
            if viewModel.predefinedItemIds["6"] == "0" {
                cell.isSelected = false
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        let currentCategoryTitle = selectedButton?.titleLabel?.text ?? ""
        guard let text = selectedButton?.titleLabel?.text else {return}

            let currentCategoryTitle = text
        
            let currentCategory = viewModel.characterType == .boy ?
            viewModel.boyCategories.first(where: { $0.title == currentCategoryTitle }) :
            viewModel.girlCategories.first(where: { $0.title == currentCategoryTitle })
            
            let isResetEnabled = currentCategory?.isResetEnabled ?? false
            
            if indexPath.row == 0 && isResetEnabled {
                selectedItemPerCategory[currentCategoryTitle] = nil
                viewModel.selectedItemIndex = nil
                
                if let ZINDEX = currentCategory?.zIndex {
                    viewModel.predefinedItemIds[ZINDEX] = "0"
                }
                
                if let zIndex = Int(currentCategory?.zIndex ?? "0"), imageViews.indices.contains(zIndex) {
                    let imageViewToUpdate = imageViews[zIndex]
                    imageViewToUpdate.image = nil
                    viewModel.addToHistory()
                    updateUndoRedoButtons()
                }
            } else {
                let adjustedIndex = isResetEnabled ? indexPath.row - 1 : indexPath.row
                viewModel.selectedItemIndex = IndexPath(row: adjustedIndex, section: 0)
                selectedItemPerCategory[currentCategoryTitle] = viewModel.selectedItemIndex
                
                if let cachedData = DataCache.instance.readData(forKey: viewModel.currentItems[adjustedIndex].path),
                   let image = UIImage(data: cachedData),
                   let zIndex = Int(currentCategory?.zIndex ?? "0"), imageViews.indices.contains(zIndex) {
                    let imageViewToUpdate = imageViews[zIndex]
                    imageViewToUpdate.image = image
                    let selectedItem = viewModel.currentItems[adjustedIndex]
                    viewModel.addToHistory()
                    updateUndoRedoButtons()
                    viewModel.predefinedItemIds[currentCategory?.zIndex ?? ""] = selectedItem.id
                }
            }
            collectionView.reloadData()
            characterEdited = true
        }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EditorViewController_e0Q04: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if Configs_e0Q04.shared.currentDevice.isPad {
            return CGSize(width: 150, height: 170)
        } else {
            return CGSize(width: 74, height: 74)
        }
    }
}

// MARK: - Custom Segment Control
extension EditorViewController_e0Q04 {
    private func setupCustomSegmentControl1() {
        customSegmentControl.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let sexSelectionButton = UIButton()
        sexSelectionButton.setTitle("Gender", for: .normal)
        configureButton(sexSelectionButton)
        sexSelectionButton.addTarget(self, action: #selector(genderSelectionTapped(_:)), for: .touchUpInside)
        customSegmentControl.addArrangedSubview(sexSelectionButton)
        arrayOfElements.append(sexSelectionButton)
        
        // Add buttons for existing categories
        let categories = viewModel.characterType == .boy ? viewModel.boyCategories : viewModel.girlCategories
        for category in categories {
            let button = UIButton()
            button.setTitle(category.title, for: .normal)
            configureButton(button)
            button.addTarget(self, action: #selector(segmentButtonTapped(_:)), for: .touchUpInside)
            customSegmentControl.addArrangedSubview(button)
            arrayOfElements.append(button)
        }
        
        // Placeholder empty button
        let emptyButton = UIButton()
        emptyButton.isEnabled = false
        emptyButton.alpha = 0.0
        customSegmentControl.addArrangedSubview(emptyButton)
    }
    private func configureButton(_ button: UIButton) {
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let fontSize: CGFloat = Configs_e0Q04.shared.currentDevice.isPad ? 22 : 14
        let customFont = Assets.Fredoka.medium(fontSize)
        button.setTitleColor(UIColor.myGreen, for: .normal)
        button.setTitleColor(UIColor.myGreen, for: .selected)
        button.titleLabel?.font = customFont
        button.backgroundColor = .lightGreen
        let radius: CGFloat = Configs_e0Q04.shared.currentDevice.isPad ? 30 : 20
        button.layer.cornerRadius = radius
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.shadowColor = UIColor.customBlack.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 2
    }
    private func updateCurrentItems(for categories: [Category], matching title: String) {
        if let category = categories.first(where: { $0.title == title }) {
            viewModel.currentItems = category.items
        }
    }
    
    func updateCustomSegmentControl() {
        setupCustomSegmentControl1()
        view.layoutIfNeeded()
    }
}

// MARK: - Image View Loading from Cache and ImageViews Creation
extension EditorViewController_e0Q04 {
    private func createImageViews(from editorData: EditorModel) {
        imageViews.removeAll()
        
        let categories = viewModel.characterType == .boy ? editorData.editor.boy : editorData.editor.girl
        let sortedCategories = categories.sorted { Int($0.zIndex) ?? 0 < Int($1.zIndex) ?? 0 }
        
        for category in sortedCategories {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            let zIndex = Int(category.zIndex) ?? 0
            imageView.tag = zIndex
            
            imageViewContainer.addSubview(imageView)
            imageViews.append(imageView)
            
            imageView.snp.makeConstraints { make in
//                make.edges.equalToSuperview()
                make.centerY.equalToSuperview().offset(-20)
                make.centerX.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(0.55)
            }
        }
    }
    
    private func loadImages() {
        let categories = viewModel.characterType == .boy ? viewModel.boyCategories : viewModel.girlCategories
        
        for category in categories {
            // Get the item ID for the current category's zIndex
            if let itemId = viewModel.predefinedItemIds[category.zIndex],
               let item = category.items.first(where: { $0.id == itemId }),
               let cachedData = DataCache.instance.readData(forKey: item.path),
               let image = UIImage(data: cachedData) {
                let zIndex = Int(category.zIndex) ?? 0
                if let imageView = imageViews.first(where: { $0.tag == zIndex }) {
                    imageView.image = image
                }
            }
            //            if viewModel.predefinedItemIds[category.zIndex] == nil {
            //                let zIndex = Int(category.zIndex) ?? 0
            //                if let imageView = imageViews.first(where: { $0.tag == zIndex }) {
            //                    imageView.image = nil
            //                }
            //            }
            //            if viewModel.predefinedItemIds["6"] == "0" {
            //                if let imageView = imageViews.first(where: { $0.tag == 6 }) {
            //                    imageView.image = nil
            //                }
            //            }
        }
        if viewModel.predefinedItemIds["6"] == "0" {
            if let imageView = imageViews.first(where: { $0.tag == 6 }) {
                imageView.image = nil
            }
        }
        print(viewModel.predefinedItemIds)
    }
}

// MARK: - Create Character Image and Save to Docs
extension EditorViewController_e0Q04 {
    private func captureSnapshot() -> UIImage? {
        print("Attempting to capture a snapshot of the imageViewContainer.")
        let renderer = UIGraphicsImageRenderer(bounds: imageViewContainer.bounds)
        let image = renderer.image { context in
            imageViewContainer.drawHierarchy(in: imageViewContainer.bounds, afterScreenUpdates: true)
        }
        print("Snapshot of imageViewContainer captured successfully.")
        return image
    }
    
    private func saveImageToDocumentsDirectory(image: UIImage) -> URL? {
        guard let data = image.pngData() else {
            print("Failed to get PNG data from the image.")
            return nil
        }
        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileName = UUID().uuidString
            let fileURL = documentsDirectory.appendingPathComponent("\(fileName).png")
            do {
                try data.write(to: fileURL)
                print("Image saved successfully at \(fileURL.path)")
                return fileURL
            } catch {
                print("Error saving image: \(error)")
                return nil
            }
        } else {
            print("Could not find the documents directory.")
            return nil
        }
    }
}

// MARK: - Layout and Button Action Setup
extension EditorViewController_e0Q04 {
    private func setupButtonActions_e0Q04() {
        backButton.addTarget(self, action: #selector(backButtonTapped_e0Q04), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped_e0Q04), for: .touchUpInside)
        confirmationView.blueButton.addTarget(self, action: #selector(noButtonTapped_e0Q04), for: .touchUpInside)
        confirmationView.redButton.addTarget(self, action: #selector(yesButtonTapped_e0Q04), for: .touchUpInside)
        confirmationView2.blueButton.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        confirmationView2.redButton.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        wardrobeView.boyButton.addTarget(self, action: #selector(discardChangesButtonTapped_e0Q04), for: .touchUpInside)
        wardrobeView.girlButton.addTarget(self, action: #selector(discardChangesButtonTapped_e0Q04), for: .touchUpInside)
    }
}
