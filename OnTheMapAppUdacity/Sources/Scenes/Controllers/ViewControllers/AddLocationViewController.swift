//
//  AddLocationViewController.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 5/18/22.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {

    //MARK: Outlets

    @IBOutlet weak var locationTextField: UITextField!

    //MARK: - Properties

    lazy var geocoder = CLGeocoder()

    var isValidLocation = false

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

    //MARK: Methods

    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        guard let locationString = locationTextField.text else { return }

        if let error = error {
            Alert.showBasics(title: "Invalid location", message: "Try enter a valid location", vc: self)
            print("Unable to Forward Geocode Address (\(error))")
            locationTextField.text = ""
            isValidLocation = false

        } else {
            var location: CLLocation?

            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }

            if let location = location {
                let coordinate = location.coordinate
                UserAuthentication.Auth.longitude = coordinate.longitude
                UserAuthentication.Auth.latitude = coordinate.latitude
                print("\(coordinate.latitude), \(coordinate.longitude)")
                UserAuthentication.Auth.mapString = locationString
                isValidLocation = true
            } else {
                print("No Matching Location Found")
            }
        }
    }


}

//MARK: - UITextFieldDelegate

extension AddLocationViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let location = locationTextField.text else { return }

        if location != "" {
            // Geocode Address String
            geocoder.geocodeAddressString(location) { (placemarks, error) in
                // Process Response
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
        }
    }
}


