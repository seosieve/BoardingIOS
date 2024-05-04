//
//  defaultBoardingTests.swift
//  defaultBoardingTests
//
//  Created by 서충원 on 5/2/24.
//

import XCTest
@testable import 여행의_시작_Boarding

class defaultBoardingTests: XCTestCase {
    var sut: SplashViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = SplashViewModel()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    //test키워드를 붙혀야 동작
    func test_splashViewModelTest1() {
        //given
        let hitNumber = 10
        sut.randomValue = 4
        
        //when
        let result = sut.compareValue(with: hitNumber)
        
        //then
        XCTAssertEqual(result, .Down)
    }
    
    func test_splashViewModelTest2() {
        //given
        let hitNumber = 10
        sut.randomValue = 9
        
        //when
        let result = sut.compareValue(with: hitNumber)
        
        //then
        XCTAssertEqual(result, .Down)
    }
    
    func test_splashViewModelTest3() {
        //given
        let promise = expectation(description: "It makes random value")
        sut.randomValue = 50
        
        //when
        sut.makeRandomValue {
            //then
            XCTAssertGreaterThanOrEqual(self.sut.randomValue, 0)
            XCTAssertLessThanOrEqual(self.sut.randomValue, 30)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 10)//wait
    }
}


