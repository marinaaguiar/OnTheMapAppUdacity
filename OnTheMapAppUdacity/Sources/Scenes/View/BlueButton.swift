
import UIKit

class BlueButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()

        tintColor = .primaryBlue
        layer.shadowColor = UIColor(red: 0.008, green: 0.702, blue: 0.894, alpha: 0.53).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 1
        layer.shadowRadius = 11
        layer.masksToBounds = false
    }

}
