//
//  StudentModel.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 5/26/22.
//

import Foundation

struct StudentModel: Codable {
    
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}

