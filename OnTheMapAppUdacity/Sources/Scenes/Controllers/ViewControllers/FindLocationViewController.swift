//
//  FindLocationViewController.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 5/18/22.
//

import UIKit
import MapKit
import CoreLocation

class FindLocationViewController: UIViewController {

    //MARK: Properties
    var pinsArray: [CLLocationCoordinate2D] = []

    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    let pin = MKPointAnnotation()

    var results = StudentsData.shared.students
    var mediaUrl = ""

    //MARK: Outlets

    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: LightButton!

    //MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        linkTextField.delegate = self
        mapView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        centerViewInUserLocation()
        addLocationPin(firstName: UserAuthentication.Auth.firstName, lastName: UserAuthentication.Auth.firstName)
    }

    //MARK: Interaction Methods

    @IBAction func submitButtonPressed(_ sender: Any) {

        if UserAuthentication.Auth.objectId == "" && UserAuthentication.Auth.objectId == "" {
            addNewStudentLocation()
        } else {
            replaceStudentLocation()
        }
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    //MARK: Methods

    func replaceStudentLocation() {
        UserAuthentication.getUserData(completion: { (success, error) in
            UserAuthentication.putExistingStudentLocation(
                latitude: UserAuthentication.Auth.latitude,
                longitude: UserAuthentication.Auth.longitude,
                completion: { (sucess, error) in
                    self.navigationController?.popToRootViewController(animated: true)
                    self.handleLocationSessionResponse(success: success, error: error)
                })
        })
    }

    func addNewStudentLocation() {
        UserAuthentication.getUserData(completion: { (success, error) in
            UserAuthentication.postNewStudentLocation(
                latitude: UserAuthentication.Auth.latitude,
                longitude: UserAuthentication.Auth.longitude,
                completion: { (success, error) in
                    self.navigationController?.popToRootViewController(animated: true)
                    self.handleLocationSessionResponse(success: success, error: error)
                })
        })
    }

    func centerViewInUserLocation() {
        let userLocation = CLLocationCoordinate2D(latitude: UserAuthentication.Auth.latitude, longitude: UserAuthentication.Auth.longitude)
        let region = MKCoordinateRegion.init(center: userLocation, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }

    func handleLocationSessionResponse(success: Bool, error: Error?) {
        if success {
            debugPrint("🟢\(UserAuthentication.Auth.firstName)")
        } else {
            debugPrint("🔴 ERROR IS HERE >> \(error?.localizedDescription)")
        }
    }

    func addLocationPin(firstName: String?, lastName: String?) {
        guard let firstName = firstName, let lastName = lastName else { return }
        pin.title = "\(firstName) \(lastName)"
        pin.subtitle = UserAuthentication.Auth.mediaURL
        pin.coordinate = CLLocationCoordinate2D(
            latitude: UserAuthentication.Auth.latitude,
            longitude: UserAuthentication.Auth.longitude
        )
        mapView.addAnnotation(pin)
    }

    func handleSessionPostResponse(success: Bool, error: Error?) {
        if success {
            debugPrint("🟢")
        } else {
            debugPrint("🔴 ERROR IS HERE >> \(error.debugDescription)")
        }
    }

    func showAlert(title: String, message: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    debugPrint("Settings opened: \(success)") // Prints true
                })
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

    // MARK: - UITextFieldDelegate

extension FindLocationViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let mediaUrl = textField.text else { return }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        guard let urlString = textField.text else { return }
        guard let url = URL(string: urlString) else { return }

        if UIApplication.shared.canOpenURL(url) {
            mediaUrl = urlString
            UserAuthentication.Auth.mediaURL = mediaUrl
        } else {
            Alert.showBasics(title: "Invalid Link", message: "Please Try to Enter a Valid Link.", vc: self)
            textField.text = ""
        }
    }
}

    //MARK: - MKMapViewDelegate

extension FindLocationViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotation") as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "Icon-Pin")
        annotationView?.canShowCallout = true
        return annotationView
    }
}


