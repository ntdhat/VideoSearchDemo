//
//  VideoSearchViewControllerTests.swift
//  VideoSearchDemoTests
//
//  Created by admin on 1/19/18.
//  Copyright © 2018 ntdhat. All rights reserved.
//

import XCTest
@testable import VideoSearchDemo

class VideoSearchViewControllerTests: XCTestCase {
    var sut: MockVideoSearchVC!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        sut = MockVideoSearchVC()
        _ = sut.view // Make calling sut's viewDidLoad()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        
        super.tearDown()
    }
    
    func test_SearchingCommandIsPassedToTheViewModelHandle() {
        sut.viewModel = MockSearchVideoViewModel()
        sut.startSearch(searchText: "Breaking")
        XCTAssertTrue((sut.viewModel as! MockSearchVideoViewModel).searchCommandCalled)
    }
    
    func test_LoadMoreCommandIsPassedToTheViewModelHandle() {
        sut.viewModel = MockSearchVideoViewModel()
        sut.loadMore()
        XCTAssertTrue((sut.viewModel as! MockSearchVideoViewModel).loadMoreCommandCalled)
    }
    
    func test_FuncUpdateSearchResultIsCalledWhenSearchingSuccess() {
        let stubSearchVideoVM = StubSearchVideoViewModel()
        stubSearchVideoVM.desireResult = true
        stubSearchVideoVM.output = sut
        sut.viewModel = stubSearchVideoVM

        let beforeCalls = sut.callsToUpdateSearchResult
        sut.startSearch(searchText: "Blah blah")

        XCTAssertEqual(sut.callsToUpdateSearchResult, beforeCalls + 1)
    }
}

extension VideoSearchViewControllerTests {
    class MockVideoSearchVC: VideoSearchViewController {
        var callsToUpdateSearchResult = 0
        override func updateSearchResults() {
            callsToUpdateSearchResult += 1
        }
        
    }
    
    class StubSearchVideoViewModel: SearchVideoViewModel {
        var desireResult = true
        override func search(for searchString: String, page: Int) {
            output?.didSearch(success: desireResult)
        }
    }
    
    class MockSearchVideoViewModel: SearchVideoViewModel {
        var searchCommandCalled = false
        var loadMoreCommandCalled = false
        override func search(for searchString: String, page: Int) {
            searchCommandCalled = true
        }
        override func loadMoreSearchResults() {
            loadMoreCommandCalled = true
        }
    }
}
