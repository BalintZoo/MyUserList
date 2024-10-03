//
//  MockStorages.swift
//  MyUserListTests
//
//  Created by Zoltán Bálint on 19.03.2024.
//

import Foundation
@testable import MyUserList
import RxSwift

struct SuccesUsersRemoteStorage: UsersRemoteStorage {
    func fetchUsersFromNetwork() -> Observable<UserResponse> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.defaultMockDelay) {
                observer.onNext(UserResponse.mock())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

struct FailUsersRemoteStorage: UsersRemoteStorage {
    func fetchUsersFromNetwork() -> Observable<UserResponse> {
        return Observable.create { observer -> Disposable in
            observer.onError(UserDataError.networkError(""))
            return Disposables.create()
        }
    }
}

struct SavedUsersInLocalStorage: UsersLocalStorage {
                        
    func getLocalUserList() -> Observable<UserResponse> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.defaultMockDelay) {
                observer.onNext(UserResponse.mock())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func saveUserList(users: UserResponse) {
        
    }
}

struct NoUsersInLocalStorage: UsersLocalStorage {
                        
    func getLocalUserList() -> Observable<UserResponse> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.defaultMockDelay) {
                observer.onError(UserDataError.noLocalUsers)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func saveUserList(users: UserResponse) {
        
    }
}

