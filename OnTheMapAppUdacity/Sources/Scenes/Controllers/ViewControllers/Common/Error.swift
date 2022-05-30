//
//  Error.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 5/24/22.
//

import Foundation

enum LoginErrors: Error {
    case incompleteForm
    case invalidEmail
    case weakPassword
    case emailAlreadyInUse
}

