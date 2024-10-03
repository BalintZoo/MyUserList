//
//  MockHomeUseCase.swift
//  MyUserListTests
//
//  Created by Zoltán Bálint on 18.03.2024.
//

import Foundation
import RxSwift
@testable import Dragons

struct SuccesGetDragonsUseCase: GetDragonListUseCaseProtocol {
    func runCase() -> Observable<[Dragon]> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.defaultMockDelay) {
                observer.onNext(Dragon.mock())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

struct FailGetDragonsUseCase: GetDragonListUseCaseProtocol {
    func runCase() -> Observable<[Dragon]> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.defaultMockDelay) {
                observer.onError(LocalDataError.generalError)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
