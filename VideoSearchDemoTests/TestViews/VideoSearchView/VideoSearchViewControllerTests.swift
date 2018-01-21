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
    var sut: VideoSearchViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "VideoSearchViewController")
//        sut = vc as! VideoSearchViewController
        sut = VideoSearchViewController()
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
        let newsut = MockVideoSearchVC_CountCallsToUpdateSearchResults()
        _ = newsut.view
        
        let stubSearchVideoVM = StubSearchVideoViewModel()
        stubSearchVideoVM.expectedResult = true
        newsut.viewModel = stubSearchVideoVM
        
        let beforeCalls = newsut.callsToUpdateSearchResult
        newsut.startSearch(searchText: "Breaking")
        
        XCTAssertEqual(newsut.callsToUpdateSearchResult, beforeCalls + 1)
    }
    
    func test_FuncDisplayNoResultsIsCalledWhenNoResultReturned() {
        let newsut = MockVideoSearchVC_CountCallsToDisplayNoResults()
        _ = newsut.view
        
        let stubSearchVideoVM = StubSearchVideoViewModel()
        stubSearchVideoVM.totalResults = 0
        newsut.viewModel = stubSearchVideoVM
        
        let beforeCalls = newsut.callsToDisplayNoSearchResult
        newsut.updateSearchResults()
        
        XCTAssertEqual(newsut.callsToDisplayNoSearchResult, beforeCalls + 1)
    }
}

extension VideoSearchViewControllerTests {
    class MockVideoSearchVC_CountCallsToUpdateSearchResults: VideoSearchViewController {
        var callsToUpdateSearchResult = 0
        override func updateSearchResults() {
            callsToUpdateSearchResult += 1
        }
    }
    class MockVideoSearchVC_CountCallsToDisplayNoResults: VideoSearchViewController {
        var callsToDisplayNoSearchResult = 0
        override func displayNoSearchResult() {
            callsToDisplayNoSearchResult += 1
        }
    }
    
    class MockSearchVideoViewModel: SearchVideoViewModel {
        var searchCommandCalled = false
        var loadMoreCommandCalled = false
        override func search(for searchString: String, page: Int, completion: SearchVideoViewModel.CompletionClosure?) {
            searchCommandCalled = true
        }
        override func loadMoreSearchResults(completion: SearchVideoViewModel.CompletionClosure?) {
            loadMoreCommandCalled = true
        }
    }
    
    class StubSearchVideoViewModel: SearchVideoViewModel {
        var expectedResult = true
        override func search(for searchString: String, page: Int, completion: SearchVideoViewModel.CompletionClosure?) {
            completion?(expectedResult)
        }
    }
}
