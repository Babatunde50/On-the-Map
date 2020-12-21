//
//  TableViewController.swift
//  on the map
//
//  Created by Tunde Ola on 12/5/20.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    
    var studentsLocation = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let reload = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadTapped))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [add, reload]
        
        navigationItem.title = "On the Map"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: UIBarButtonItem.Style(rawValue: 1)!, target: self, action: #selector(logout))
        tableSetup()
    }
    
    func tableSetup() {
        UdacityClient.getStudentsLocation { (studentsData, error) in
            if error != nil {
                self.showError(message: "An error occured", title: error!.localizedDescription )
                return
            }
            guard let studentsData = studentsData else { return }
            self.studentsLocation = studentsData
            self.tableView.reloadData()
        }
    }
    
    @objc func addTapped() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "informationVC") as! InformationPostingViewController

        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func reloadTapped() {
        tableSetup()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell
        
        // get the corresponding user location data
        let studentData = studentsLocation[indexPath.row]
       
       // Configure the cell’s contents.
        cell.cellNameLabel.text = studentData.firstName + " " + studentData.lastName
        cell.cellLinkLabel.text = studentData.mediaURL
        
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: studentsLocation[indexPath.row].mediaURL) else { return }
        let canOpen = UIApplication.shared.canOpenURL(url)
        if canOpen {
            UIApplication.shared.open(url) { (success) in
                print("URL opened success")
            }
        }
    }

}
