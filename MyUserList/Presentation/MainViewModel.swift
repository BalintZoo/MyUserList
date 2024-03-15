//
//  MainViewModel.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 15.03.2024.
//

import Alamofire
import Foundation
import RxSwift

class MainViewModel {
    
    public enum GetUserError {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let users : PublishSubject<[UserViewData]> = PublishSubject()
    public let error : PublishSubject<GetUserError> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    private let disposable = DisposeBag()
    
    public func requestUserList() {
        
        AF.request("https://reqres.in/api/users?per_page=10").responseDecodable(of: UserResponse.self) { [weak self] response in
            switch response.result {
                case .success(let userResponse):
                    print(userResponse)
                    let usersList = userResponse.data.map { user in
                        return UserViewData(imageUrl: user.avatar,
                                            fullName: "\(user.firstName) \(user.lastName)",
                                            email: user.email)
                    }
                    self?.users.onNext(usersList)
                case .failure(let userFetchError):
                    print(userFetchError)
            }
        }
        /*
        self.loading.onNext(true)
        APIManager.requestData(url: "dcd86ebedb5e519fd7b09b79dd4e4558/raw/b7505a54339f965413f5d9feb05b67fb7d0e464e/MvvmExampleApi.json", method: .get, parameters: nil, completion: { (result) in
            self.loading.onNext(false)
            switch result {
            case .success(let returnJson) :
                let albums = returnJson["Albums"].arrayValue.compactMap {return Album(data: try! $0.rawData())}
                let tracks = returnJson["Tracks"].arrayValue.compactMap {return Track(data: try! $0.rawData())}
                self.albums.onNext(albums)
                self.tracks.onNext(tracks)
            case .failure(let failure) :
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Check your Internet connection."))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Unknown Error"))
                }
            }
        })
        */
    }
}
