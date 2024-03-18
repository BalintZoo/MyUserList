//
//  UserList.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 15.03.2024.
//

import Foundation

import Foundation

struct UserResponse: Codable {
    let page: Int
    let perPage: Int
    let total: Int
    let totalPages: Int
    let data: [User]
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case data
    }
}

struct User: Codable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatar: URL
    
    enum CodingKeys: String, CodingKey {
            case id
            case email
            case firstName = "first_name"
            case lastName = "last_name"
            case avatar
        }
}

