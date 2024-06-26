import UIKit
import FLAnimatedImage
import SnapKit
import SDWebImage
import DeviceKit

class TipsViewController_e0Q04: BaseSectionViewController_e0Q04 {
    
    var viewModel = TipsViewModel_e0Q04()
    var isReturningFromChildViewController = false
    var emptyView = FavoriteDidNotFountView_e0Q04()
    var downloader = DropboxDownloader_e0Q04()
    var searchText = ""
    var textBest = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.titleLabel.text = "SKINS".localizedUI
        setupCollectionViewDataSourceAndDelegate()
        viewModel.delegate = self
        setupEmptyView()
        
        viewModel.fetchTipsFromDropbox{
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
    
    private func configureCell(_ cell: SkinCardCell_e0Q04, at indexPath: IndexPath) {
        let tip = viewModel.items[indexPath.row]
        
        if let gifData = try? Data(contentsOf: Bundle.main.url(forResource: "fdsfssd", withExtension: "gif")!) {
            let animatedImage = FLAnimatedImage(animatedGIFData: gifData)
            cell.previewImage.animatedImage = animatedImage
        }
        
        cell.titleLabel.text = tip.title
        if let imageUrl = URL(string: tip.imagePath) {
            cell.previewImage.sd_setImage(with: imageUrl, placeholderImage: nil)
        }
        
        let favoriteImageName = viewModel.isTipFavorite(tip) ? Assets.Icon.favorite2 : Assets.Icon.favorite1
        cell.favoriteButton.setImage(favoriteImageName, for: .normal)

        cell.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        cell.favoriteButton.tag = indexPath.row
        
        cell.buttonDownload.addTarget(self, action: #selector(downloadButtonTapped(_:)), for: .touchUpInside)
        cell.buttonDownload.tag = indexPath.row
        
    }
    
    func preloadImages() {
        let urls = viewModel.items.compactMap { URL(string: $0.imagePath) }
        let prefetcher = SDWebImagePrefetcher.shared
        prefetcher.prefetchURLs(urls, progress: nil) { completed, skipped in
            print("Prefetched \(completed) images, skipped \(skipped) images.")
            DispatchQueue.main.async {
                self.collectionView.reloadData() // или ваш collectionView
            }
        }
    }
    
    @objc override func backButtonTapped_e0Q04() {
        view.endEditing(true)
        let menuVC = HomeViewController_e0Q04(selectedMenu: 3)
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
    func handleCellTap(at indexPath: IndexPath) {
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        isReturningFromChildViewController = true
        let tipItem = viewModel.items[indexPath.row]
        viewModel.tipItem = tipItem
        
        searchTextField.resignFirstResponder()
        self.textBest = searchText
        clearTextFieldREF()
        searchTextField.text = self.textBest
        DispatchQueue.main.async {
            self.discardButtonTap.isHidden = true
            self.discardIconImage.isHidden = true
        }

        let singleTipVC = SingleTipViewController_e0Q04()
        singleTipVC.viewModel = viewModel
        navigationController?.pushViewController(singleTipVC, animated: false)
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

extension TipsViewController_e0Q04: ViewModelDelegate {
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

extension TipsViewController_e0Q04: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
            guard let tipCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.skins, for: indexPath) as? SkinCardCell_e0Q04 else {
                fatalError("Cannot create a new HackCell")
            }
            configureCell(tipCell, at: indexPath)
            return tipCell
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

extension TipsViewController_e0Q04: UICollectionViewDelegateFlowLayout {
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
            heightForItem = viewModel.items.isEmpty ? 0 : 400 // Example height for iPad Mini, adjust as needed
        } else if device.isPad {
            // Height for other iPads
            heightForItem = viewModel.items.isEmpty ? 0 : 400 // Example height for other iPads, adjust as needed
        } else {
            // Height for non-iPad devices
            heightForItem = viewModel.items.isEmpty ? 0 : 296 // Example height for non-iPad devices, adjust as needed
        }
        return CGSize(width: widthForItem, height: heightForItem)
    }
}

extension TipsViewController_e0Q04 {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.emptyView.isHidden = true
        handleCellTap(at: indexPath)
    }
    @objc private func downloadButtonTapped(_ sender: UIButton) {
        guard ButtonActionManager2_e0Q04adf.shared.beginAction() else { return }
        let tipIndex = sender.tag
        let imagePath = self.viewModel.items[tipIndex].imagePath
        
        if !NetworkStatusMonitor_e0Q04.shared.isNetworkAvailable {
            print("No internet connection, aborting download task.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ConnectionAlertHelperWithReturn_e0Q04.shared.show()
            }
            return
        }
        
        PhotoAccessAlertHelper_e0Q04.shared.checkPhotoLibraryAuthorization { [weak self] authorized in
            guard let self = self, authorized else {
                if !authorized {
                    DispatchQueue.main.async {
                        PhotoAccessAlertHelper_e0Q04.shared.presentPhotoAccessDeniedAlert(from: self!)
                    }
                }
                return
            }
            self.loadingDownloadView.isHidden = false
            
            // Захватывайте 'self' явно для избежания ошибки
            self.downloader.downloadImageAndSaveToPhotoAlbum(imagePath: imagePath) { [weak self] result in
                DispatchQueue.main.async {  // Обеспечиваем выполнение всех UI операций на главном потоке
                    guard let self = self else { return }
                    self.loadingDownloadView.isHidden = true  // Показываем индикатор загрузки
                    
                    switch result {
                    case .success:
                        self.completeView.isHidden = false  // Показываем "успех" view
                        
                        // Скрываем "успех" view через 2 секунды
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.completeView.isHidden = true
                        }
                    case .failure(let error):
                        print("Failed to download and save image: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
