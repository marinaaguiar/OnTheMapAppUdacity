
import Foundation
import UIKit

class LoginViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginWithFacebookButton: UIButton!

    //MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    //MARK: Interaction Methods

    @IBAction func loginButtonPressed(_ sender: Any) {

    }

    @IBAction func loginWithFacebookButtonPressed(_ sender: Any) {
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {

    }

    func setup() {
        addShadowTo(button: loginButton)
        addShadowTo(button: loginWithFacebookButton)
    }

    func addShadowTo(button: UIButton) {

//        button.tintColor = .primaryBlue
//        button.layer.shadowColor = UIColor(red: 0.008, green: 0.702, blue: 0.894, alpha: 0.53).cgColor
//        button.layer.shadowOffset = CGSize(width: 0, height: 1)
//        button.layer.shadowOpacity = 1
//        button.layer.shadowOffset = CGSize(width: 0, height: 1)
//        button.layer.shadowRadius = 11
//        button.layer.masksToBounds = false
//        button.layer.bounds = button.bounds
    }
}
