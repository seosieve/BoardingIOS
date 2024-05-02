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
    func test_splashViewModelTest() {
        //given
        let input = [3,3,1]
        
        //when
        let result = sut.test(input: input)
        
        //then
        XCTAssertEqual(result, 7)
    }
}


