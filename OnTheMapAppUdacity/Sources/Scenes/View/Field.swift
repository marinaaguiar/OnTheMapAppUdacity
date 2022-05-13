
import UIKit

class Field: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()

        setLeftPaddingPoints(12)
        setRightPaddingPoints(12)

        backgroundColor = .white
        layer.backgroundColor = UIColor(red: 0.962, green: 0.962, blue: 0.962, alpha: 1).cgColor
        layer.cornerRadius = 15


        func setLeftPaddingPoints(_ amount:CGFloat){
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        func setRightPaddingPoints(_ amount:CGFloat) {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }


    }

}
