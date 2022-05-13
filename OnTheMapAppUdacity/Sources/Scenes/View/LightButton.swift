
import UIKit

class LightButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()

        tintColor = .lightGray
        layer.shadowColor = UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 7
        layer.masksToBounds = false
    }

}
