//
//  MockStorages.swift
//  MyUserListTests
//
//  Created by Zoltán Bálint on 19.03.2024.
//

import Foundation
@testable import Dragons
import RxSwift

struct SuccesUsersRemoteStorage: DragonsRemoteStorage {
    func fetchDragonsFromNetwork() -> Observable<[Dragon]> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.defaultMockDelay) {
                observer.onNext(Dragon.mock())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

struct FailUsersRemoteStorage:DragonsRemoteStorage {
    func fetchDragonsFromNetwork() -> Observable<[Dragon]> {
        return Observable.create { observer -> Disposable in
            observer.onError(DataError.networkError(""))
            return Disposables.create()
        }
    }
}

struct SavedUsersInLocalStorage: DragonsLocalStorage {
                        
    func getLocalDragonList() -> Observable<[Dragon]> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.defaultMockDelay) {
                observer.onNext(Dragon.mock())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func saveDragonList(dragons: [Dragon]) {
        
    }
}

struct NoUsersInLocalStorage: DragonsLocalStorage {
                        
    func getLocalDragonList() -> Observable<[Dragon]> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.defaultMockDelay) {
                observer.onError(DataError.noLocalData)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func saveDragonList(dragons: [Dragon]) {
        
    }
}

