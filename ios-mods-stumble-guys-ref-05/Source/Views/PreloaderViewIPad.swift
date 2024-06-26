import UIKit
import SnapKit

class PreloaderViewIPad: UIView {
    
    var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Assets.Background.clouds
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var roundedView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 180
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor.clear.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    var percentLabel: UILabel = {
        let label = UILabel()
        label.font = Assets.Fredoka.semiBold(44)
        label.textColor = .myGreen
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        animatePercentLabel()
        setupCircleAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        animatePercentLabel()
        setupCircleAnimation()
    }
    
    private func setupViews() {
        self.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(roundedView)
        roundedView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(360)
        }
        
        self.addSubview(percentLabel)
        percentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupCircleAnimation() {
        roundedView.layoutIfNeeded()
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: roundedView.bounds.midX, y: roundedView.bounds.midY), radius: roundedView.bounds.width / 2 - 10, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 1.5, clockwise: true)
        
        let backgroundCircleLayer = CAShapeLayer()
        backgroundCircleLayer.path = circlePath.cgPath
        backgroundCircleLayer.fillColor = UIColor.clear.cgColor
        backgroundCircleLayer.strokeColor = UIColor.white.cgColor
        backgroundCircleLayer.lineWidth = 26
        roundedView.layer.addSublayer(backgroundCircleLayer)
        
        let progressCircleLayer = CAShapeLayer()
        progressCircleLayer.path = circlePath.cgPath
        progressCircleLayer.fillColor = UIColor.clear.cgColor
        progressCircleLayer.strokeColor = UIColor.myGreen.cgColor
        progressCircleLayer.lineWidth = 26
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

    private func animatePercentLabel() {
        var percent = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] timer in
            percent += 1
            self?.percentLabel.text = "\(percent)%"
            
            if percent >= 100 {
                timer.invalidate()
            }
        }
        timer.fire()
    }
}
