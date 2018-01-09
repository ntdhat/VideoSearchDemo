//
//  MovieDBClientTests.swift
//  VideoSearchDemoTests
//
//  Created by admin on 1/6/18.
//  Copyright © 2018 ntdhat. All rights reserved.
//

import XCTest
@testable import VideoSearchDemo

class MovieDBClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_SearchMovie_FullParams_Successful() {
        let parameters: Dictionary<String, Any> = ["language" : "en-US",
                                                   "page" : 1,
                                                   "query" : "Breaking Bad"]
        searchMovie(parameters)
    }

    func test_SearchMovie_ADifferentLanguage_Successful() {
        let parameters: Dictionary<String, Any> = ["language" : "fr",
                                                   "page" : 1,
                                                   "query" : "Breaking Bad"]
        searchMovie(parameters)
    }

    func test_SearchMovie_ADifferentPageAndLongResultQuery_Successfull() {
        let parameters: Dictionary<String, Any> = ["language" : "en-US",
                                                   "page" : 2,
                                                   "query" : "B"]
        searchMovie(parameters)
    }

    func test_SearchMovie_MissingParams_Successfull() {
        let parameters: Dictionary<String, Any> = ["query" : "B"]
        searchMovie(parameters)
    }

    func test_SearchMovie_EmptyQueryParams_Successfull() {
        let parameters: Dictionary<String, Any> = ["language" : "en-US",
                                                   "page" : 1,
                                                   "query" : ""]
        searchMovie(parameters)
    }

    func test_SearchMovie_WrongParamFormat_Success() {
        let parameters: Dictionary<String, Any> = ["language" : 1,
                                                   "page" : "1",
                                                   "query" : 2]
        searchMovie(parameters, needFail: true)
    }

    func searchMovie(_ param: Dictionary<String, Any>, needFail: Bool = false) {
        let exp = expectation(description: "Search movie")
        MovieDBClient.searchMovie(parameters: param, completionHanler: { response in
            if let error = response.error {
                XCTFail("Search movie failed. Error: \(error.localizedDescription)")
            }

            exp.fulfill()
        })

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func test_LoadConfigs_Successful() {
        let exp = expectation(description: "Load configs")
        MovieDBClient.loadConfiguration() { error in
            if let error = error {
                XCTFail("Load configs failed. Error: \(error.localizedDescription)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            
            XCTAssertNotNil(MovieDBClient.configurationBaseUrl)
            XCTAssertNotNil(MovieDBClient.configurationBackdropSize)
            XCTAssertNotNil(MovieDBClient.configurationPosterSize)
        }
    }
    
    func test_LoadGenres_Successful() {
        let exp = expectation(description: "Load genres")
        MovieDBClient.loadGenresList() { error in
            if let error = error {
                XCTFail("Load genres failed. Error: \(error.localizedDescription)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
}
