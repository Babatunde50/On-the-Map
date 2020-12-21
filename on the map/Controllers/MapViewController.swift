//
//  MapViewController.swift
//  on the map
//
//  Created by Tunde Ola on 12/5/20.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let reload = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadTapped))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [add, reload]
        
        navigationItem.title = "On the Map"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: UIBarButtonItem.Style(rawValue: 1)!, target: self, action: #selector(logout))
        
        mapSetup()
            
    }
    
    func mapSetup() {
        UdacityClient.getStudentsLocation { (studentsLocation, error) in
            if error != nil {
                self.showError(message: "An error occured", title: error!.localizedDescription )
                return
            }
            guard let studentsLocation = studentsLocation else { return }
            var annotations = [MKPointAnnotation]()
            
            for studentData in studentsLocation {
                let lat = CLLocationDegrees(studentData.latitude)
                let long = CLLocationDegrees(studentData.longitude)

                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)


                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(studentData.firstName) \(studentData.lastName)"
                annotation.subtitle = studentData.mediaURL

                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            }
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
        }
    }
    
    
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }
        
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let url = URL(string: (view.annotation?.subtitle) as! String) {
                let canOpen = UIApplication.shared.canOpenURL(url)
                if canOpen {
                    UIApplication.shared.open(url) { (_) in
                        print("URL opened success")
                    }
                }
            }

        }
    }
    
    
    @objc func addTapped() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "informationVC") as! InformationPostingViewController

        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    @objc func reloadTapped() {
        mapSetup()
    }
    
    @objc func logout() {
        UdacityClient.logout { (success, error) in
            if error != nil || !success {
                self.showError(message: "An error occured", title: error!.localizedDescription )
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

