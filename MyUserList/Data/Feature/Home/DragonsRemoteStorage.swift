//
//  Network.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 17.03.2024.
//

// Network.swift

import Alamofire
import Foundation
import RxSwift

protocol DragonsRemoteStorage {
    func fetchDragonsFromNetwork() -> Observable<[Dragon]>
}

struct DragonsRemoteStorageImpl: DragonsRemoteStorage {
    func fetchDragonsFromNetwork() -> Observable<[Dragon]> {
        return Observable.create { observer -> Disposable in
            
            let url = "https://api.spacexdata.com/v4/dragons"
            let urlRequest = URLRequest(url: URL(string: url)!)
            URLCache.shared.removeCachedResponse(for: urlRequest)

            // Using AuthInterceptor to add the Authorization header
            // AF.request(urlRequest, interceptor: AuthInterceptor())
            AF.request(urlRequest)
                .validate()
                .responseDecodable(of: [Dragon].self) { response in
                    switch response.result {
                    case .success(let dragons):
                        observer.onNext(dragons)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }

            return Disposables.create()
        }
    }
}
