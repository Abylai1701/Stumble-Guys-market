//
//  EmptyCell.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 21.11.2023.
//

import UIKit
import SnapKit

class EmptyCell_e0Q04: UICollectionViewCell {
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = Assets.Fredoka.regular(18)
        label.textColor = .clear
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews_e0Q04()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews_e0Q04() {
        addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
