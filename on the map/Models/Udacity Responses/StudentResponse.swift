//
//  StudentResponse.swift
//  on the map
//
//  Created by Tunde Ola on 12/6/20.
//

import Foundation

struct StudentResponse: Codable {
    let lastName: String;
    let firstName: String;
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
    }
}
