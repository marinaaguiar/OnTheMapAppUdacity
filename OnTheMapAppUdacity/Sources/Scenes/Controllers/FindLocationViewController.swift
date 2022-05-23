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

    //MARK: Outlets

    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: LightButton!

    //MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        linkTextField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkLocationServices()
    }

    //MARK: Interaction Methods

    @IBAction func submitButtonPressed(_ sender: Any) {
        addLocationPin()
        // ADD INFORMATIONS TO [STUDENTELOCATION]
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    //MARK: Methods

//    func createNewLocation() {
//        let newStudentLocation = StudentLocation(
//            createdAt: "",
//            firstName: "", // I need to insert the first name of the student session
//            lastName: "",  // I need to insert the last name of the student session
//            latitude: mapView.centerCoordinate.latitude,
//            longitude: mapView.centerCoordinate.longitude,
//            mapString: "",
//            mediaURL: linkTextField.text!,
//            objectId: "",
//            uniqueKey: "",
//            updatedAt: "")
//
//    }
//
//
//    class func addNewStudentLocation(objectId: String, latitude: String, longitude: String, completion: @escaping (Bool, Error?) -> Void) {
//        let body = StudentLocation(createdAt: <#T##String?#>, firstName: <#T##String#>, lastName: <#T##String#>, latitude: <#T##Double#>, longitude: <#T##Double#>, mapString: <#T##String#>, mediaURL: <#T##String#>, objectId: <#T##String#>, uniqueKey: <#T##String#>, updatedAt: <#T##String#>)
//
//        MarkFavorite(mediaType: "movie", mediaId: movieId, favorite: favorite)
//        taskForPOSTRequest(url: Endpoints.markFavorite.url, responseType: TMDBResponse.self, body: body) { response, error in
//            if let response = response {
//                completion(response.statusCode == 1 || response.statusCode == 12 || response.statusCode == 13, nil)
//            } else {
//                completion(false, nil)
//            }
//        }
//    }


    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            showAlert(title: "Allow Location Services", message: "Turn on Location Services in Settings > Privacy to allow 'On The Map' to determine your current location")
        }
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewInUserLocation()
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showAlert(title: "Allow Location Services", message: "Turn on Location Services in \n Settings > Privacy to allow \n \"On The Map\" to determine your current location")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            print("authorizedAlways")
        @unknown default:
            print("unkown")
        }
    }

    func centerViewInUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }

    func addLocationPin() {
        pin.title = linkTextField.text
        pin.subtitle = "First Name Last Name"
        pin.coordinate = CLLocationCoordinate2D(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        mapView.addAnnotation(pin)
        mapView.delegate = self
    }

    func showAlert(title: String, message: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

    //MARK: - MKMapViewDelegate

extension FindLocationViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotation") as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "Icon-Pin")
        return annotationView
    }

}

//MARK: - CLLocationManagerDelegate

extension FindLocationViewController: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
