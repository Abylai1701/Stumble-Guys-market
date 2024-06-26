import UIKit

class GenderSelectionButton_e0Q04: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupButton()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        if Configs_e0Q04.shared.currentDevice.isPad {
            titleLabel?.font = Assets.Fredoka.bold(46)
            layer.borderWidth = 4
        }else{
            titleLabel?.font = Assets.Fredoka.bold(28)
            layer.borderWidth = 2
        }
        layer.shadowColor = UIColor.customBlack.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 2
        layer.masksToBounds = false
    }
    
    func configure(forGender gender: String) {
        setTitle(gender.uppercased(), for: .normal)
        switch gender.lowercased() {
        case "boy":
            layer.borderColor = UIColor.myGreen.cgColor
            setTitleColor(.myGreen, for: .normal)
        case "girl":
            layer.borderColor = UIColor.grayColor2.cgColor
            setTitleColor(.grayColor2, for: .normal)
        default:
            layer.borderColor = UIColor.clear.cgColor
        }
    }
}
