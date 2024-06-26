//
//  LaunchScreenViewController.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 20.11.2023.
//

import UIKit
import SnapKit

class PreloaderViewController_e0Q04: UIViewController {
    
    var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Assets.Background.clouds
        return imageView
    }()
    
    var roundedView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 100
        view.layer.borderWidth = 6
        view.layer.borderColor = UIColor.clear.cgColor
        view.clipsToBounds = true  // This ensures subviews are clipped to the rounded corners

//        // Create a blur effect
//        let blurEffect = UIBlurEffect(style: .regular) // Choose .light, .extraLight, .dark, .regular, or .prominent as needed
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.alpha = 0.9 // Adjust alpha to achieve your desired blur strength (20% in your case)
//
//        view.insertSubview(blurEffectView, at: 0) // Insert the blur effect view at the bottom of the view stack
        return view
    }()
    
    var percentLabel: UILabel = {
        let label = UILabel()
        label.font = Assets.Fredoka.bold(24)
        label.textColor = .myGreen
        return label
    }()
    
    override func viewDidLoad() {
        
        func adiwQSJDwsa_e0Q04() -> Int {
            let result = Int.random(in: 1...100) + Int.random(in: 1...100)
            return result
        }
        
        super.viewDidLoad()
        setupViews_e0Q04()
        animatePercentLabel()
        setupCircleAnimation()
    }

    func setupCircleAnimation() {
        self.roundedView.layoutIfNeeded()
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: roundedView.bounds.midX, y: roundedView.bounds.midY), radius: roundedView.bounds.width / 3.3, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 1.5, clockwise: true)
        
        let backgroundCircleLayer = CAShapeLayer()
        backgroundCircleLayer.path = circlePath.cgPath
        backgroundCircleLayer.fillColor = UIColor.clear.cgColor
        backgroundCircleLayer.strokeColor = UIColor.white.cgColor
        backgroundCircleLayer.lineWidth = 8
        roundedView.layer.addSublayer(backgroundCircleLayer)
        
        let progressCircleLayer = CAShapeLayer()
        progressCircleLayer.path = circlePath.cgPath
        progressCircleLayer.fillColor = UIColor.clear.cgColor
        progressCircleLayer.strokeColor = UIColor.myGreen.cgColor
        progressCircleLayer.lineWidth = 8
        progressCircleLayer.strokeEnd = 0
        progressCircleLayer.lineCap = .round
        roundedView.layer.addSublayer(progressCircleLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        progressCircleLayer.add(animation, forKey: "progressAnim")
    }

    func animatePercentLabel() {
        var percent = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] timer in
            percent += 1
            if let label = self?.percentLabel as? UILabel {
                label.text = "\(percent)%"
            }

            if percent >= 100 {
                timer.invalidate()
            }
        }
        timer.fire()
    }
    
    func setupViews_e0Q04() {
        view.backgroundColor = .customWhite
        
        view.addSubview(backgroundImage)
        
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(roundedView)
        
        roundedView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(200)
        }
        
        view.addSubview(percentLabel)
        
        percentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
