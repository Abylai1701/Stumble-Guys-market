import UIKit
import Foundation

class SeacrhCell_e0Q04: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Установить отступ слева для текста в ячейках на минимальное значение (0)
        if let textLabel = self.textLabel {
            textLabel.frame.origin.x = 0
        }
    }
    
}
