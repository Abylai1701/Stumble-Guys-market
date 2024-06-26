import UIKit
import DeviceKit
import SnapKit

class BaseSectionViewController_e0Q04: UIViewController, UITextFieldDelegate {
    
    var containerViewHeightConstraint: Constraint?

    var centerLineContainer = UIView()
    var containerView = BlueViewWithStroke_e0Q04()
    var seachIconImage = UIImageView()
    var discardIconImage = UIImageView()
    var discardButtonTap = UIButton()
    var searchSuggestionsTableView = UITableView()
    var searchTextField = UITextField()
    var header = HeaderView_e0Q04()
    var filterButtons = FilterButtonsView_e0Q04()
    var collectionView: UICollectionView!
    let loadingScreen = LoadingScreenHelper_e0Q04()
    var backgroundImageView = UIImageView()
    var searchResults = [String]()
    var searchViewHeightConstraint: NSLayoutConstraint?
    var dataCacheManager = DataCacheManager_e0Q04.shared
    var configs = Configs_e0Q04.shared
    var loadingView = LoadingViewFromMenu()
    var completeView = CompleteView()
    var loadingDownloadView = LoadingView_e0Q04()
    var preloaderView = UIView()
    
    var emptySearchView = FavoriteDidNotFountView_e0Q04()
    lazy var blurEffectMenu: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectMenu = UIVisualEffectView(effect: blurEffect)
        blurEffectMenu.frame = view.bounds
        blurEffectMenu.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectMenu.alpha = 0.85
        return blurEffectMenu
    }()
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.85
        return blurEffectView
    }()
    
    lazy var cardDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGreen
        view.layer.cornerRadius = 15
        return view
    }()
    var line = UIView()
        
      
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.showPreloader()
        }
        setupViews_e0Q04()
        setupButtonActions_e0Q04()
        setupCollectionView_e0Q04()
        setupSearchTextField()
        setupResultsTableView()
        setupSearchBar_e0Q04()
        switchHeaderAndSearch(hideSearch: true)
        setupEmptySearchView()
        setupDismissTapGesture() // Новый метод для настройки жеста

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emptySearchView.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func setupViews_e0Q04() {
        view.backgroundColor = .customWhite
        backgroundImageView.image = Assets.Background.clouds
        
        self.discardButtonTap.isHidden = true
        self.discardIconImage.isHidden = true
        
        line.backgroundColor = .grayColor
        line.isHidden = true

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
        
        header.rightButton.setImage(Assets.Icon.search, for: .normal)
        setupSearchBar_e0Q04()
    }
    private func setupEmptySearchView() {
        view.addSubview(emptySearchView)
        emptySearchView.snp.makeConstraints { make in
            if configs.currentDevice.isPad {
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(85)
                make.right.equalToSuperview().offset(-85)
            }else{
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(53)
                make.right.equalToSuperview().offset(-53)
            }
        }
        emptySearchView.titleLabel.text = "Nothing was found in the search"
        if Configs_e0Q04.shared.currentDevice.isPad {
            emptySearchView.mainView.layer.cornerRadius = 26
        } else {
            emptySearchView.mainView.layer.cornerRadius = 22
        }
        emptySearchView.isHidden = true
    }
    private func setupSearchTextField() {
        searchTextField.autocorrectionType = .no // Disable autocorrection
        searchTextField.addTarget(self, action: #selector(searchTextFieldChanged(_:)), for: .editingChanged)
        searchTextField.delegate = self
    }
    
    @objc func searchTextFieldChanged(_ textField: UITextField) {
        print("searchTextFieldChanged called")
        searchSuggestionsTableView.reloadData()
    }
    @objc func searchTextFieldChangedREF(_ textField: UITextField) {
        print("searchTextFieldChanged called")
        searchSuggestionsTableView.reloadData()
    }
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let searchText = textField.text, searchText.isEmpty {
            self.discardButtonTap.isHidden = true
            self.discardIconImage.isHidden = true
        }
        return true
    }
    
    func showPreloader() {
        if configs.isAppFirstLaunch {
            if configs.currentDevice.isPad {
                preloaderView = PreloaderViewIPad(frame: view.bounds)
            } else {
                preloaderView = PreloaderView(frame: view.bounds)
            }
            
            view.addSubview(preloaderView)
            
            preloaderView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            configs.isAppFirstLaunch = false
        }else{
            loadingView = LoadingViewFromMenu(frame: view.bounds)
            
            view.addSubview(loadingView)
            
            loadingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {}
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Если текстовое поле пустое после завершения редактирования, восстанавливаем плейсхолдер
        if textField.text?.isEmpty ?? true {
            textField.placeholder = "Search"
        }
    }
    func searchCloseTap_e0Q04(_ textField: UITextField) {
        clearTextField()
    }
    @objc func allButtonTapped_e0Q04() {
        filterButtons.allButton.backgroundColor = UIColor.myGreen
        filterButtons.allButton.setTitleColor(UIColor.customWhite, for: .normal)
        filterButtons.favoriteButton.backgroundColor = UIColor.lightGreen
        filterButtons.favoriteButton.setTitleColor(UIColor.myGreen, for: .normal)
        filterButtons.newButton.backgroundColor = UIColor.lightGreen
        filterButtons.newButton.setTitleColor(UIColor.myGreen, for: .normal)
        filterButtons.topButton.backgroundColor = UIColor.lightGreen
        filterButtons.topButton.setTitleColor(UIColor.myGreen, for: .normal)
        clearTextField()
        discardSearchButtonTapped_e0Q04s()
    }
    func reloadFilter() {
        filterButtons.allButton.backgroundColor = UIColor.myGreen
        filterButtons.allButton.setTitleColor(UIColor.customWhite, for: .normal)
        filterButtons.favoriteButton.backgroundColor = UIColor.lightGreen
        filterButtons.favoriteButton.setTitleColor(UIColor.myGreen, for: .normal)
        filterButtons.newButton.backgroundColor = UIColor.lightGreen
        filterButtons.newButton.setTitleColor(UIColor.myGreen, for: .normal)
        filterButtons.topButton.backgroundColor = UIColor.lightGreen
        filterButtons.topButton.setTitleColor(UIColor.myGreen, for: .normal)
        
    }
    @objc func favoriteButtonTapped_e0Q04() {
        filterButtons.allButton.backgroundColor = UIColor.lightGreen
        filterButtons.allButton.setTitleColor(UIColor.myGreen, for: .normal)
        filterButtons.favoriteButton.backgroundColor = UIColor.myGreen
        filterButtons.favoriteButton.setTitleColor(UIColor.customWhite, for: .normal)
        filterButtons.newButton.backgroundColor = UIColor.lightGreen
        filterButtons.newButton.setTitleColor(UIColor.myGreen, for: .normal)
        filterButtons.topButton.backgroundColor = UIColor.lightGreen
        filterButtons.topButton.setTitleColor(UIColor.myGreen, for: .normal)
        clearTextField()
        discardSearchButtonTapped_e0Q04s()
    }
    
    @objc func newButtonTapped_e0Q04() {
        filterButtons.allButton.backgroundColor = UIColor.lightGreen
        filterButtons.allButton.setTitleColor(UIColor.myGreen, for: .normal)
        filterButtons.favoriteButton.backgroundColor = UIColor.lightGreen
        filterButtons.favoriteButton.setTitleColor(UIColor.myGreen, for: .normal)
        filterButtons.newButton.backgroundColor = UIColor.myGreen
        filterButtons.newButton.setTitleColor(UIColor.customWhite, for: .normal)
        filterButtons.topButton.backgroundColor = UIColor.lightGreen
        filterButtons.topButton.setTitleColor(UIColor.myGreen, for: .normal)
        clearTextField()
        discardSearchButtonTapped_e0Q04s()
    }
    
    @objc func topButtonTapped_e0Q04() {
        filterButtons.allButton.backgroundColor = UIColor.lightGreen
        filterButtons.allButton.setTitleColor(UIColor.myGreen, for: .normal)
        filterButtons.favoriteButton.backgroundColor = UIColor.lightGreen
        filterButtons.favoriteButton.setTitleColor(UIColor.myGreen, for: .normal)
        filterButtons.newButton.backgroundColor = UIColor.lightGreen
        filterButtons.newButton.setTitleColor(UIColor.myGreen, for: .normal)
        filterButtons.topButton.backgroundColor = UIColor.myGreen
        filterButtons.topButton.setTitleColor(UIColor.customWhite, for: .normal)
        clearTextField()
        discardSearchButtonTapped_e0Q04s()
    }
    func setupSearchBar_e0Q04() {
        seachIconImage.image = Assets.Icon.iconBlackSearch
        seachIconImage.backgroundColor = .lightGreen
        
        discardIconImage.image = Assets.Icon.iconDiscard2
        discardIconImage.backgroundColor = .lightGreen
        discardIconImage.isUserInteractionEnabled = false
        discardIconImage.isHidden = true
        
        let placeholderText = "Search".localizedUI
        let placeholderColor = UIColor.grayColor3
        let fontSize = Device.current.isPad ? 28 : 16
        let placeholderFont = Assets.Inter.regular(CGFloat(fontSize))
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: placeholderColor,
            .font: placeholderFont
        ]
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        searchTextField.font = Assets.Inter.regular(CGFloat(fontSize))
        searchTextField.textColor = .gray
        searchTextField.backgroundColor = .lightGreen
        
        searchSuggestionsTableView.backgroundColor = .lightGreen
        searchSuggestionsTableView.separatorColor = .grayColor
        searchSuggestionsTableView.register(SeacrhCell_e0Q04.self,
                                            forCellReuseIdentifier: Cell.search)
        searchSuggestionsTableView.separatorInset = .zero
        searchSuggestionsTableView.cellLayoutMarginsFollowReadableWidth = false
        
        
        containerView.backgroundColor = .lightGreen
        containerView.clipsToBounds = false
        if configs.currentDevice.isPad {
            containerView.layer.cornerRadius = 44
        }else{
            containerView.layer.cornerRadius = 23
        }
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            if configs.currentDevice.isPad {
                make.leading.trailing.equalToSuperview().inset(85)
                containerViewHeightConstraint = make.height.greaterThanOrEqualTo(42).constraint
                make.height.lessThanOrEqualTo(600) // Limit the maximum height
            }else{
                make.leading.trailing.equalToSuperview().inset(20)
                containerViewHeightConstraint = make.height.greaterThanOrEqualTo(42).constraint
                make.height.lessThanOrEqualTo(400) // Limit the maximum height
            }
        }
        view.addSubview(seachIconImage)
        seachIconImage.snp.makeConstraints { make in
            make.left.equalTo(containerView).offset(12)
            if configs.currentDevice.isPad {
                make.size.equalTo(48)
                make.top.equalTo(containerView).offset(20)
            }else{
                make.size.equalTo(24)
                make.top.equalTo(containerView).offset(11)
            }
        }
        
        view.addSubview(loadingView)
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingView.isHidden = true
        loadingView.backgroundColor = .clear
        loadingView.backgroundImageView.isHidden = true
        loadingView.backgroundView.isHidden = true
        
        view.addSubview(discardIconImage)
        discardIconImage.snp.makeConstraints { make in
            make.right.equalTo(containerView).offset(-12)
            if configs.currentDevice.isPad {
                make.top.equalTo(containerView).offset(20)
                make.size.equalTo(48)
            }else{
                make.top.equalTo(containerView).offset(11)
                make.size.equalTo(24)
            }
        }
        
        view.addSubview(loadingDownloadView)
        
        view.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(seachIconImage.snp.trailing).inset(-10)
            make.trailing.equalTo(discardIconImage.snp.leading).inset(-10)
            if configs.currentDevice.isPad {
                make.height.equalTo(80)
                make.top.equalTo(containerView).offset(4)
            }else{
                make.height.equalTo(40)
                make.top.equalTo(containerView).offset(2)
            }
        }
        
        view.addSubview(discardButtonTap)
        discardButtonTap.snp.makeConstraints { make in
            make.center.equalTo(discardIconImage)
            make.size.equalTo(30)
        }
        
        view.addSubview(line)
        line.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.bottom.equalTo(searchTextField.snp.bottom)
            if configs.currentDevice.isPad {
                make.left.equalTo(containerView.snp.left).offset(70)
                make.right.equalTo(containerView.snp.right).offset(-66)
            }else{
                make.left.equalTo(containerView.snp.left).offset(44)
                make.right.equalTo(containerView.snp.right).offset(-12)
            }
        }
        view.addSubview(completeView)
        completeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        completeView.isHidden = true
        
        
        view.addSubview(searchSuggestionsTableView)
        searchSuggestionsTableView.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom)
            if configs.currentDevice.isPad {
                make.left.equalTo(containerView.snp.left).offset(70)
                make.right.equalTo(containerView.snp.right).offset(-66)
            }else{
                make.left.equalTo(containerView.snp.left).offset(44)
                make.right.equalTo(containerView.snp.right).offset(-12)
            }
            make.bottom.equalTo(containerView.snp.bottom).offset(-4)
        }
        
        view.addSubview(loadingDownloadView)
        
        loadingDownloadView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingDownloadView.isHidden = true
        loadingDownloadView.backgroundColor = .clear
        loadingDownloadView.backgroundImageView.isHidden = true
