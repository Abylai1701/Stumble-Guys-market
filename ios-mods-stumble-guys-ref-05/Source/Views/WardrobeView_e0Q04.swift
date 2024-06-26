//
//  WardrobeView.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 27.11.2023.
//

import UIKit
import SnapKit

class WardrobeView_e0Q04: UIView {
            
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGreen
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    lazy var backButtonView: BackElementView_e0Q04 = {
        let view = BackElementView_e0Q04()
        return view
    }()
    
    lazy var nextButtonView: NextElementView_e0Q04 = {
        let view = NextElementView_e0Q04()
        return view
    }()
    
    var itemCollectionViewContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var itemCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: itemCollectionViewFlowLayout)
        cv.isScrollEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        cv.clipsToBounds = true
        return cv
    }()
    
    lazy var itemCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        if Configs_e0Q04.shared.currentDevice.isPad {
            var spacing: CGFloat = 18
            var numberOfItemsInRow: CGFloat = 4
            let totalSpacing = spacing * (numberOfItemsInRow - 1)
            let itemWidth = (itemCollectionViewContainer.bounds.width - totalSpacing) / numberOfItemsInRow
            
            layout.itemSize = CGSize(width: itemWidth, height: 148)
            layout.minimumInteritemSpacing = spacing
            layout.minimumLineSpacing = spacing
        } else {
            var spacing: CGFloat = 18
            var numberOfItemsInRow: CGFloat = 4
            let totalSpacing = spacing * (numberOfItemsInRow - 1)
            let itemWidth = (itemCollectionViewContainer.bounds.width - totalSpacing) / numberOfItemsInRow
            
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: itemWidth, height: 74)
            layout.minimumInteritemSpacing = spacing
            layout.minimumLineSpacing = 20
        }
        
        return layout
    }()

    
    var boyButton: GenderSelectionButton_e0Q04 = {
        let button = GenderSelectionButton_e0Q04()
        button.configure(forGender: "Boy")
        button.layer.shadowColor = UIColor.customBlack.cgColor
        return button
    }()

    var girlButton: GenderSelectionButton_e0Q04 = {
        let button = GenderSelectionButton_e0Q04()
        button.configure(forGender: "Girl")
        button.layer.shadowColor = UIColor.customBlack.cgColor
        return button
    }()
    
    var genderSelectionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 60
        stackView.distribution = .fillEqually
        stackView.clipsToBounds = false
        return stackView
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.boyButton.layer.cornerRadius = self.boyButton.bounds.width / 2
            self.boyButton.layer.masksToBounds = false
            self.girlButton.layer.cornerRadius = self.girlButton.bounds.width / 2
            self.girlButton.layer.masksToBounds = false
        }
//        boyButton.layer.cornerRadius = boyButton.bounds.width / 2
//        boyButton.layer.masksToBounds = false
//        girlButton.layer.cornerRadius = girlButton.bounds.width / 2
//        girlButton.layer.masksToBounds = false
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews_e0Q04()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews_e0Q04() {
        addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(backButtonView)
        containerView.addSubview(nextButtonView)

        backButtonView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.size.equalTo(80)
                make.left.equalToSuperview().offset(85)
            }else{
                make.left.equalToSuperview().offset(20)
                make.size.equalTo(40)
            }
        }
        
        nextButtonView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.size.equalTo(80)
                make.right.equalToSuperview().offset(-85)
            }else{
                make.right.equalToSuperview().offset(-20)
                make.size.equalTo(40)
            }
        }
        containerView.addSubview(itemCollectionViewContainer)
        itemCollectionViewContainer.snp.makeConstraints { make in
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.top.equalTo(nextButtonView.snp.bottom).offset(24)
            }else{
                make.top.equalTo(nextButtonView.snp.bottom).offset(12)
            }
            make.left.right.bottom.equalToSuperview()
        }
        
        itemCollectionViewContainer.addSubview(itemCollectionView)
        itemCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.leading.equalToSuperview().offset(60)
                make.trailing.equalToSuperview().offset(-60)
            }else{
                make.leading.equalToSuperview().offset(0)
                make.trailing.equalToSuperview().offset(0)
            }
            
        }
        
        containerView.addSubview(boyButton)
        containerView.addSubview(girlButton)

        boyButton.snp.makeConstraints { make in
            make.top.equalTo(nextButtonView.snp.bottom).offset(12)
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.leading.equalToSuperview().inset(85)
                make.bottom.equalToSuperview().offset(-10)
                make.width.equalTo(boyButton.snp.height)
            }else{
                make.leading.equalToSuperview().inset(50)
                make.size.equalTo(UIScreen.main.bounds.height * 0.1374)
            }
        }
        boyButton.layer.cornerRadius = boyButton.bounds.height / 2 // Установка радиуса скругления

        girlButton.snp.makeConstraints { make in
            make.top.equalTo(nextButtonView.snp.bottom).offset(12)
            if Configs_e0Q04.shared.currentDevice.isPad {
                make.trailing.equalToSuperview().inset(85)
                make.bottom.equalToSuperview().offset(-10)
                make.width.equalTo(boyButton.snp.height)
            }else{
                make.trailing.equalToSuperview().inset(50)
                make.size.equalTo(UIScreen.main.bounds.height * 0.1374)
            }
        }
        girlButton.layer.cornerRadius = girlButton.bounds.height / 2 // Установка радиуса скругления

    }
}


final class VisualEffectView: UIVisualEffectView {
    private let theEffect: UIVisualEffect
    private let customIntensity: CGFloat
    private var animator: UIViewPropertyAnimator?
    /// Create visual effect view with given effect and its intensity
    ///
    /// - Parameters:
    ///   - effect: visual effect, eg UIBlurEffect(style: .dark)
    ///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
    init(style: UIBlurEffect.Style, intensity: CGFloat) {
        theEffect = UIBlurEffect(style: style)
        customIntensity = intensity
        super.init(effect: nil)
    }
    required init?(coder aDecoder: NSCoder) { nil }
    deinit {
        animator?.stopAnimation(true)
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) { [weak self] in
            self?.effect = self?.theEffect
        }
        animator?.fractionComplete = customIntensity
    }
}
