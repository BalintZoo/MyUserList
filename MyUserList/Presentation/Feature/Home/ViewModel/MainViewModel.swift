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
        case generalError
        case networkError(String)
    }
    
    public let users : PublishSubject<[UserViewData]> = PublishSubject()
    public let error : PublishSubject<GetUserError> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    private let disposable = DisposeBag()
    
    private let getUserListUseCase: GetUserListUseCaseProtocol
    
    init(getUserListUseCase: GetUserListUseCaseProtocol) {
        self.getUserListUseCase = getUserListUseCase
    }
    
    public func requestUserList() {
        getUserListUseCase.runUserListCase()
            .subscribe(onNext: { [weak self] userList in
                guard let self = self else {
                    return
                }
                let viewUserList = self.convertToViewData(userList: userList)
                self.users.onNext(viewUserList)
            }, onError: { [weak self] error in
                self?.error.onNext(GetUserError.networkError(error.localizedDescription))
            })
        .disposed(by: disposable)
    }
    
    func convertToViewData(userList: [User]) -> [UserViewData] {
        return userList.map({ user in
            return UserViewData(imageUrl: user.avatar,
                                fullName: "\(user.firstName) \(user.lastName)",
                                email: user.email)
        })
    }
}
