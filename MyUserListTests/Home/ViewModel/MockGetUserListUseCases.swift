//
//  MockHomeUseCase.swift
//  MyUserListTests
//
//  Created by Zoltán Bálint on 18.03.2024.
//

import Foundation
import RxSwift
@testable import MyUserList

struct SuccesGetUserUseCase: GetUserListUseCaseProtocol {
    func runCase() -> Observable<[User]> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.defaultMockDelay) {
                observer.onNext(UserResponse.mock().data)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

struct FailGetUserUseCase: GetUserListUseCaseProtocol {
    func runCase() -> Observable<[User]> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.defaultMockDelay) {
                observer.onError(UserDataError.generalError)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
