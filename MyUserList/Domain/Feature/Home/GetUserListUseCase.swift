//
//  GetUserListUseCase.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 17.03.2024.
//

import Foundation
import RxSwift

protocol GetUserListUseCaseProtocol {
    func runCase() -> Observable<[User]>
}

struct GetUserListUseCase {
    // MARK: - Fields
    private let usersDataSource: UserListDataSourceProtocol

    // MARK: - Initializers
    init(usersDataSource: UserListDataSourceProtocol) {
        self.usersDataSource = usersDataSource
    }
}

// MARK: - GetUserListUseCaseProtocol implementation
extension GetUserListUseCase: GetUserListUseCaseProtocol {
    func runCase() -> Observable<[User]> {
        return usersDataSource.getUserList().map { userResponse in
            return userResponse.data.sorted(by: sortUserList)
        }
    }
    
    ///Sort user list in alphabetical order
    private func sortUserList(user1: User, user2: User) -> Bool {
        user1.firstName < user2.firstName
    }
}
