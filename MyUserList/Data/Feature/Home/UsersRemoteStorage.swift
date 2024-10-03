//
//  Network.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 17.03.2024.
//

import Alamofire
import Foundation
import RxSwift

protocol UsersRemoteStorage {
    func fetchUsersFromNetwork() -> Observable<UserResponse>
}

struct UsersRemoteStorageImpl: UsersRemoteStorage {
    func fetchUsersFromNetwork() -> RxSwift.Observable<UserResponse> {
        return Observable.create { observer -> Disposable in
            
            //Clear default cached result as we're handling offline mode separately
            let url = "https://reqres.in/api/users?per_page=10"
            let urlRequest = URLRequest(url: URL(string: url)!)
            URLCache.shared.removeCachedResponse(for: urlRequest)

            AF.request(urlRequest)
                .validate()
                .responseDecodable(of: UserResponse.self, completionHandler: { response in
                    switch response.result {
                        case .success(let userResponse):
                            observer.onNext(userResponse)
                        case .failure(let error):
                            observer.onError(UserDataError.networkError(error.localizedDescription))
                    }
                })
            
            return Disposables.create()
        }
    }
}
