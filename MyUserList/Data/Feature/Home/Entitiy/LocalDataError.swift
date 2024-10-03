//
//  UserDataError.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 18.03.2024.
//

import Foundation

enum LocalDataError: Error, Equatable {
    case generalError
    case noLocalData
    case networkError(String)
}
