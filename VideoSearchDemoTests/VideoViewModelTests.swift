//
//  VideoViewModelTests.swift
//  VideoSearchDemoTests
//
//  Created by admin on 1/6/18.
//  Copyright © 2018 ntdhat. All rights reserved.
//

import XCTest
@testable import VideoSearchDemo

class VideoViewModelTests: XCTestCase {
    var myDict: NSMutableDictionary!
    var posterSizeConfig : String!
    var backdropSizeConfig : String!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        myDict = NSMutableDictionary()
        
        MovieDBClient.configurationBaseUrl = "_baseUrl_"
        MovieDBClient.configurationPosterSize = ["_posterSize_1_", "_posterSize_2_", "_posterSize_3_"]
        MovieDBClient.configurationBackdropSize = ["_bkdropSize_1_", "_bkdropSize_2_", "_bkdropSize_3_"]
        MovieDBClient.genresList = [0: "genre_1", 1: "genre_1", 2: "genre_2", 3: "genre_3", 4: "genre_4"]
        
        posterSizeConfig = MovieDBClient.configurationPosterSize.lastObject as! String
        backdropSizeConfig = MovieDBClient.configurationBackdropSize.lastObject as! String
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_CreatVideoViewModel_PerfectParam_ReturnFull() {
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
        
        let createdViewModel = VideoViewModel(createdModel)
        
        XCTAssertNotNil(createdViewModel)
        
        XCTAssertEqual(createdViewModel.posterURL, URL(string: MovieDBClient.configurationBaseUrl + posterSizeConfig + posterPath))
        XCTAssertEqual(createdViewModel.backdropURL, URL(string: MovieDBClient.configurationBaseUrl + backdropSizeConfig + backdropPath))
        
        XCTAssertEqual(createdViewModel.title, title)
        XCTAssertEqual(createdViewModel.originalTitle, orgTitle)
        XCTAssertEqual(createdViewModel.isAdult, isAdult)
        XCTAssertEqual(createdViewModel.overview, overview)
        XCTAssertEqual(createdViewModel.releaseDate, release)
        XCTAssertEqual(createdViewModel.popularity, 3.5)
        XCTAssertEqual(createdViewModel.voteAverage, 7.1)
        XCTAssertEqual(createdViewModel.voteCount, 50)
        
        XCTAssertEqual(createdViewModel.genres, ["genre_1","genre_3","genre_2"])
    }
    
    func test_CreatVideoViewModel_SomeMissingParam_ReturnObjWithSomeNilProps() {
        let backdropPath = "XYZ"
        let title = "Some Title"
        
        myDict = [MovieDBClient.JSONKey_VideoBackdropPath: backdropPath,
                  MovieDBClient.JSONKey_VideoTitle: title]
        
        let createdModel = VideoModel(from: myDict)
        
        let createdViewModel = VideoViewModel(createdModel)
        
        XCTAssertNotNil(createdViewModel)
        
        XCTAssertNil(createdViewModel.posterURL)
        XCTAssertEqual(createdViewModel.backdropURL, URL(string: MovieDBClient.configurationBaseUrl + backdropSizeConfig + backdropPath))
        
        XCTAssertEqual(createdViewModel.title, title)
        XCTAssertEqual(createdViewModel.originalTitle, "Unknown")
        
        XCTAssertTrue(createdViewModel.isAdult)
        XCTAssertEqual(createdViewModel.overview, "Not specified")
        XCTAssertEqual(createdViewModel.releaseDate, "Not specified")
        XCTAssertEqual(createdViewModel.popularity, 0.0)
        XCTAssertEqual(createdViewModel.voteAverage, 0.0)
        XCTAssertEqual(createdViewModel.voteCount, 0)
        
        XCTAssertEqual(createdViewModel.genres, [])
    }
    
    func test_CreatVideoViewModel_SomeWrongParamType_ReturnObjWithSomeNilProps() {
        let posterPath = 2
        let backdropPath = "XYZ"
        let title = 1
        let orgTitle = "Some Original Title"
        let isAdult = "false"
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
                  MovieDBClient.JSONKey_VideoVoteAverage: Bool(false),
                  MovieDBClient.JSONKey_VideoVoteCount: "50",
                  MovieDBClient.JSONKey_VideoGenreIDs: ["1","3","2"]]
        
        let createdModel = VideoModel(from: myDict)
        
        let createdViewModel = VideoViewModel(createdModel)
        
        XCTAssertNotNil(createdViewModel)
        
        XCTAssertNil(createdViewModel.posterURL)
        XCTAssertEqual(createdViewModel.backdropURL, URL(string: MovieDBClient.configurationBaseUrl + backdropSizeConfig + backdropPath))
        
        XCTAssertEqual(createdViewModel.title, "Unknown")
        XCTAssertEqual(createdViewModel.originalTitle, orgTitle)
        
        XCTAssertTrue(createdViewModel.isAdult)
        XCTAssertEqual(createdViewModel.overview, overview)
        XCTAssertEqual(createdViewModel.releaseDate, release)
        XCTAssertEqual(createdViewModel.popularity, 3.5)
        XCTAssertEqual(createdViewModel.voteAverage, 0.0)
        XCTAssertEqual(createdViewModel.voteCount, 0)
        
        XCTAssertEqual(createdViewModel.genres, [])
    }
    
    func test_CreatVideoViewModel_WrongGenreFormat_ReturnFull() {
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
                  MovieDBClient.JSONKey_VideoGenreIDs: [1,-3,200]]
        
        let createdModel = VideoModel(from: myDict)
        
        let createdViewModel = VideoViewModel(createdModel)
        
        XCTAssertNotNil(createdViewModel)
        
        XCTAssertEqual(createdViewModel.posterURL, URL(string: MovieDBClient.configurationBaseUrl + posterSizeConfig + posterPath))
        XCTAssertEqual(createdViewModel.backdropURL, URL(string: MovieDBClient.configurationBaseUrl + backdropSizeConfig + backdropPath))
        
        XCTAssertEqual(createdViewModel.title, title)
        XCTAssertEqual(createdViewModel.originalTitle, orgTitle)
        XCTAssertEqual(createdViewModel.isAdult, isAdult)
        XCTAssertEqual(createdViewModel.overview, overview)
        XCTAssertEqual(createdViewModel.releaseDate, release)
        XCTAssertEqual(createdViewModel.popularity, 3.5)
        XCTAssertEqual(createdViewModel.voteAverage, 7.1)
        XCTAssertEqual(createdViewModel.voteCount, 50)
        
        XCTAssertEqual(createdViewModel.genres, ["genre_1","Not specified","Not specified"])
    }
}
