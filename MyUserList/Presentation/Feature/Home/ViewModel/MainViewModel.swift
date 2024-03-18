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
    //MARK: - Properties
    public let users : PublishSubject<[UserViewData]> = PublishSubject()
    public let error : PublishSubject<UserDataError> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    private let getUserListUseCase: GetUserListUseCaseProtocol
    
    //MARK: - Init
    init(getUserListUseCase: GetUserListUseCaseProtocol) {
        self.getUserListUseCase = getUserListUseCase
    }
    
    //MARK: - Public functions
    public func requestUserList() {
        loading.onNext(true)
        getUserListUseCase.runCase()
            .subscribe(onNext: { [weak self] userList in
                guard let self = self else { return }
                let viewUserList = self.convertToViewData(userList: userList)
                self.users.onNext(viewUserList)
                self.loading.onNext(false)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                loading.onNext(false)
                self.error.onNext(error as? UserDataError ?? .generalError)
            })
        .disposed(by: disposable)
    }
    
    //MARK: - Private helper functions
    
    ///Convert the User to the ViewData. This way the UI will have only the properties that it needs
    ///also in case of changes on backend or UI side the code to modify is less
    private func convertToViewData(userList: [User]) -> [UserViewData] {
        return userList.map({ user in
            UserViewData(imageUrl: user.avatar,
                                fullName: "\(user.firstName) \(user.lastName)",
                                email: user.email)
        })
    }
}
