//
//  MockUserListDataSource.swift
//  MyUserListTests
//
//  Created by Zoltán Bálint on 19.03.2024.
//

import Foundation
@testable import MyUserList
import RxSwift

struct SuccesUserListDataSource: UserListDataSourceProtocol {
    func getUserList() -> Observable<UserResponse> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.defaultMockDelay) {
                observer.onNext(UserResponse.mock())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

struct FailUserListDataSource: UserListDataSourceProtocol {
    func getUserList() -> Observable<UserResponse> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.defaultMockDelay) {
                observer.onError(UserDataError.noLocalUsers)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
