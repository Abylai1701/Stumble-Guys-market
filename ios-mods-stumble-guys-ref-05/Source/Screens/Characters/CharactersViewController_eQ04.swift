import UIKit
import FLAnimatedImage
import SnapKit
import SDWebImage
import DeviceKit

class CharactersViewController_eQ04: BaseSectionViewController_e0Q04 {
    
    var viewModel = CharactersViewModel()
    var isReturningFromChildViewController = false
    var emptyView = FavoriteDidNotFountView_e0Q04()
    var searchText = ""
    var textBest = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.titleLabel.text = "CHARACTERS".localizedUI
        setupCollectionViewDataSourceAndDelegate()
        viewModel.delegate = self
        setupEmptyView()
        viewModel.fetchTipsFromDropbox {
            DispatchQueue.main.async {
                self.loadingView.removeFromSuperview()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        saveFilterState()
        if !NetworkStatusMonitor_e0Q04.shared.isNetworkAvailable {
            print("No internet connection, aborting download task.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ConnectionAlertHelperWithReturn_e0Q04.shared.show()
            }
            return
        }
    }
    
    deinit {
        self.searchText = ""
        self.textBest = ""
    }
    
    private func saveFilterState() {
        if isReturningFromChildViewController {
            viewModel.updateItemsBasedOnCategory()
            
            isReturningFromChildViewController = false
            
            if viewModel.currentSortingCategory != .favorites {
                self.emptyView.isHidden = true
            }else if viewModel.currentSortingCategory == .favorites {
                if viewModel.items.isEmpty {
                    self.emptyView.isHidden = false
                }else{
                    self.emptyView.isHidden = true
                }
            }
            if let searchText = self.searchTextField.text, !searchText.isEmpty {
                self.searchTextFieldChangedType(self.searchTextField)
            }
        }
    }
    
    @objc func searchTextFieldChangedType(_ textField: UITextField) {
        viewModel.currentSortingCategory = .all
        if let searchText = textField.text, !searchText.isEmpty {
            let lowercasedSearchText = searchText.lowercased() // Convert search text to lowercase
            viewModel.filterItems(with: lowercasedSearchText) // Use the lowercase search text for filtering
            searchResults = viewModel.items.map { $0.title }
        } else {
            viewModel.filterItems(with: nil)
            searchResults = []
        }
        searchSuggestionsTableView.reloadData()
        reloadCollectionViewData()
        if let searchText = self.searchTextField.text, !searchText.isEmpty {
            self.emptyView.isHidden = true
            reloadFilter()
        }
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
        self.discardButtonTap.isHidden = false
        self.discardIconImage.isHidden = false
        
        viewModel.currentSortingCategory = .all
        searchSuggestionsTableView.isHidden = false
        reloadFilter()
        reloadCollectionViewData()
        if let searchText = self.searchTextField.text, !searchText.isEmpty {
            self.searchTextFieldChanged(self.searchTextField)
        }
    }
    
    @objc override func searchTextFieldChanged(_ textField: UITextField) {
        viewModel.currentSortingCategory = .all
        if let searchTEXT = textField.text {
            self.searchText = searchTEXT
        }
        if let searchText = textField.text, !searchText.isEmpty {
            let lowercasedSearchText = searchText.lowercased() // Convert search text to lowercase
            viewModel.filterItems(with: lowercasedSearchText) // Use the lowercase search text for filtering
            searchResults = viewModel.items.map { $0.title }
        } else {
            viewModel.filterItems(with: nil)
            searchResults = []
        }
        searchSuggestionsTableView.reloadData()
        updateContainerViewHeight()
        reloadCollectionViewData()
        if let searchText = self.searchTextField.text, !searchText.isEmpty {
            self.emptyView.isHidden = true
            reloadFilter()
        }
    }
    @objc override func searchTextFieldChangedREF(_ textField: UITextField) {
        if let searchTEXT = textField.text {
            self.searchText = searchTEXT
        }
        if let searchText = textField.text, !searchText.isEmpty {
            let lowercasedSearchText = searchText.lowercased() // Convert search text to lowercase
            viewModel.filterItems(with: lowercasedSearchText) // Use the lowercase search text for filtering
            searchResults = viewModel.items.map { $0.title }
        } else {
            viewModel.filterItems(with: nil)
            searchResults = []
        }
        searchSuggestionsTableView.reloadData()
        updateContainerViewHeight()
        if let searchText = self.searchTextField.text, !searchText.isEmpty {
            self.emptyView.isHidden = true
            reloadFilter()
        }
    }
    private func setupEmptyView() {
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
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
        emptyView.isHidden = true
    }
    private func setupCollectionViewDataSourceAndDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    @objc override func backButtonTapped_e0Q04() {
        view.endEditing(true)

        let menuVC = HomeViewController_e0Q04(selectedMenu: 4)
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
    private func configureCell(_ cell: CharactersCellCard_e0Q04, at indexPath: IndexPath) {
        let character = viewModel.items[indexPath.row]
        
        cell.titleLabel.text = character.title
        
        if let gifData = try? Data(contentsOf: Bundle.main.url(forResource: "fdsfssd", withExtension: "gif")!) {
            let animatedImage = FLAnimatedImage(animatedGIFData: gifData)
            cell.previewImage.animatedImage = animatedImage
        }
        
        if let imageUrl = URL(string: character.imagePath) {
            cell.previewImage.sd_setImage(with: imageUrl, placeholderImage: nil)
        }
    }
    
    func handleCellTap(at indexPath: IndexPath) {
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        isReturningFromChildViewController = true
        let characterItem = viewModel.items[indexPath.row]
        viewModel.tipItem = characterItem
        
        //Логика сохранения текст в поиске, но с изчезанием результатов поиска
        
        searchTextField.resignFirstResponder()
        self.textBest = searchText
        clearTextFieldREF()
        searchTextField.text = self.textBest
        DispatchQueue.main.async {
            self.discardButtonTap.isHidden = true
            self.discardIconImage.isHidden = true
        }

        let singleCharacterVC = SingleCharacterViewController_e0Q04()
        singleCharacterVC.viewModel = viewModel
        navigationController?.pushViewController(singleCharacterVC, animated: false)
    }
    
    @objc internal override func allButtonTapped_e0Q04() {
        print("All Button Tapped!")
        super.allButtonTapped_e0Q04()
        viewModel.currentSortingCategory = .all
        viewModel.updateItemsBasedOnCategory()
        reloadCollectionViewData()
        if viewModel.currentSortingCategory != .favorites {
            self.emptyView.isHidden = true
        }
    }
    
    @objc internal override func favoriteButtonTapped_e0Q04() {
        print("Favorites Button Tapped!")
        super.favoriteButtonTapped_e0Q04()
        viewModel.currentSortingCategory = .favorites
        if viewModel.currentSortingCategory == .favorites {
            viewModel.updateItemsBasedOnCategory()
            reloadCollectionViewData()
            if viewModel.items.isEmpty {
                self.emptyView.isHidden = false
            }else{
                self.emptyView.isHidden = true
            }
        }
    }
    
    @objc internal override func newButtonTapped_e0Q04() {
        print("New Button Tapped!")
        super.newButtonTapped_e0Q04()
        viewModel.currentSortingCategory = .new
        viewModel.updateItemsBasedOnCategory()
        reloadCollectionViewData()
        if viewModel.currentSortingCategory != .favorites {
            self.emptyView.isHidden = true
        }
    }
    
    @objc internal override func topButtonTapped_e0Q04() {
        print("Top Button Tapped!")
        super.topButtonTapped_e0Q04()
        viewModel.currentSortingCategory = .top
        viewModel.updateItemsBasedOnCategory()
        reloadCollectionViewData()
        if viewModel.currentSortingCategory != .favorites {
            self.emptyView.isHidden = true
        }
    }
    
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        guard ButtonActionManager2_e0Q04adf.shared.beginAction() else { return }
        let tipIndex = sender.tag
        let tip = viewModel.items[tipIndex]
        viewModel.toggleModFavorite(tip)
        viewModel.updateItemsBasedOnCategory()
        if viewModel.currentSortingCategory == .favorites {
            if viewModel.items.isEmpty {
                self.emptyView.isHidden = false
            }else{
                self.emptyView.isHidden = true
            }
        }
    }
}

extension CharactersViewController_eQ04: ViewModelDelegate {
    func itemsDidUpdate_e0Q04() {
        reloadCollectionViewDataTYPE()
        DispatchQueue.main.async {
            self.loadingScreen.hide()
        }
        if viewModel.currentSortingCategory != .favorites {
            self.emptyView.isHidden = true
        }
    }
}

extension CharactersViewController_eQ04: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.isEmpty ? 1 : viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.items.isEmpty {
            guard let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.empty, for: indexPath) as? EmptyCell_e0Q04 else {
                fatalError("Cannot create an empty cell")
            }
            emptyCell.isUserInteractionEnabled = false
            return emptyCell
        } else {
            guard let characterCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.characters, for: indexPath) as? CharactersCellCard_e0Q04 else {
                fatalError("Cannot create a new HackCell")
            }
            configureCell(characterCell, at: indexPath)
            return characterCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.items.isEmpty { return }
        handleCellTap(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return configs.currentDevice.isPad ? 24 : 16
    }
}

