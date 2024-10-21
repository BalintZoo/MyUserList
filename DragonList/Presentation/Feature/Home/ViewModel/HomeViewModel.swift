//
//  MainViewModel.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 15.03.2024.
//

import Alamofire
import Foundation
import RxSwift

class HomeViewModel {
    //MARK: - Properties
    public let dragons : PublishSubject<[DragonViewData]> = PublishSubject()
    public let error : PublishSubject<DataError> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    private let getDragonListUseCase: GetDragonListUseCaseProtocol
    
    //MARK: - Init
    init(getDragonListUseCase: GetDragonListUseCaseProtocol) {
        self.getDragonListUseCase = getDragonListUseCase
    }
    
    //MARK: - Public functions
    public func requestDragonList() {
        loading.onNext(true)
        getDragonListUseCase.runCase()
            .subscribe(onNext: { [weak self] list in
                guard let self = self else { return }
                let viewDragonList = self.convertToViewData(dragonList: list)
                self.dragons.onNext(viewDragonList)
                self.loading.onNext(false)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                loading.onNext(false)
                self.error.onNext(error as? DataError ?? .generalError)
            })
        .disposed(by: disposable)
    }
    
    //MARK: - Private helper functions
    
    ///Convert the User to the ViewData. This way the UI will have only the properties that it needs
    ///also in case of changes on backend or UI side the code to modify is less
    private func convertToViewData(dragonList: [Dragon]) -> [DragonViewData] {
        return dragonList.map({ dragon in
            DragonViewData(imageUrl: URL(string: dragon.flickrImages.first ?? ""),
                           name: "\(dragon.name)",
                           details: dragon.description)
        })
    }
}
