//
//  AddLocationViewController.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 5/18/22.
//

import UIKit

class AddLocationViewController: UIViewController {

    //MARK: Outlets

    @IBOutlet weak var locationTextField: UITextField!

    //MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        locationTextField.delegate = self

    }

    //MARK: Interaction Methods

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func findOnTheMapButton(_ sender: UIButton) {
        let findLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "FindLocationViewController") as! FindLocationViewController
        show(findLocationViewController, sender: self)
    }
}

//MARK: - UITextFieldDelegate

extension AddLocationViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }

}


