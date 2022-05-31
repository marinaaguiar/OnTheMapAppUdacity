//
//  UserData.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 5/25/22.
//

import Foundation

struct UserResponse: Codable {
    let user: User
}

struct User: Codable {
    let lastName: String
    let firstName: String


    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
    }
}
