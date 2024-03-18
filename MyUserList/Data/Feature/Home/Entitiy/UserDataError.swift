//
//  UserDataError.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 18.03.2024.
//

import Foundation

enum UserDataError: Error {
    case generalError
    case noLocalUsers
    case networkError(String)
}
