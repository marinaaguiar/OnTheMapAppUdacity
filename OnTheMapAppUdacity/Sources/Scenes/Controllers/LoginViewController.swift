
import Foundation
import UIKit
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var loginWithFacebookButton: UIButton!

    //MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        if let token = AccessToken.current,
            !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }


        print(UserAuthentication.Endpoints.login.url)
    }

    //MARK: Interaction Methods

    @IBAction func loginButtonPressed(_ sender: Any) {

        UserAuthentication.login(username: emailTextField.text!, password: passwordTextField.text!, completion: handleSessionResponse(success:error:))
    }

    @IBAction func loginWithFacebookButtonPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile"], from: self) { result, error in
            if let error = error {
                print("Encountered Erorr: \(error)")
            } else if let result = result, result.isCancelled {
                print("Cancelled")
            } else {
                self.presentMapViewController()
                print("Logged In")
            }
        }
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        let registerViewController = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(registerViewController, animated:true, completion:nil)
    }


    func handleSessionResponse(success: Bool, error: Error?) {
        if success {

            presentMapViewController()
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

    func presentMapViewController() {
        let mapViewController = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.present(mapViewController, animated:true, completion:nil)
    }
}

extension LoginViewController: LoginButtonDelegate {

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        //
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //
    }
}


//MARK: - UITextFieldDelegate

//extension LoginViewController: UITextFieldDelegate {
//
//}
