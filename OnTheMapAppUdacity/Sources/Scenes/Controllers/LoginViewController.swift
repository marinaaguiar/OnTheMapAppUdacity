
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
        UserAuthentication.createSessionId(username: emailTextField.text!, password: passwordTextField.text!, completion: handleSessionResponse(success:error:))
    }

    @IBAction func loginWithFacebookButtonPressed(_ sender: Any) {
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        let registerViewController = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(registerViewController, animated:true, completion:nil)
    }

//    func handleLoginResponse(success: Bool, error: Error?) {
//        if success {
//            UserAuthentication.createSessionId(username: emailTextField.text!, password: passwordTextField.text!, completion: handleSessionResponse(success:error:))
//        } else {
//            showLoginFailure(message: error?.localizedDescription ?? "")
//        }
//    }


    func handleSessionResponse(success: Bool, error: Error?) {
        if success {
            print("success")
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }

    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}

//MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

}
