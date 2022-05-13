
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
    }

    //MARK: Interaction Methods

    @IBAction func loginButtonPressed(_ sender: Any) {

    }

    @IBAction func loginWithFacebookButtonPressed(_ sender: Any) {
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        let registerViewController = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(registerViewController, animated:true, completion:nil)
    }

}

//MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

}
