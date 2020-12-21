//
//  FinishViewController.swift
//  on the map
//
//  Created by Tunde Ola on 12/6/20.
//

import UIKit
import CoreLocation
import MapKit

class FinishViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var coords: CLLocationCoordinate2D?
    var mediaURL: String?
    var mapString: String?

    @IBAction func submitPost(_ sender: UIButton) {
        UdacityClient.getSingleUser { [self] (studentData, error) in
            if error != nil {
                showError(message: error!.localizedDescription, title: "Error fetching user data")
                return
            }
            guard let studentData = studentData else { return }
            
            UdacityClient.createStudentLocation(body: LocationRequest(uniqueKey: UdacityClient.Auth.userId, firstName: studentData.firstName, lastName: studentData.lastName, mapString: mapString! , mediaURL: mediaURL!, latitude: coords!.latitude, longitude: coords!.longitude)) { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    showError(message: error!.localizedDescription, title: "Adding Location Failed")
                }
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapSetup()
    }

    
    func mapSetup() {
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.title = mapString
        annotation.subtitle = mediaURL
        annotation.coordinate = coords!
        mapView.addAnnotation(annotation)
        mapView.showAnnotations(mapView.annotations, animated: true)
        
    }


}
