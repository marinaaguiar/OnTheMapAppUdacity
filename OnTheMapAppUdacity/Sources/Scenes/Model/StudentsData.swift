//
//  StudentsData.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 6/6/22.
//

import Foundation

class StudentsData {

    private init() {}
    static let shared = StudentsData()

    var students = [StudentLocation]()
}
