//
//  RegisterViewController.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 5/13/22.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var firstNameTextField: Field!
    @IBOutlet weak var lastNameTextField: Field!
    @IBOutlet weak var emailTextField: Field!
    @IBOutlet weak var passwordTextField: Field!

    //MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    //MARK: Interaction Methods

    @IBAction func registerButtonPressed(_ sender: Any) {

    }

}

extension RegisterViewController: UITextFieldDelegate {

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
                self.view.frame.origin.y -= (keyboardSize.height - emailTextField.frame.height)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

