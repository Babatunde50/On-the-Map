//
//  LocationRequest.swift
//  on the map
//
//  Created by Tunde Ola on 12/6/20.
//

import Foundation

struct LocationRequest: Codable {
    let uniqueKey: String;
    let firstName: String;
    let lastName: String;
    let mapString: String;
    let mediaURL: String;
    let latitude: Double;
    let longitude: Double;
}
