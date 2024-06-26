import UIKit
import SnapKit
import Photos

class SingleHackViewController_e0Q04: SingleHackVC {
    
    var viewModel = HacksViewModel_e0Q04()
    private var isButtonActionInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.titleLabel.text = "HACKS".localizedUI

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        setupWithModItem()
        downloadButton.isHidden = true
    }
    
    private func setupWithModItem() {
        guard let hackItem = viewModel.hackItem else { return }
        titleLabel.text = hackItem.title
        descriptionLabel.text = hackItem.description
        if let imageUrl = URL(string: hackItem.imagePath) {
            previewImage.sd_setImage(with: imageUrl)
        }
        let favoriteImageName = viewModel.isHackFavorite(hackItem) ? Assets.Icon.favorite4 : Assets.Icon.favorite3
        header.rightButton.setImage(favoriteImageName, for: .normal)
    }
    @objc override func favoriteButtonTapped() {
        guard ButtonActionManager2_e0Q04adf.shared.beginAction() else { return }
        guard let hackItem = viewModel.hackItem else { return }
        viewModel.toggleModFavorite(hackItem)
        let favoriteImageName = viewModel.isHackFavorite(hackItem) ? Assets.Icon.favorite4 : Assets.Icon.favorite3
        header.rightButton.setImage(favoriteImageName, for: .normal)
    }
}
