//
//  DetailsViewModel.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 19.03.2024.
//

import Foundation
import RxSwift
 
class DetailsViewModel {
    
    public let user : Observable<DragonViewData>
    
    init(userData: DragonViewData) {
        user = Observable<DragonViewData>.create({ observer -> Disposable in
            observer.onNext(userData)
            observer.onCompleted()
            return Disposables.create()
        })
    }
}
