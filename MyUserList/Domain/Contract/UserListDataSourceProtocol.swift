//
//  UserListDataSourceProtocol.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 17.03.2024.
//

import Foundation
import RxSwift

protocol UserListDataSourceProtocol {
    func getUserList() -> Observable<UserResponse>
}
