//
//  MockUserResponse.swift
//  MyUserListTests
//
//  Created by Zoltán Bálint on 18.03.2024.
//

import Foundation
@testable import MyUserList

extension UserResponse {
    static func mock() -> UserResponse {
        let userresponseJson = """
            {
                "page": 1,
                "per_page": 10,
                "total": 12,
                "total_pages": 2,
                "data": [
                    {
                        "id": 1,
                        "email": "tracey.ramos@reqres.in",
                        "first_name": "Tracey",
                        "last_name": "Ramos",
                        "avatar": "https://reqres.in/img/faces/6-image.jpg"
                    },
                    {
                        "id": 2,
                        "email": "george.bluth@reqres.in",
                        "first_name": "George",
                        "last_name": "Bluth",
                        "avatar": "https://reqres.in/img/faces/1-image.jpg"
                    },
                    {
                        "id": 3,
                        "email": "janet.weaver@reqres.in",
                        "first_name": "Janet",
                        "last_name": "Weaver",
                        "avatar": "https://reqres.in/img/faces/2-image.jpg"
                    },
                ],
            }
        """
        
        let decoder = JSONDecoder()
        let data = userresponseJson.data(using: .utf8)
        let mockUserResponse = try! decoder.decode(UserResponse.self, from: data!)
        return mockUserResponse
    }
}
