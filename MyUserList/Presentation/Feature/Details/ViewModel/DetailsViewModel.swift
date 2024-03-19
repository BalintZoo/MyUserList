//
//  DetailsViewModel.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 19.03.2024.
//

import Foundation
import RxSwift
 
class DetailsViewModel {
    
    public let user : Observable<UserViewData>
    
    init(userData: UserViewData) {
        user = Observable<UserViewData>.create({ observer -> Disposable in
            observer.onNext(userData)
            observer.onCompleted()
            return Disposables.create()
        })
    }
}
