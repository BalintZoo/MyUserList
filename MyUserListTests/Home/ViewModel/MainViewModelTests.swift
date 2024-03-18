//
//  MyUserListTests.swift
//  MyUserListTests
//
//  Created by Zoltán Bálint on 14.03.2024.
//

import RxSwift
import RxTest
import XCTest
@testable import MyUserList

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
        let expectedUserList = UserResponse.mock().data.map { user in
            UserViewData(imageUrl: user.avatar,
                                fullName: "\(user.firstName) \(user.lastName)",
                                email: user.email)
        }
        
        let mainViewModel = MainViewModel(getUserListUseCase: SuccesGetUserUseCase())
        
        let usersObserver = scheduler.createObserver([UserViewData].self)
        mainViewModel.users
            .bind(to: usersObserver)
            .disposed(by: disposeBag)
        
        let expectUsers = expectation(description:"users")
        
        mainViewModel.requestUserList()
        scheduler.start()
        
        mainViewModel.users.subscribe { users in
            expectUsers.fulfill()
        }
        .disposed(by: disposeBag)
            
        wait(for: [expectUsers], timeout: TestConstants.defaultMockDelay + 1.0)
        
        XCTAssertEqual(usersObserver.events,
                       [.next(0, expectedUserList)])
    }
    
    func testRequestUserList_Fail() throws {
        let mainViewModel = MainViewModel(getUserListUseCase: FailGetUserUseCase())
        
        let errorObserver = scheduler.createObserver(UserDataError.self)
        mainViewModel.error
            .bind(to: errorObserver)
            .disposed(by: disposeBag)
        
        let expectError = expectation(description:"error")
        
        mainViewModel.requestUserList()
        scheduler.start()
        
        mainViewModel.error.subscribe { error in
            expectError.fulfill()
        }
        .disposed(by: disposeBag)
        
        wait(for: [expectError], timeout: TestConstants.defaultMockDelay + 1.0)
        
        XCTAssertEqual(errorObserver.events,
                       [.next(0, .generalError)])
    }
    
    func testRequestUserList_Loading() {
        let mainViewModel = MainViewModel(getUserListUseCase: SuccesGetUserUseCase())
        
        let loadingObserver = scheduler.createObserver(Bool.self)
        mainViewModel.loading
            .bind(to: loadingObserver)
            .disposed(by: disposeBag)
        
        let expectLoadingFalse = expectation(description:"loading false")
        
        mainViewModel.requestUserList()
        scheduler.start()
        
        mainViewModel.loading.subscribe { loading in
            expectLoadingFalse.fulfill()
        }
        .disposed(by: disposeBag)

        XCTAssertTrue(loadingObserver.events.contains(.next(0, true)))
        
        wait(for: [expectLoadingFalse], timeout: TestConstants.defaultMockDelay + 1.0)
        
        XCTAssertTrue(loadingObserver.events.contains(.next(0, false))) // Assert that loading completed
    }
}