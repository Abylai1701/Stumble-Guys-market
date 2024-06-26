import UIKit
import SnapKit
import SDWebImage
import DeviceKit
import FLAnimatedImage

class ModsViewController_e0Q04: BaseSectionViewController_e0Q04 {
    
    var viewModel = ModsViewModel_e0Q04()
    var isReturningFromChildViewController = false
    var emptyView = FavoriteDidNotFountView_e0Q04()
    var searchText = ""
    var textBest = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        header.titleLabel.text = "MODS".localizedUI
        setupCollectionViewDataSourceAndDelegate()
        setupEmptyView()
        viewModel.delegate = self
        
        if self.configs.isAppFirstLaunch {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.preloaderView.removeFromSuperview()
            }
            viewModel.fetchModsFromDropbox {}
        }else{
            viewModel.fetchModsFromDropbox {
                DispatchQueue.main.async {
                    self.loadingView.removeFromSuperview()
                }
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
    
    @objc override func backButtonTapped_e0Q04() {
        view.endEditing(true)

        let menuVC = HomeViewController_e0Q04(selectedMenu: 1)
        menuVC.popAction = {
            let vc = self
            vc.removeFromParent()
            vc.view.removeFromSuperview()
            print("ModsController удалился(")
        }
        menuVC.tapAction = {
            self.blurEffectMenu.removeFromSuperview()
        }
        presentViewControllerFromBottom(menuVC)
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
//        emptyView.mainView.layer.cornerRadius
        emptyView.isHidden = true
    }
    private func setupCollectionViewDataSourceAndDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configureCell(_ cell: ModsCardCell_e0Q04, at indexPath: IndexPath) {
        let mod = viewModel.items[indexPath.row]
        
        cell.titleLabel.text = mod.title
        cell.descriptionLabel.text = mod.description
        
        if let gifData = try? Data(contentsOf: Bundle.main.url(forResource: "fdsfssd", withExtension: "gif")!) {
            let animatedImage = FLAnimatedImage(animatedGIFData: gifData)
            cell.previewImage.animatedImage = animatedImage
        }
        
        if let imageUrl = URL(string: mod.image) {
            cell.previewImage.sd_setImage(with: imageUrl, placeholderImage: nil)
        }
        
        let favoriteImageName = viewModel.isModFavorite(mod) ? Assets.Icon.favorite2 : Assets.Icon.favorite1
        cell.favoriteButton.setImage(favoriteImageName, for: .normal)
        
        cell.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        cell.favoriteButton.tag = indexPath.row
        
        cell.downloadButton.addTarget(self, action: #selector(downloadButtonTapped(_:)), for: .touchUpInside)
        cell.downloadButton.tag = indexPath.row
    }
    
    
    func preloadImages() {
        let urls = viewModel.items.compactMap { URL(string: $0.image) }
        let prefetcher = SDWebImagePrefetcher.shared
        prefetcher.prefetchURLs(urls, progress: nil) { completed, skipped in
            print("Prefetched \(completed) images, skipped \(skipped) images.")
            DispatchQueue.main.async {
                self.collectionView.reloadData() // или ваш collectionView
            }
        }
    }

    open func handleCellTap(at indexPath: IndexPath) {
        guard ButtonActionManager_e0Q04.shared.beginAction() else { return }
        isReturningFromChildViewController = true
        let modItem = viewModel.items[indexPath.row]
        viewModel.modItem = modItem
        
        //Логика сохранения текст в поиске, но с изчезанием результатов поиска
        
        searchTextField.resignFirstResponder()
        self.textBest = searchText
        clearTextFieldREF()
        searchTextField.text = self.textBest
        DispatchQueue.main.async {
            self.discardButtonTap.isHidden = true
            self.discardIconImage.isHidden = true
        }

        let singleModVC = SingleModViewController_e0Q04()
        singleModVC.viewModel = viewModel
        navigationController?.pushViewController(singleModVC, animated: false)
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
        let modIndex = sender.tag
        let mod = viewModel.items[modIndex]
        viewModel.toggleModFavorite(mod)
        viewModel.updateItemsBasedOnCategory()
        if viewModel.currentSortingCategory == .favorites {
            if viewModel.items.isEmpty {
                self.emptyView.isHidden = false
            }else{
                self.emptyView.isHidden = true
            }
        }
    }
    
    @objc private func downloadButtonTapped(_ sender: UIButton) {
        guard ButtonActionManager2_e0Q04adf.shared.beginAction() else { return }
        let modIndex = sender.tag
        let modPath = viewModel.items[modIndex].modPath
        
        if !NetworkStatusMonitor_e0Q04.shared.isNetworkAvailable {
            print("No internet connection, aborting download task.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ConnectionAlertHelperWithReturn_e0Q04.shared.show()
            }
            return
        }
        
        if let localFileURL = LocalFileHelper_e0Q04.shared.localFileURL(for: modPath) {
            print("Checking for file at local URL: \(localFileURL.path)")
            if FileManager.default.fileExists(atPath: localFileURL.path) {
                print("File already exists, no need to download.")
                presentShareSheet(for: localFileURL)
            } else {
                print("File does not exist, initiating download.")
                initiateDownload(for: modPath)
            }
        } else {
            print("Could not construct local file URL.")
        }
        
    }
}
extension ModsViewController_e0Q04 {
    private func initiateDownload(for modPath: String) {
        self.loadingDownloadView.isHidden = false

        LocalFileHelper_e0Q04.shared.initiateDownload(for: modPath) { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingDownloadView.isHidden = true
            }
            
            switch result {
            case .success(let fileURL):
                print("File downloaded to: \(fileURL.path)")
                DispatchQueue.main.async {
                    self?.handleDownloadSuccess(with: fileURL)
                }
            case .failure(let error):
                print("Failed to download file: \(error.localizedDescription)")
            }
        }
    }

    private func handleDownloadSuccess(with fileURL: URL) {
        print("Handle download success, local file path: \(fileURL.path)")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            print("Confirmation: The file has been saved correctly.")
            
                self.completeView.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.presentShareSheet(for: fileURL)
                self.completeView.isHidden = true
            }
        } else {
            print("Error: The file was not saved correctly.")
        }
    }

    private func handleDownloadError(_ error: Error) {
        ConnectivityScreenHelper_e0Q04.shared.show()
    }

    private func presentShareSheet(for fileURL: URL) {
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)

        if configs.currentDevice.isPad {
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = self.view  // указываем view, от которой должен появиться поповер
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // можно указать точное место
            }
            self.present(activityViewController, animated: true, completion: nil)
        }else{
            present(activityViewController, animated: true)
        }
    }
}
extension ModsViewController_e0Q04: ViewModelDelegate {
    func itemsDidUpdate_e0Q04() {
        print("itemsDidUpdate is called")
        reloadCollectionViewDataTYPE()
        DispatchQueue.main.async {
            self.loadingScreen.hide()
        }
        if viewModel.currentSortingCategory != .favorites {
            self.emptyView.isHidden = true
        }
    }
}

