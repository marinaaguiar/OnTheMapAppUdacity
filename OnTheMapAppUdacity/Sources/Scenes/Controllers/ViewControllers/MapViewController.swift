//
//  MapViewController.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 5/17/22.
//

import Foundation
import UIKit
import MapKit
import SafariServices
import FacebookLogin
import FBSDKLoginKit

class OTMPointAnnotation: MKPointAnnotation {
    var identifier: String

    init(identifier: String) {
        self.identifier = identifier
    }
}

class MapViewController: UIViewController {

    // MARK: Properties
    var results = StudentsData.shared.students
    var pinsArray: [MKAnnotation] = []

    // MARK: Outlets

    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    //MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        tabBarController?.tabBar.isHidden = false
        isLoading(true)
        mapView.removeAnnotations(pinsArray)
        pinsArray.removeAll()
        UserAuthentication.getStudentsLocation { [self] results, error in

            if let error = error {
                Alert.showBasics(title: "Failed to load data", message: "\(error.localizedDescription)", vc: self)
            }

            if let results = results {
                self.results = results
                self.populateTheMap(results: results)
            }

            self.isLoading(false)
        }
    }

    //MARK: Interaction Methods

    @IBAction func addLocationButtonPressed(_ sender: Any) {

        if UserAuthentication.Auth.latitude == 0.0 && UserAuthentication.Auth.longitude == 0.0 {
            let addLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
            self.show(addLocationViewController, sender: self)
        } else {
            presentAlert()
        }
    }

    @IBAction func logOutButtonPressed(_ sender: Any) {

        if let token = AccessToken.current {
            let loginManager = LoginManager()
            loginManager.logOut()
        } else {
            UserAuthentication.logout(completion: handleSessionResponse(success:error:))
        }
    }

    //MARK: Methods

    func handleSessionResponse(success: Bool, error: Error?) {
        if success {
            dismiss(animated: true)
        } else {
            Alert.showBasics(title: "Logout Failed", message: "\(error?.localizedDescription)", vc: self)
        }
        isLoading(false)
    }

    func presentAlert() {
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

    func populateTheMap(results: [StudentLocation]) {

        for index in 0..<results.count {
            let pin = OTMPointAnnotation(identifier: results[index].objectId)
            pin.title = "\(results[index].firstName) \(results[index].lastName)"
            pin.subtitle = results[index].mediaURL
            pin.coordinate = CLLocationCoordinate2D(latitude: results[index].latitude, longitude: results[index].longitude)
            pinsArray.append(pin)
        }
            mapView.addAnnotations(pinsArray)
    }

    func isLoading(_ status: Bool) {
        if status {
            activityIndicator.startAnimating()
            mapView.alpha = 0.5
            activityIndicator.isHidden = false
        } else {
            mapView.alpha = 1
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
}

//MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard
            let annotation = view.annotation as? OTMPointAnnotation,
            let result = results.first(where: { $0.objectId == annotation.identifier }),
            let url = URL(string: result.mediaURL)
        else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        } else {
            Alert.showBasics(title: "Invalid url", message: "", vc: self)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotation") as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.canShowCallout = true

        let detailButton = UIButton(type: .detailDisclosure)
        annotationView?.rightCalloutAccessoryView = detailButton
        annotationView?.image = UIImage(named: "Icon-Pin")
        return annotationView
    }
}


