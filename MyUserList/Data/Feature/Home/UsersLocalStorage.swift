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
    
    private let UsersKey = "UsersKey"
    
    func getLocalUserList() -> Observable<UserResponse> {
        let decoder = JSONDecoder()
        if let usersJsonString = UserDefaults.standard.value(forKey: UsersKey) as? String,
           let data = usersJsonString.data(using: .utf8),
           let userListObject = try? decoder.decode(UserResponse.self, from: data)
        {
            return Observable.create { observer -> Disposable in
                observer.onNext(userListObject)
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
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(users) {
            let jsonString = String(data: data, encoding: .utf8)
            UserDefaults.standard.setValue(jsonString, forKey: UsersKey)
            UserDefaults.standard.synchronize()
        }
    }
}
