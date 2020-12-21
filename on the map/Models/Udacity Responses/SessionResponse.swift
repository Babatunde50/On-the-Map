//
//  SessionResponse.swift
//  on the map
//
//  Created by Tunde Ola on 12/4/20.
//

import Foundation

struct SessionResponse: Codable {
    let account: Account
    let session: Session
}

struct SessionLogoutResponse: Codable {
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