extension CharactersViewController_eQ04: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let contentInsets = collectionView.contentInset
        let totalContentWidth = collectionView.bounds.width - (contentInsets.left + contentInsets.right)
        let numberOfColumns: CGFloat = configs.currentDevice.isPad ? 3 : 2
        let spacingBetweenCells: CGFloat = configs.currentDevice.isPad ? 24 : 16
        let totalSpacing = spacingBetweenCells * (numberOfColumns - 1)
        let widthForItem = (totalContentWidth - totalSpacing) / numberOfColumns
        // Adjusting the height for each item
        let heightForItem: CGFloat
        let device = Device.current
        if device.isOneOf([.iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadMini6,
                           .simulator(.iPadMini), .simulator(.iPadMini2), .simulator(.iPadMini3),
                           .simulator(.iPadMini4), .simulator(.iPadMini5), .simulator(.iPadMini6)]) {
            // Specific height for iPad Mini
            heightForItem = viewModel.items.isEmpty ? 0 : 350 // Example height for iPad Mini, adjust as needed
        } else if device.isPad {
            // Height for other iPads
            heightForItem = viewModel.items.isEmpty ? 0 : 350 // Example height for other iPads, adjust as needed
        } else {
            // Height for non-iPad devices
            heightForItem = viewModel.items.isEmpty ? 0 : 247 // Example height for non-iPad devices, adjust as needed
        }
        return CGSize(width: widthForItem, height: heightForItem)
    }
}

extension CharactersViewController_eQ04 {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.emptyView.isHidden = true
        handleCellTap(at: indexPath)
    }
}
