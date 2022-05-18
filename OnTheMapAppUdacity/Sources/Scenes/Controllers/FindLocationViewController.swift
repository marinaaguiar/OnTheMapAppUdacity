//
//  FindLocationViewController.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 5/18/22.
//

import UIKit

class FindLocationViewController: UIViewController {

    @IBOutlet weak var linkTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        linkTextField.delegate = self
    }

}

extension FindLocationViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

