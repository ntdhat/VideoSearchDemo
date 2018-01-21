//
//  VideoModelTests.swift
//  VideoSearchDemoTests
//
//  Created by admin on 1/6/18.
//  Copyright © 2018 ntdhat. All rights reserved.
//

import XCTest
@testable import VideoSearchDemo

class VideoModelTests: XCTestCase {
    var myDict: NSMutableDictionary!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        myDict = NSMutableDictionary()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        myDict = nil
        super.tearDown()
    }
    
    func test_CreatVideoModel_WithPerfectData_ReturnFullVideoModel() {
        let posterPath = "ABC"
        let backdropPath = "XYZ"
        let title = "Some Title"
        let orgTitle = "Some Original Title"
        let isAdult = Bool(false)
        let overview = "Blah blah"
        let release = "???"
        
        myDict = [MovieDBClient.JSONKey_VideoPosterPath: posterPath,
                  MovieDBClient.JSONKey_VideoBackdropPath: backdropPath,
                  MovieDBClient.JSONKey_VideoTitle: title,
                  MovieDBClient.JSONKey_VideoOriginalTitle: orgTitle,
                  MovieDBClient.JSONKey_VideoIsAdult: isAdult,
                  MovieDBClient.JSONKey_VideoOverview: overview,
                  MovieDBClient.JSONKey_VideoReleasedDate: release,
                  MovieDBClient.JSONKey_VideoPopularity: 3.5,
                  MovieDBClient.JSONKey_VideoVoteAverage: 7.1,
                  MovieDBClient.JSONKey_VideoVoteCount: 50,
                  MovieDBClient.JSONKey_VideoGenreIDs: [1,3,2]]
        
        let createdModel = VideoModel(from: myDict)
        
        XCTAssertNotNil(createdModel)
        XCTAssertEqual(createdModel.backdropURL, backdropPath)
        XCTAssertEqual(createdModel.posterURL, posterPath)
        XCTAssertEqual(createdModel.title, title)
        XCTAssertEqual(createdModel.originalTitle, orgTitle)
        XCTAssertEqual(createdModel.isAdult, isAdult)
        XCTAssertEqual(createdModel.overview, overview)
        XCTAssertEqual(createdModel.releaseDate, release)
        XCTAssertEqual(createdModel.popularity, 3.5)
        XCTAssertEqual(createdModel.voteAverage, 7.1)
        XCTAssertEqual(createdModel.voteCount, 50)
        XCTAssertEqual(createdModel.genres!, [1,3,2])
    }
    
    func test_CreateVideoModel_WithSomeNilParam_ReturnObjWithSomeNilProperties() {
        myDict.setValue(nil, forKey: MovieDBClient.JSONKey_VideoTitle)
        myDict.setValue(nil, forKey: MovieDBClient.JSONKey_VideoPosterPath)
        myDict.setValue(nil, forKey: MovieDBClient.JSONKey_VideoReleasedDate)
        let createdModel = VideoModel(from: myDict)
        
        XCTAssertNil(createdModel.title)
        XCTAssertNil(createdModel.posterURL)
        XCTAssertNil(createdModel.releaseDate)
    }
    
    func test_CreateVideoModel_WithSomeWrongParamType_ReturnObjWithSomeNilProperties() {
        myDict.setValue(1, forKey: MovieDBClient.JSONKey_VideoTitle)
        myDict.setValue(Bool(false), forKey: MovieDBClient.JSONKey_VideoPosterPath)
        myDict.setValue(nil, forKey: MovieDBClient.JSONKey_VideoPopularity)
        let createdModel = VideoModel(from: myDict)
        
        XCTAssertNil(createdModel.title)
        XCTAssertNil(createdModel.posterURL)
        XCTAssertNil(createdModel.popularity)
    }
}
