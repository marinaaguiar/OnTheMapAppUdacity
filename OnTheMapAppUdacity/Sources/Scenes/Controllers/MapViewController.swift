//
//  MapViewController.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 5/17/22.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: Properties
    var results: [StudentLocation] = []
    var pinsArray: [MKAnnotation] = []

//    var pinsArray: [CLLocationCoordinate2D] {
//
//    }
    // MARK: Outlets

    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var reloadButton: UIBarButtonItem!

    //MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false

        UserAuthentication.getStudentsLocation { results, error in
            self.results = results
            self.populateTheMap(results: results)

        }
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

        // else
    }

    @IBAction func reloadButtonPressed(_ sender: Any) {
    }

    //MARK: Methods

    func populateTheMap(results: [StudentLocation]) {

        for index in 0..<results.count {

            let pin = MKPointAnnotation()
            pin.title = results[index].mediaURL
            pin.subtitle = "\(results[index].firstName) \(results[index].lastName)"
            pin.coordinate = CLLocationCoordinate2D(latitude: results[index].latitude, longitude: results[index].longitude)
            pinsArray.append(pin)
        }
        mapView.addAnnotations(pinsArray)
    }
}

//MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

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


