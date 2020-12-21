//
//  ViewController.swift
//  on the map
//
//  Created by Tunde Ola on 12/6/20.
//

import UIKit


extension UIViewController {
    func showError(message: String, title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
