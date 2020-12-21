//
//  SessionRequest.swift
//  on the map
//
//  Created by Tunde Ola on 12/4/20.
//

import Foundation

struct SessionRequest: Codable {
    let udacity: LoginCredentials
}

struct LoginCredentials: Codable {
    let username: String
    let password: String
}
