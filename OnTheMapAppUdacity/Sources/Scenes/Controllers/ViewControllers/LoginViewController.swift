//
//  LViewController.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 5/24/22.
//

import Foundation
import UIKit
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit
import SafariServices

class LoginViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var loginWithFacebookButton: UIButton!

    //MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self

        if let token = AccessToken.current,
            !token.isExpired {
            presentMapViewController()
        }


        debugPrint(UserAuthentication.Endpoints.session.url)
    }

    //MARK: Interaction Methods

    @IBAction func loginButtonPressed(_ sender: Any) {
        do {
            try validateLogin()
        } catch LoginErrors.incompleteForm {
            Alert.showBasics(title: "Incomplete Form", message: "Please fill out both email and password fields", vc: self)
        } catch LoginErrors.invalidEmail {
            Alert.showBasics(title: "Invalid Email Format", message: "Please make sure you format your email correctly", vc: self)
        } catch {
            // do nothing
        }
    }

    @IBAction func loginWithFacebookButtonPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile"], from: self) { result, error in
            if let error = error {
                debugPrint("Encountered Erorr: \(error)")
            } else if let result = result, result.isCancelled {
                debugPrint("Cancelled")
            } else {
                self.presentMapViewController()
                debugPrint("Logged In")
            }
        }
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {

        guard let url = URL(string: "https://auth.udacity.com/sign-up") else {
            Alert.showBasics(title: "Error", message: "Not able to access the URL", vc: self)
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }

    func handleSessionResponse(success: Bool, error: Error?) {

        if success {
            presentMapViewController()
            debugPrint("success")
        } else if let urlError = error as? URLError, urlError.code == URLError.notConnectedToInternet {
            Alert.showBasics(title: "Network Error", message: "The Internet connection is offline, please try again later.", vc: self)
        } else {
            Alert.showBasics(title: "Invalid Credentials", message: "The credentials were incorrect, please check your email or/and your password.", vc: self)
        }
    }

    func presentMapViewController() {
        let uiTabBarViewController = storyboard?.instantiateViewController(withIdentifier: "UITabBarViewController")
        uiTabBarViewController!.modalPresentationStyle = .fullScreen
        self.present(uiTabBarViewController!, animated:true, completion:nil)
    }

    func validateLogin() throws {
        if let email = emailTextField.text, let password = passwordTextField.text {
            if email.isEmpty || password.isEmpty {
                throw LoginErrors.incompleteForm
            }
            if !email.isValidEmail {
                throw LoginErrors.invalidEmail
            } else {
                UserAuthentication.login(username: email, password: password, completion: handleSessionResponse(success:error:))
            }
        }
    }
}

//MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height - 200)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}


