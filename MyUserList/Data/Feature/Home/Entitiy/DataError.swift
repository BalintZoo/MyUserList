//
//  UserDataError.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 18.03.2024.
//

import Foundation

enum DataError: Error, Equatable {
    case generalError
    case noLocalData
    case networkError(String)
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .generalError:
            return NSLocalizedString("general_error", comment: "A general error occurred")
        case .networkError(let errorMessage):
            return errorMessage
        case .noLocalData:
            return NSLocalizedString("no_local_data", comment: "No local data available")
        }
    }
}
