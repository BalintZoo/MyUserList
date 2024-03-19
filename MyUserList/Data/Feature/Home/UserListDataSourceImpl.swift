//
//  UserListRemoteDataSourceImpl.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 17.03.2024.
//

import Alamofire
import RxSwift

struct UserListDataSourceImpl: UserListDataSourceProtocol {
    
    private let remoteStorage: UsersRemoteStorage
    private let localStorage: UsersLocalStorage
    
    private let disposable = DisposeBag()
    
    init(remoteStorage: UsersRemoteStorage, localStorage: UsersLocalStorage) {
        self.remoteStorage = remoteStorage
        self.localStorage = localStorage
    }
    
    func getUserList() -> Observable<UserResponse> {
        
        return remoteStorage.fetchUsersFromNetwork()
            .do(onNext: { userResponse in
                // Save fetched data to local storage if a succesful response was sent to our network request
                self.localStorage.saveUserList(users: userResponse)
            })
            .catch { error in
                // Falling back and try to obtain users from local storage in case of network failure
                return self.localStorage.getLocalUserList()
            }
    }
}