//        loadingDownloadView.backgroundView.isHidden = true

    }
    
    func setupCollectionView_e0Q04() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EmptyCell_e0Q04.self, forCellWithReuseIdentifier: Cell.empty)
        collectionView.register(CardCell_e0Q04.self, forCellWithReuseIdentifier: Cell.card)
        collectionView.register(ModsCardCell_e0Q04.self, forCellWithReuseIdentifier: Cell.modsCard)
        collectionView.register(HacksCardCell_e0Q04.self, forCellWithReuseIdentifier: Cell.hacks)
        collectionView.register(CharactersCellCard_e0Q04.self, forCellWithReuseIdentifier: Cell.characters)
        collectionView.register(SkinCardCell_e0Q04.self, forCellWithReuseIdentifier: Cell.skins)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            if configs.currentDevice.isPad {
                make.top.equalTo(header.snp.bottom).offset(118)
                make.left.equalToSuperview().offset(65)
                make.right.equalToSuperview().offset(-65)
                make.bottom.equalToSuperview().offset(-60)
            }else{
                make.top.equalTo(header.snp.bottom).offset(68)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
    }
    
    func reloadCollectionViewData() {
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                self.collectionView.reloadData()
                // Убедитесь, что у коллекции есть разделы и элементы, чтобы избежать ошибок
                if self.collectionView.numberOfSections > 0 && self.collectionView.numberOfItems(inSection: 0) > 0 {
                    let indexPath = IndexPath(item: 0, section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
                }
            }
        }
    }
    func reloadCollectionViewDataTYPE() {
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                self.collectionView.reloadData()
            }
        }
    }
    func reloadCollectionViewDataREF() {
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                self.collectionView.reloadData()
                // Убедитесь, что у коллекции есть разделы и элементы, чтобы избежать ошибок
                if self.collectionView.numberOfSections > 0 && self.collectionView.numberOfItems(inSection: 0) > 0 {
                    let indexPath = IndexPath(item: 0, section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
                }
            }
        }
    }
    
    func setupResultsTableView() {
        searchSuggestionsTableView.dataSource = self
        searchSuggestionsTableView.delegate = self
        searchSuggestionsTableView.isHidden = true
        searchSuggestionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc func clearTextField() {
        searchTextField.text = ""
        searchTextFieldChanged(searchTextField)
        discardButtonTap.isHidden = true
        discardIconImage.isHidden = true
        view.endEditing(true)

        
    }
    @objc func clearTextFieldREF() {
        searchTextField.text = ""
        searchTextFieldChangedREF(searchTextField)
        discardButtonTap.isHidden = true
        discardIconImage.isHidden = true
    }
    func switchHeaderAndSearch(hideSearch: Bool) {
        header.isHidden = !hideSearch
        containerView.isHidden = !hideSearch
        seachIconImage.isHidden = !hideSearch
        seachIconImage.isHidden = !hideSearch
        searchTextField.isHidden = !hideSearch
        searchSuggestionsTableView.isHidden = !hideSearch
    }
    
    @objc func backButtonTapped_e0Q04() {}
    
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
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            viewController.view.frame = CGRect(x: 0, y: initialY, width: UIScreen.main.bounds.width, height: viewController.view.frame.height)
        }, completion: nil)

    }


    @objc func searchButtonTapped_e0Q04() {
        view.addSubview(blurEffectView)
        view.addSubview(filterButtons)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(discardSearchButtonTapped_e0Q04))
        blurEffectView.addGestureRecognizer(tapGesture)
        filterButtons.snp.makeConstraints { make in
            if configs.currentDevice.isPad {
                make.left.equalToSuperview().offset(85)
                make.right.equalToSuperview().offset(-85)
                make.center.equalToSuperview()
            }else{
                make.left.equalToSuperview().offset(50)
                make.right.equalToSuperview().offset(-50)
                make.center.equalToSuperview()
            }
        }
        
        filterButtons.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2) {
            self.filterButtons.transform = .identity
        }
    }
    
    func blurEffect_e0Q04() {
        view.addSubview(blurEffectView)
        view.addSubview(filterButtons)
    }
    
    @objc func discardSearchButtonTapped_e0Q04() {
        UIView.animate(withDuration: 0.2, animations: {
            self.filterButtons.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (_) in
            self.filterButtons.removeFromSuperview()
            self.blurEffectView.removeFromSuperview()
        }
    }
    func discardSearchButtonTapped_e0Q04s() {
        UIView.animate(withDuration: 0.2, animations: {
            self.filterButtons.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (_) in
            self.filterButtons.removeFromSuperview()
            self.blurEffectView.removeFromSuperview()
        }
    }
    @objc func dismissKeyboard_e0Q04() {
        view.endEditing(true)
    }
    
    func hiddenLine() {
        DispatchQueue.main.async {
            if self.searchResults.isEmpty {
                self.line.isHidden = true
            } else {
                self.line.isHidden = false
            }
        }
    }
    
    func updateContainerViewHeight() {
        DispatchQueue.main.async {
            let isPad = self.configs.currentDevice.isPad
            let rowHeight: CGFloat = isPad ? 80 : 40
            let extraHeight: CGFloat = isPad ? 80 : 40
            let maxHeight: CGFloat = isPad ? 324 : 162
            
            let numberOfRows = self.searchResults.isEmpty && !(self.searchTextField.text?.isEmpty ?? true) ? 0 : self.searchResults.count
            let totalRowsHeight = rowHeight * CGFloat(numberOfRows)
            
            let adjustedHeight = totalRowsHeight + extraHeight + (numberOfRows > 0 ? 18 : 0)
            
            print("Number of rows: \(numberOfRows), Total rows height: \(totalRowsHeight), Adjusted height: \(adjustedHeight)")
            
            let newHeight = min(adjustedHeight, maxHeight)
            
            self.containerViewHeightConstraint?.update(offset: newHeight)
            print(self.containerViewHeightConstraint as Any)
            self.view.layoutIfNeeded()
            
            self.searchSuggestionsTableView.snp.updateConstraints { make in
                let bottomHeight = isPad ? 4 : 0

                if totalRowsHeight == 0 {
                    make.bottom.equalTo(self.containerView).inset(bottomHeight)
                    self.emptySearchView.isHidden = false
                } else {
                    make.bottom.equalTo(self.containerView).inset(bottomHeight)
                    self.emptySearchView.isHidden = true
                }
            }
            
            if let searchText = self.searchTextField.text, !searchText.isEmpty {
                self.discardButtonTap.isHidden = false
                self.discardIconImage.isHidden = false
            } else {
                self.emptySearchView.isHidden = true
            }
            self.hiddenLine()

            self.view.layoutIfNeeded()
        }
    }
}

extension UICollectionViewFlowLayout {
    static var customLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 350, height: 280)
        return layout
    }
}

