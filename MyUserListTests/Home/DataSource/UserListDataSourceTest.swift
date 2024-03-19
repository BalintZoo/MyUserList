//
//  UserListDataSourceTest.swift
//  MyUserListTests
//
//  Created by Zoltán Bálint on 19.03.2024.
//

import RxSwift
import XCTest
@testable import MyUserList

final class UserListDataSourceTest: XCTestCase {

    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        disposeBag = nil
        super.tearDown()
    }

    func testRemoteDataAvailable() throws {
        let expectedData = UserResponse.mock()

        let dataSource = UserListDataSourceImpl(remoteStorage: SuccesUsersRemoteStorage(), localStorage: NoUsersInLocalStorage())
        
        let observable = dataSource.getUserList()
                
        let expectation = XCTestExpectation(description: "users remote data received")
        _ = observable.subscribe(onNext: { users in
            
            XCTAssertEqual(users, expectedData)
            expectation.fulfill()
        })
                
        wait(for: [expectation], timeout: TestConstants.defaultMockDelay + 1.0)
    }
    
    func testRemoteDataNotAvailable_LocalDataAvailable() throws {
        let expectedData = UserResponse.mock()

        let dataSource = UserListDataSourceImpl(remoteStorage: FailUsersRemoteStorage(), localStorage: SavedUsersInLocalStorage())
        
        let observable = dataSource.getUserList()
                
        let expectation = XCTestExpectation(description: "users local data received")
        _ = observable.subscribe(onNext: { users in
            XCTAssertEqual(users, expectedData)
            expectation.fulfill()
        })
                
        wait(for: [expectation], timeout: TestConstants.defaultMockDelay + 1.0)
    }
    
    func testRemoteDataNotAvailable_LocalDataNotAvailable() throws {
        let dataSource = UserListDataSourceImpl(remoteStorage: FailUsersRemoteStorage(), localStorage: NoUsersInLocalStorage())
        
        let observable = dataSource.getUserList()
                
        let expectation = XCTestExpectation(description: "no data received")
        _ = observable.subscribe(onNext: { users in
            
        }, onError: { error in
            XCTAssertEqual(error as? UserDataError, .noLocalUsers)
            expectation.fulfill()
        })
                
        wait(for: [expectation], timeout: TestConstants.defaultMockDelay + 1.0)
    }
}

