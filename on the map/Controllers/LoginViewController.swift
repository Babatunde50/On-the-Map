//
//  ViewController.swift
//  on the map
//
//  Created by Tunde Ola on 12/3/20.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        emailTextField.delegate = self
//        passwordTextField.delegate = self
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        setLoggingIn(true)
        UdacityClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (success, error) in
            if success {
                self.performSegue(withIdentifier: "mapView", sender: nil)
            } else {
                self.showLoginFailure(message: error?.localizedDescription ?? "")
            }
            self.setLoggingIn(false)
        }
    }
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        setLoggingIn(true)
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        loggingIn ? loadingView.startAnimating() : loadingView.stopAnimating()
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        signUpButton.isEnabled = !loggingIn
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
}

