//
//  MyUserListTests.swift
//  MyUserListTests
//
//  Created by Zoltán Bálint on 14.03.2024.
//

import RxSwift
import RxTest
import XCTest
@testable import Dragons

final class MainViewModelTests: XCTestCase {

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        scheduler = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testRequestUserList_Success() throws {
        let expectedUserList = Dragon.mock().map { dragon in
            DragonViewData(imageUrl: URL(string: dragon.flickrImages.first ?? ""),
                           name: "\(dragon.name)",
                           details: dragon.description)
        }
        
        let homeViewModel = HomeViewModel(getDragonListUseCase: SuccesGetDragonsUseCase())
        
        let usersObserver = scheduler.createObserver([DragonViewData].self)
        homeViewModel.users
            .bind(to: usersObserver)
            .disposed(by: disposeBag)
        
        let expectUsers = expectation(description:"users")
        
        homeViewModel.requestDragonList()
        scheduler.start()
        
        homeViewModel.users.subscribe { users in
            expectUsers.fulfill()
        }
        .disposed(by: disposeBag)
            
        wait(for: [expectUsers], timeout: TestConstants.defaultMockDelay + 1.0)
        
        XCTAssertEqual(usersObserver.events,
                       [.next(0, expectedUserList)])
    }
    
    func testRequestUserList_Fail() throws {
        let homeViewModel = HomeViewModel(getDragonListUseCase: FailGetDragonsUseCase())
        
        let errorObserver = scheduler.createObserver(LocalDataError.self)
        homeViewModel.error
            .bind(to: errorObserver)
            .disposed(by: disposeBag)
        
        let expectError = expectation(description:"error")
        
        homeViewModel.requestDragonList()
        scheduler.start()
        
        homeViewModel.error.subscribe { error in
            expectError.fulfill()
        }
        .disposed(by: disposeBag)
        
        wait(for: [expectError], timeout: TestConstants.defaultMockDelay + 1.0)
        
        XCTAssertEqual(errorObserver.events,
                       [.next(0, .generalError)])
    }
    
    func testRequestUserList_Loading() {
        let homeViewModel = HomeViewModel(getDragonListUseCase: SuccesGetDragonsUseCase())
        
        let loadingObserver = scheduler.createObserver(Bool.self)
        homeViewModel.loading
            .bind(to: loadingObserver)
            .disposed(by: disposeBag)
        
        let expectLoadingFalse = expectation(description:"loading false")
        
        homeViewModel.requestDragonList()
        scheduler.start()
        
        homeViewModel.loading.subscribe { loading in
            expectLoadingFalse.fulfill()
        }
        .disposed(by: disposeBag)

        XCTAssertTrue(loadingObserver.events.contains(.next(0, true)))
        
        wait(for: [expectLoadingFalse], timeout: TestConstants.defaultMockDelay + 1.0)
        
        XCTAssertTrue(loadingObserver.events.contains(.next(0, false))) // Assert that loading completed
    }
}
