//
//  SearchVideoViewModelTests.swift
//  VideoSearchDemoTests
//
//  Created by admin on 1/18/18.
//  Copyright © 2018 ntdhat. All rights reserved.
//

import XCTest
@testable import VideoSearchDemo
@testable import Alamofire

class SearchVideoViewModelTests: XCTestCase {
    var sut: SearchVideoViewModel!
    var sampleSearchResult: NSDictionary!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = SearchVideoViewModel()
        
        // *** Inject dependencies
        sut.output = MockSearchVideoViewModelOutput()
        
        let stubDataAccess = StubMovieDBClient()
        stubDataAccess.configurationBaseUrl = "_baseUrl_"
        stubDataAccess.configurationPosterSizes = ["_posterSize_1_", "_posterSize_2_", "_posterSize_3_"]
        stubDataAccess.configurationBackdropSizes = ["_bkdropSize_1_", "_bkdropSize_2_", "_bkdropSize_3_"]
        stubDataAccess.genresList = [0: "genre_1", 1: "genre_1", 2: "genre_2", 3: "genre_3", 4: "genre_4"]
        sut.dataAccess = stubDataAccess
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        sampleSearchResult = nil
        super.tearDown()
    }
    
    func test_Init() {
        XCTAssertNotNil(sut)
    }
    
    func test_Searching_Page0_ReturnResultPage1() {
        sut.search(for: "Breaking Bad", page: 0)
        
        XCTAssertNotEqual(self.sut.totalResults, 0)
        XCTAssertNotEqual(self.sut.totalPages, 0)
        XCTAssertEqual(self.sut.currentPage, 1)
        XCTAssertEqual(self.sut.stringQuery, "Breaking Bad")
    }

    func test_Searching_Page2_ReturnResultPage2() {
        sut.search(for: "H", page: 2)

        XCTAssertNotEqual(self.sut.totalResults, 0)
        XCTAssertNotEqual(self.sut.totalPages, 0)
        XCTAssertEqual(self.sut.currentPage, 2)
        XCTAssertEqual(self.sut.stringQuery, "H")
    }

    func test_Searching_OmitPage_ReturnResultPage1() {
        sut.search(for: "Breaking Bad")
        
        XCTAssertNotEqual(self.sut.totalResults, 0)
        XCTAssertNotEqual(self.sut.totalPages, 0)
        XCTAssertEqual(self.sut.currentPage, 1)
        XCTAssertEqual(self.sut.stringQuery, "Breaking Bad")
    }

    func test_LoadMoreSearchs() {
        sut.search(for: "Breaking Bad")
        sut.loadMoreSearchResults()
        
        XCTAssertTrue(sut.totalResults != 0)
        XCTAssertTrue(sut.totalPages != 0)
        XCTAssertTrue(sut.currentPage == 2)
        XCTAssertEqual(self.sut.stringQuery, "Breaking Bad")
    }
    
    func test_ProtocolInvokedWhenSearchingReturned() {
        (sut.output as! MockSearchVideoViewModelOutput).didSearchCalled = false
        
        sut.search(for: "Breaking Bad", page: 1)
        
        XCTAssertTrue((sut.output as! MockSearchVideoViewModelOutput).didSearchCalled)
    }
}

extension SearchVideoViewModelTests {
    class MockSearchVideoViewModelOutput: SearchVideoViewModelOutput {
        var didSearchCalled = false
        func didSearch(success: Bool) {
            didSearchCalled = true
        }
    }
    
    class StubMovieDBClient : MovieDBClient {
        override func searchMovie(parameters params: Dictionary<String, Any>, completionHanler completion: @escaping (DataResponse<Any>) -> Void) {
            let page = params["page"] as! Int
            
            // Create fake data
            var sample = NSDictionary()
            
            let testBundle = Bundle(for: type(of: self))
            let pathToSampleJSON = testBundle.path(forResource: "sampleSearchingResponse_\(page)", ofType: "json")
            
            if let sampleData = try? Data(contentsOf: URL(fileURLWithPath: pathToSampleJSON!), options: .alwaysMapped),
                let dictResult = try? JSONSerialization.jsonObject(with: sampleData, options: .mutableContainers) as! NSDictionary {
                sample = dictResult
            }

            let fakeResult = Result.success(sample as Any)
            let response = DataResponse(request: nil, response: nil, data: nil, result: fakeResult)
            
            // Invoke the callback func
            completion(response)
        }
    }
}
