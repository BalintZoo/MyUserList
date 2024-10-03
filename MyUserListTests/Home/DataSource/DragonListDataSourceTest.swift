//
//  UserListDataSourceTest.swift
//  MyUserListTests
//
//  Created by Zoltán Bálint on 19.03.2024.
//

import RxSwift
import XCTest
@testable import Dragons

final class DragonListDataSourceTest: XCTestCase {

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
        let expectedData = Dragon.mock()

        let dataSource = DragonListDataSourceImpl(remoteStorage: SuccesUsersRemoteStorage(), localStorage: NoUsersInLocalStorage())
        
        let observable = dataSource.getDragonList()
                
        let expectation = XCTestExpectation(description: "users remote data received")
        _ = observable.subscribe(onNext: { users in
            
            XCTAssertEqual(users, expectedData)
            expectation.fulfill()
        })
                
        wait(for: [expectation], timeout: TestConstants.defaultMockDelay + 1.0)
    }
    
    func testRemoteDataNotAvailable_LocalDataAvailable() throws {
        let expectedData = Dragon.mock()

        let dataSource = DragonListDataSourceImpl(remoteStorage: FailUsersRemoteStorage(), localStorage: SavedUsersInLocalStorage())
        
        let observable = dataSource.getDragonList()
                
        let expectation = XCTestExpectation(description: "users local data received")
        _ = observable.subscribe(onNext: { users in
            XCTAssertEqual(users, expectedData)
            expectation.fulfill()
        })
                
        wait(for: [expectation], timeout: TestConstants.defaultMockDelay + 1.0)
    }
    
    func testRemoteDataNotAvailable_LocalDataNotAvailable() throws {
        let dataSource = DragonListDataSourceImpl(remoteStorage: FailUsersRemoteStorage(), localStorage: NoUsersInLocalStorage())
        
        let observable = dataSource.getDragonList()
                
        let expectation = XCTestExpectation(description: "no data received")
        _ = observable.subscribe(onNext: { users in
            
        }, onError: { error in
            XCTAssertEqual(error as? LocalDataError, .noLocalData)
            expectation.fulfill()
        })
                
        wait(for: [expectation], timeout: TestConstants.defaultMockDelay + 1.0)
    }
}