extension ModsViewController_e0Q04: UICollectionViewDataSource, UICollectionViewDelegate {
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
            guard let modCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.modsCard, for: indexPath) as? ModsCardCell_e0Q04 else {
                fatalError("Cannot create a new ModCell")
            }
            configureCell(modCell, at: indexPath)
            return modCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.items.isEmpty {
            return
        }
        handleCellTap(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return configs.currentDevice.isPad ? 24 : 16
    }
}

extension ModsViewController_e0Q04: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let contentInsets = collectionView.contentInset
        let totalContentWidth = collectionView.bounds.width - (contentInsets.left + contentInsets.right)

        // Adjusting the number of columns based on the device type
        let numberOfColumns: CGFloat = configs.currentDevice.isPad ? 2 : 1 // 2 columns for iPad, 1 for others

        // Adjusting the width for each item
        let spacingBetweenCells: CGFloat = configs.currentDevice.isPad ? 24 : 16 // Spacing between cells
        let totalSpacing = spacingBetweenCells * (numberOfColumns - 1)
        let widthForItem = (totalContentWidth - totalSpacing) / numberOfColumns

        // Adjusting the height for each item
        let heightForItem: CGFloat
        let device = Device.current
        if device.isOneOf([.iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadMini6,
                           .simulator(.iPadMini), .simulator(.iPadMini2), .simulator(.iPadMini3),
                           .simulator(.iPadMini4), .simulator(.iPadMini5), .simulator(.iPadMini6)]) {
            // Specific height for iPad Mini
            heightForItem = viewModel.items.isEmpty ? 574 : 320 // Example height for iPad Mini, adjust as needed
        } else if device.isPad {
            // Height for other iPads
            heightForItem = viewModel.items.isEmpty ? 574 : 320 // Example height for other iPads, adjust as needed
        } else {
            // Height for non-iPad devices
            heightForItem = viewModel.items.isEmpty ? 574 : 280 // Example height for non-iPad devices, adjust as needed
        }

        return CGSize(width: widthForItem, height: heightForItem)
    }
}

extension ModsViewController_e0Q04 {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.emptyView.isHidden = true
        handleCellTap(at: indexPath)
    }
}
