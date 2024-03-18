//
//  GetUserListUseCase.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 17.03.2024.
//

import Foundation
import RxSwift

protocol GetUserListUseCaseProtocol {
    func runUserListCase() -> Observable<[User]>
}

struct GetUserListUseCase {
    // MARK: - Fields
    private let usersDataSource: UserListDataSourceProtocol

    // MARK: - Initializers
    init(usersDataSource: UserListDataSourceProtocol) {
        self.usersDataSource = usersDataSource
    }
}

// MARK: - GetOrganizationsUseCaseProtocol
extension GetUserListUseCase: GetUserListUseCaseProtocol {
    func runUserListCase() -> Observable<[User]> {
        return usersDataSource.getUserList().map { userResponse in
            return userResponse.data.sorted { user1, user2 in
                return user1.firstName < user2.firstName
            }
        }
    }
}
