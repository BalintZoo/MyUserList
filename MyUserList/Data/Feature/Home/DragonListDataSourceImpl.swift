//
//  UserListRemoteDataSourceImpl.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 17.03.2024.
//

import Alamofire
import RxSwift

struct DragonListDataSourceImpl: DragonListDataSourceProtocol {
    
    private let remoteStorage: DragonsRemoteStorage
    private let localStorage: DragonsLocalStorage
    
    private let disposable = DisposeBag()
    
    init(remoteStorage: DragonsRemoteStorage, localStorage: DragonsLocalStorage) {
        self.remoteStorage = remoteStorage
        self.localStorage = localStorage
    }
    
    func getDragonList() -> Observable<[Dragon]> {
        return remoteStorage.fetchDragonsFromNetwork()
            .do(onNext: { response in
                // Save fetched data to local storage if a succesful response was sent to our network request
                self.localStorage.saveDragonList(dragons: response)
            })
            .catch { error in
                // Falling back and try to obtain items from local storage in case of network failure
                return self.localStorage.getLocalDragonList()
            }
    }
}
