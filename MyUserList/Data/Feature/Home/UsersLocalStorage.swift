//
//  LocalStorage.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 17.03.2024.
//

import Foundation
import RxSwift

protocol UsersLocalStorage {
    func getLocalUserList() -> Observable<UserResponse>
    func saveUserList(users: UserResponse)
}

struct UsersLocalStorageImpl: UsersLocalStorage {
    
    static let UsersKey = "UsersKey"
    
    @UserDefaultStorage(key: UsersLocalStorageImpl.UsersKey, default: nil, store: UserDefaults.standard) var usersData: UserResponse?
                        
    func getLocalUserList() -> Observable<UserResponse> {
        if let usersData {
            return Observable.create { observer -> Disposable in
                observer.onNext(usersData)
                return Disposables.create()
            }
        } else {
            return Observable.create { observer -> Disposable in
                observer.onError(UserDataError.noLocalUsers)
                return Disposables.create()
            }
        }
    }
    
    func saveUserList(users: UserResponse) {
        usersData = users
    }
}
