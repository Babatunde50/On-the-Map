//
//  InformationPostingViewController.swift
//  on the map
//
//  Created by Tunde Ola on 12/5/20.
//

import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var imageView: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var submitButton: UIButton!
    
    var cordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        linkTextField.delegate = self
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "tabView")

        controller!.modalPresentationStyle = .fullScreen
        self.present(controller!, animated: true, completion: nil)
    }
    
    @IBAction func cancelView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func postInfo(_ sender: UIButton) {
        let location = locationTextField.text!
        let link = linkTextField.text!
        
        setLoading(true)
        getCoordinate(addressString: location) { (coords, error) in
            if error != nil {
                self.showError(message: "Error Geocoding your location", title: "Geocoding Fail")
                self.setLoading(false)
                return
            }
            
            if link.isEmpty {
                self.showError(message: "Please provide a link", title: "Empty Link")
                self.setLoading(false)
                return
            }
            
            self.cordinates = coords
            self.setLoading(false)
            
            self.performSegue(withIdentifier: "finishView", sender: self)
            
        }
        
        
    }
    
    func getCoordinate( addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finishView" {
            let FVController = segue.destination as! FinishViewController
            FVController.coords = self.cordinates
            FVController.mediaURL = linkTextField.text
            FVController.mapString = locationTextField.text
        }
    }
    
    func setLoading(_ loggingIn: Bool) {
        if loggingIn {
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
        }
        linkTextField.isEnabled = !loggingIn
        locationTextField.isEnabled = !loggingIn
        submitButton.isEnabled = !loggingIn
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    

}
