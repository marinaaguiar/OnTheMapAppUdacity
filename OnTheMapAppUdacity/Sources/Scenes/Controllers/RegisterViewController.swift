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
    }

    //MARK: Interaction Methods

    @IBAction func registerButtonPressed(_ sender: Any) {

    }
}
