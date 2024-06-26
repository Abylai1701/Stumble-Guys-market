import UIKit
import SnapKit

class SingleTipViewController_e0Q04: BaseSingleController {
    
    var viewModel = TipsViewModel_e0Q04()

    override func viewDidLoad() {
        super.viewDidLoad()
        header.titleLabel.text = "SKINS".localizedUI
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        setupWithModItem()
    }
    
    private func setupWithModItem() {
        guard let tipItem = viewModel.tipItem else { return }
        titleLabel.text = tipItem.title
        descriptionLabel.text = tipItem.description
        if let imageUrl = URL(string: tipItem.imagePath) {
            previewImage.sd_setImage(with: imageUrl)
        }
        let favoriteImageName = viewModel.isTipFavorite(tipItem) ? Assets.Icon.favorite4 : Assets.Icon.favorite3
        header.rightButton.setImage(favoriteImageName, for: .normal)
    }
    
    // Image download logic, was removed due to PM requirments
    @objc override func favoriteButtonTapped() {
        guard ButtonActionManager2_e0Q04adf.shared.beginAction() else { return }
        guard let tipItem = viewModel.tipItem else { return }
        viewModel.toggleModFavorite(tipItem)
        let favoriteImageName = viewModel.isTipFavorite(tipItem) ? Assets.Icon.favorite4 : Assets.Icon.favorite3
        header.rightButton.setImage(favoriteImageName, for: .normal)
    }
    @objc override func downloadButtonTapped_e0Q04() {
        print("Download button tapped")

        if !NetworkStatusMonitor_e0Q04.shared.isNetworkAvailable {
            print("No internet connection, aborting download task.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ConnectionAlertHelperWithReturn_e0Q04.shared.show()
            }
            return
        }
        
        PhotoAccessAlertHelper_e0Q04.shared.checkPhotoLibraryAuthorization { [weak self] authorized in
            guard let self = self, authorized, let imagePath = self.viewModel.tipItem?.imagePath else {
                if !authorized {
                    DispatchQueue.main.async {
                        PhotoAccessAlertHelper_e0Q04.shared.presentPhotoAccessDeniedAlert(from: self!)
                    }
                }
                return
            }
            self.loadingView.isHidden = false
            
            // Захватывайте 'self' явно для избежания ошибки
            self.downloader.downloadImageAndSaveToPhotoAlbum(imagePath: imagePath) { [weak self] result in
                DispatchQueue.main.async {  // Обеспечиваем выполнение всех UI операций на главном потоке
                    guard let self = self else { return }
                    self.loadingView.isHidden = true  // Показываем индикатор загрузки
                    
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
