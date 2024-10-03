//
//  MockUserListDataSource.swift
//  MyUserListTests
//
//  Created by Zoltán Bálint on 19.03.2024.
//

import Foundation
@testable import Dragons
import RxSwift

struct SuccesDragonListDataSource: DragonListDataSourceProtocol {
    func getDragonList() -> Observable<[Dragon]> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.defaultMockDelay) {
                observer.onNext(Dragon.mock())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

struct FailDragonListDataSource: DragonListDataSourceProtocol {
    func getDragonList() -> Observable<[Dragon]> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.defaultMockDelay) {
                observer.onError(LocalDataError.noLocalData)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
