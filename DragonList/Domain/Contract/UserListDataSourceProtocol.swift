//
//  UserListDataSourceProtocol.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 17.03.2024.
//

import Foundation
import RxSwift

protocol DragonListDataSourceProtocol {
    func getDragonList() -> Observable<[Dragon]>
}
