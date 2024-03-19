//
//  GetUserListUseCaseTests.swift
//  MyUserListTests
//
//  Created by Zoltán Bálint on 19.03.2024.
//

import RxSwift
import XCTest
@testable import MyUserList

final class GetUserListUseCaseTests: XCTestCase {

    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        disposeBag = nil
        super.tearDown()
    }

    func testGetUserListUseCase_Succes() throws {
        let expectedUsers = UserResponse.mock().data.sorted { $0.firstName < $1.firstName }

        let usecase = GetUserListUseCase(usersDataSource: SuccesUserListDataSource())
        let observable = usecase.runCase()
                
        let expectation = XCTestExpectation(description: "user list received")
        _ = observable.subscribe(onNext: { userList in
            
            XCTAssertEqual(userList, expectedUsers)
            expectation.fulfill()
        })
                
        wait(for: [expectation], timeout: TestConstants.defaultMockDelay + 1.0)
    }
    
    func testGetUserListUseCase_Fail() throws {
        let usecase = GetUserListUseCase(usersDataSource: FailUserListDataSource())
        
        let observable = usecase.runCase()
                
        let expectation = XCTestExpectation(description: "error reveived")
        _ = observable.subscribe(onNext: { userList in
            
        }, onError: { error in
            XCTAssertEqual(error as? UserDataError, UserDataError.noLocalUsers)
            expectation.fulfill()
        })
                
        wait(for: [expectation], timeout: TestConstants.defaultMockDelay + 1.0)
    }
}
