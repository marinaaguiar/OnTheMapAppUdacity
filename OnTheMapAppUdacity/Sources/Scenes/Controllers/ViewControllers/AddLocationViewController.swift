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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    //MARK: - Properties

    lazy var geocoder = CLGeocoder()
    var isValidLocation = false

    //MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        locationTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.alpha = 1
        activityIndicator.isHidden = true
    }
    //MARK: Interaction Methods

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func findOnTheMapButton(_ sender: UIButton) {

        if isValidLocation {
            let findLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "FindLocationViewController") as! FindLocationViewController
            show(findLocationViewController, sender: self)
        } else {
            Alert.showBasics(title: "Unable to search the entry location", message: "Check your internet connection", vc: self)
        }
    }

    //MARK: Methods

    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        guard let locationString = locationTextField.text else { return }

        view.alpha = 0.5
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        if let error = error {
            isValidLocation = false
            view.alpha = 1
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            Alert.showBasics(title: "Invalid location", message: "Try enter a valid location", vc: self)
            locationTextField.text = ""
            debugPrint("Unable to Forward Geocode Address (\(error))")
        } else {
            var location: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }

            if let location = location {
                isValidLocation = true
                view.alpha = 1
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
                let coordinate = location.coordinate
                UserAuthentication.Auth.longitude = coordinate.longitude
                UserAuthentication.Auth.latitude = coordinate.latitude
                debugPrint("\(coordinate.latitude), \(coordinate.longitude)")
                UserAuthentication.Auth.mapString = locationString
            } else {
                debugPrint("No Matching Location Found")
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


