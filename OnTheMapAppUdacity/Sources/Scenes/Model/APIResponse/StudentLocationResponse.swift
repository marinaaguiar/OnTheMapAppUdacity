//
//  StudentLocationResponse.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 5/17/22.
//

import Foundation

struct StudentResults: Codable {
    let results: [StudentLocation]
}

struct StudentLocation: Codable {
    let createdAt: String?
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}

