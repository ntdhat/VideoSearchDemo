//
//  VideoSearchDemoTests.swift
//  VideoSearchDemoTests
//
//  Created by admin on 5/24/17.
//  Copyright © 2017 ntdhat. All rights reserved.
//

import XCTest
@testable import VideoSearchDemo

class VideoSearchDemoTests: XCTestCase {
    var videoViewModelTest : VideoViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        videoViewModelTest = nil
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
