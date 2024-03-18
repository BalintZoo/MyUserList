//
//  UserListRemoteDataSourceImpl.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 17.03.2024.
//

import Alamofire
import Foundation
import RxSwift

struct UserListRemoteDataSourceImpl: UserListDataSourceProtocol {
    func getUserList() -> Observable<UserResponse> {
        
        return Observable.create { observer -> Disposable in
            AF.request("https://reqres.in/api/users?per_page=10")
                .validate()
                .responseDecodable(of: UserResponse.self, completionHandler: { response in
                    switch response.result {
                        case .success(let userResponse):
                            observer.onNext(userResponse)
                        case .failure(let userFetchError):
                            observer.onError(userFetchError)
                    }
                })
            
            return Disposables.create()
        }
    }
}
