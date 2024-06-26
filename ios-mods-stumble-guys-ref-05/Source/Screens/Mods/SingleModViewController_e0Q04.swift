import UIKit
import SnapKit

class SingleModViewController_e0Q04: BaseSingleItemViewController_e0Q04 {
    
    var viewModel: ModsViewModel_e0Q04!
    
    override func viewDidLoad() {
        header.titleLabel.text = "MODS".localizedUI
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        setupWithModItem()
    }
    
    private func setupWithModItem() {
        guard let modItem = viewModel.modItem else { return }
        titleLabel.text = modItem.title
        descriptionLabel.text = modItem.description
        if let imageUrl = URL(string: modItem.image) {
            previewImage.sd_setImage(with: imageUrl)
        }
        let favoriteImageName = viewModel.isModFavorite(modItem) ? Assets.Icon.favorite4 : Assets.Icon.favorite3
        header.rightButton.setImage(favoriteImageName, for: .normal)
    }
    @objc override func favoriteButtonTapped() {
        guard ButtonActionManager2_e0Q04adf.shared.beginAction() else { return }
        guard let modItem = viewModel.modItem else { return }
        viewModel.toggleModFavorite(modItem)
        let favoriteImageName = viewModel.isModFavorite(modItem) ? Assets.Icon.favorite4 : Assets.Icon.favorite3
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
        
        guard let modPath = viewModel.modItem?.modPath else {
            print("Mod path not available")
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

// MARK: - Mod Download Logic
extension SingleModViewController_e0Q04 {
    private func initiateDownload(for modPath: String) {
        self.loadingView.isHidden = false
        
        LocalFileHelper_e0Q04.shared.initiateDownload(for: modPath) { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingView.isHidden = true
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
