//
//  SearchVideoViewModelTests.swift
//  VideoSearchDemoTests
//
//  Created by admin on 1/18/18.
//  Copyright © 2018 ntdhat. All rights reserved.
//

import XCTest
@testable import VideoSearchDemo

class SearchVideoViewModelTests: XCTestCase {
    var sut: SearchVideoViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = SearchVideoViewModel()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func test_Init() {
        XCTAssertNotNil(sut)
    }
    
    func test_AllDataIsClearedPriorToSearching() {
        sut.search(for: "Breaking Bad", completion: nil)
        
        XCTAssertEqual(sut.totalResults, 0)
        XCTAssertEqual(sut.totalPages, 0)
        XCTAssertEqual(sut.currentPage, 0)
        XCTAssertEqual(sut.stringQuery, "")
    }
    
    func test_Searching_FullParams_ReturnResultPage1() {
        let exp = expectation(description: "Search movie")
        
        sut.search(for: "Breaking Bad", page: 1) {[unowned self] isSuccess in
            XCTAssertTrue(isSuccess)
            XCTAssertNotEqual(self.sut.totalResults, 0)
            XCTAssertNotEqual(self.sut.totalPages, 0)
            XCTAssertEqual(self.sut.currentPage, 1)
            XCTAssertEqual(self.sut.stringQuery, "Breaking Bad")
            
            exp.fulfill()
        }
        
        XCTAssertEqual(sut.totalResults, 0)
        XCTAssertEqual(sut.totalPages, 0)
        XCTAssertEqual(sut.currentPage, 0)
        XCTAssertEqual(sut.stringQuery, "")
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func test_Searching_PageZero_ReturnResultPage1() {
        let exp = expectation(description: "Search movie")
        
        sut.search(for: "Breaking Bad", page: 0) {[unowned self] isSuccess in
            XCTAssertTrue(isSuccess)
            XCTAssertNotEqual(self.sut.totalResults, 0)
            XCTAssertNotEqual(self.sut.totalPages, 0)
            XCTAssertEqual(self.sut.currentPage, 1)
            XCTAssertEqual(self.sut.stringQuery, "Breaking Bad")
            
            exp.fulfill()
        }
        
        XCTAssertEqual(sut.totalResults, 0)
        XCTAssertEqual(sut.totalPages, 0)
        XCTAssertEqual(sut.currentPage, 0)
        XCTAssertEqual(sut.stringQuery, "")
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func test_Searching_PageAny_ReturnResultsForThatPage() {
        let exp = expectation(description: "Search movie")
        
        // Make a search that have a lot of results and is at any page
        sut.search(for: "H", page: 2) {[unowned self] isSuccess in
            XCTAssertTrue(isSuccess)
            XCTAssertNotEqual(self.sut.totalResults, 0)
            XCTAssertNotEqual(self.sut.totalPages, 0)
            XCTAssertEqual(self.sut.currentPage, 2) // Return the page as expected
            XCTAssertEqual(self.sut.stringQuery, "H")
            
            exp.fulfill()
        }
        
        XCTAssertEqual(sut.totalResults, 0)
        XCTAssertEqual(sut.totalPages, 0)
        XCTAssertEqual(sut.currentPage, 0)
        XCTAssertEqual(sut.stringQuery, "")
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func test_Searching_OmitPage_ReturnResultPage1() {
        let exp = expectation(description: "Search movie")
        
        sut.search(for: "Breaking Bad") {[unowned self] isSuccess in
            XCTAssertTrue(isSuccess)
            XCTAssertNotEqual(self.sut.totalResults, 0)
            XCTAssertNotEqual(self.sut.totalPages, 0)
            XCTAssertEqual(self.sut.currentPage, 1)
            XCTAssertEqual(self.sut.stringQuery, "Breaking Bad")
            
            exp.fulfill()
        }
        
        XCTAssertEqual(sut.totalResults, 0)
        XCTAssertEqual(sut.totalPages, 0)
        XCTAssertEqual(sut.currentPage, 0)
        XCTAssertEqual(sut.stringQuery, "")
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func test_LoadMoreSearchs() {
        let exp = expectation(description: "Search more for a movie")
        
        // Create sut's stub
        let sutStub = sut!
        sutStub.currentPage = 1
        sutStub.totalPages = 10
        sutStub.stringQuery = "H"
        
        sutStub.loadMoreSearchResults() { isSuccess in
            XCTAssertTrue(isSuccess)
            XCTAssertTrue(self.sut.totalResults != 0)
            XCTAssertTrue(self.sut.totalPages != 0)
            XCTAssertTrue(self.sut.currentPage == 2)
            XCTAssertTrue(self.sut.stringQuery == "H")
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
}
