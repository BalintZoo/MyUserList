//
//  GetUserListUseCase.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 17.03.2024.
//

import Foundation
import RxSwift

protocol GetDragonListUseCaseProtocol {
    func runCase() -> Observable<[Dragon]>
}

struct GetDragonListUseCase {
    // MARK: - Fields
    private let dragonsDataSource: DragonListDataSourceProtocol

    // MARK: - Initializers
    init(dragonsDataSource: DragonListDataSourceProtocol) {
        self.dragonsDataSource = dragonsDataSource
    }
}

// MARK: - GetDragonListUseCaseProtocol implementation
extension GetDragonListUseCase: GetDragonListUseCaseProtocol {
    func runCase() -> Observable<[Dragon]> {
        return dragonsDataSource.getDragonList().map { dragons in
            return dragons.sorted(by: sortUserList)
        }
    }
    
    ///Sort user list in alphabetical order
    private func sortUserList(drg1: Dragon, drg2: Dragon) -> Bool {
        drg1.name < drg1.name
    }
}
