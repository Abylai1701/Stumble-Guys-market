//
//  PreloaderViewControllerIPad.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 08.12.2023.
//

import UIKit
import SnapKit

class PreloaderViewControllerIPad_e0Q04: PreloaderViewController_e0Q04 {
    
    override func setupCircleAnimation() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.bounds.midX, y: view.bounds.midY), radius: 180, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 1.5, clockwise: true)
        
        let backgroundCircleLayer = CAShapeLayer()
        backgroundCircleLayer.path = circlePath.cgPath
        backgroundCircleLayer.fillColor = UIColor.clear.cgColor
        backgroundCircleLayer.strokeColor = UIColor.customWhite.cgColor
        backgroundCircleLayer.lineWidth = 26
        view.layer.addSublayer(backgroundCircleLayer)
        
        let progressCircleLayer = CAShapeLayer()
        progressCircleLayer.path = circlePath.cgPath
        progressCircleLayer.fillColor = UIColor.clear.cgColor
        progressCircleLayer.strokeColor = UIColor.myGreen.cgColor
        progressCircleLayer.lineWidth = 26
        progressCircleLayer.strokeEnd = 0
        progressCircleLayer.lineCap = .round
        view.layer.addSublayer(progressCircleLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        progressCircleLayer.add(animation, forKey: "progressAnim")
    }
    
    override func setupViews_e0Q04() {
        percentLabel.font = Assets.Fredoka.semiBold(44)
        
        view.backgroundColor = .customWhite
        
        view.addSubview(backgroundImage)
        
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(percentLabel)
        
        percentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