extension BaseSectionViewController_e0Q04: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.isEmpty && !(searchTextField.text?.isEmpty ?? true) ? 0 : searchResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.search, for: indexPath) as! SeacrhCell_e0Q04
        if indexPath.row < searchResults.count {
            cell.textLabel?.text = searchResults[indexPath.row]
            cell.selectionStyle = .none
        } else {
            print("Index out of range error: Trying to access index \(indexPath.row), but there are only \(searchResults.count) items in searchResults.")
            cell.textLabel?.text = ""
        }
        hiddenLine()

        cell.backgroundColor = .clear
        let fontSize: CGFloat = configs.currentDevice.isPad ? 28 : 16
        cell.textLabel?.font = Assets.Inter.regular(fontSize)
        cell.textLabel?.textColor = .gray
        cell.textLabel?.textAlignment = .left
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Cell tapped")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return configs.currentDevice.isPad ? 72 : 36
    }
}
extension BaseSectionViewController_e0Q04 {
    private func setupButtonActions_e0Q04() {
        header.leftButton.addTarget(self, action: #selector(backButtonTapped_e0Q04), for: .touchUpInside)
        header.rightButton.addTarget(self, action: #selector(searchButtonTapped_e0Q04), for: .touchUpInside)
        filterButtons.discardButton.addTarget(self, action: #selector(discardSearchButtonTapped_e0Q04), for: .touchUpInside)
        
        discardButtonTap.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        
        filterButtons.allButton.addTarget(self, action: #selector(allButtonTapped_e0Q04), for: .touchUpInside)
        filterButtons.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped_e0Q04), for: .touchUpInside)
        filterButtons.newButton.addTarget(self, action: #selector(newButtonTapped_e0Q04), for: .touchUpInside)
        filterButtons.topButton.addTarget(self, action: #selector(topButtonTapped_e0Q04), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard_e0Q04))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSearchContext))
        tapGesture.cancelsTouchesInView = false // Позволяет другим контролам реагировать на нажатия
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissSearchContext() {
        if searchTextField.isFirstResponder && searchTextField.text == ""{
            // Если текстовое поле не в фокусе, скрываем элементы
            discardIconImage.isHidden = true
            discardButtonTap.isHidden = true
            // Также скрывать клавиатуру, если она активна
            view.endEditing(true)
        }
    }

    
}
