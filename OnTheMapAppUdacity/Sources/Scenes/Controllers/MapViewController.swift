//
//  MapViewController.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 5/17/22.
//

import Foundation
import UIKit

class MapViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!

    //MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: Interaction Methods

    @IBAction func addLocationButtonPressed(_ sender: Any) {


        // If the person had already added the location, SHOW the alert:

        let alert = UIAlertController(title: "", message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true)
        }))

        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { action in
            let addLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
            self.show(addLocationViewController, sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func reloadButtonPressed(_ sender: Any) {
    }

}

