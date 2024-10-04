//
//  LocalStorage.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 17.03.2024.
//

import Foundation
import RxSwift

protocol DragonsLocalStorage {
    func getLocalDragonList() -> Observable<[Dragon]>
    func saveDragonList(dragons: [Dragon])
}

struct DragonsLocalStorageImpl: DragonsLocalStorage {
    
    static let DragonsKey = "DragonsKey"
    
    @UserDefaultStorage(key: DragonsLocalStorageImpl.DragonsKey, default: nil, store: UserDefaults.standard) var savedData: [Dragon]?
                        
    func getLocalDragonList() -> Observable<[Dragon]> {
        if let savedData {
            return Observable.create { observer -> Disposable in
                observer.onNext(savedData)
                return Disposables.create()
            }
        } else {
            return Observable.create { observer -> Disposable in
                observer.onError(DataError.noLocalData)
                return Disposables.create()
            }
        }
    }
    
    func saveDragonList(dragons: [Dragon]) {
        savedData = dragons
    }
}
