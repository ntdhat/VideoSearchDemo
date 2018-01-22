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
    var stubDataAccess: MovieDBClient!
    var posterSizeConfig : String!
    var backdropSizeConfig : String!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        /** Read file for tests
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "abbaData", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        */
        
        myDict = NSMutableDictionary()
        
        stubDataAccess = MovieDBClient()
        stubDataAccess.configurationBaseUrl = "_baseUrl_"
        stubDataAccess.configurationPosterSizes = ["_posterSize_1_", "_posterSize_2_", "_posterSize_3_"]
        stubDataAccess.configurationBackdropSizes = ["_bkdropSize_1_", "_bkdropSize_2_", "_bkdropSize_3_"]
        stubDataAccess.genresList = [0: "genre_1", 1: "genre_1", 2: "genre_2", 3: "genre_3", 4: "genre_4"]
        
        posterSizeConfig = stubDataAccess.configurationPosterSizes.lastObject as! String
        backdropSizeConfig = stubDataAccess.configurationBackdropSizes.lastObject as! String
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        myDict = nil
        super.tearDown()
    }
    
    func test_Init_FromPerfectModel_ReturnFull() {
        let posterPath = "ABC"
        let backdropPath = "XYZ"
        let title = "Some Title"
        let orgTitle = "Some Original Title"
        let isAdult = Bool(false)
        let overview = "Blah blah"
        let release = "???"
        
        myDict = [MovieDBKeys.VideoPosterPath: posterPath,
                  MovieDBKeys.VideoBackdropPath: backdropPath,
                  MovieDBKeys.VideoTitle: title,
                  MovieDBKeys.VideoOriginalTitle: orgTitle,
                  MovieDBKeys.VideoIsAdult: isAdult,
                  MovieDBKeys.VideoOverview: overview,
                  MovieDBKeys.VideoReleasedDate: release,
                  MovieDBKeys.VideoPopularity: 3.5,
                  MovieDBKeys.VideoVoteAverage: 7.1,
                  MovieDBKeys.VideoVoteCount: 50,
                  MovieDBKeys.VideoGenreIDs: [1,3,2]]
        
        let createdModel = VideoModel(from: myDict)
        
        let createdViewModel = VideoViewModel(model: createdModel, dataAccess: stubDataAccess)
        
        XCTAssertNotNil(createdViewModel)
        
        XCTAssertEqual(createdViewModel.posterURL, URL(string: stubDataAccess.configurationBaseUrl + posterSizeConfig + posterPath))
        XCTAssertEqual(createdViewModel.backdropURL, URL(string: stubDataAccess.configurationBaseUrl + backdropSizeConfig + backdropPath))
        
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
    
    func test_Init_FromModel_WithMissingParams_ReturnObjWithSomeNilProps() {
        let backdropPath = "XYZ"
        let title = "Some Title"
        
        myDict = [MovieDBKeys.VideoBackdropPath: backdropPath,
                  MovieDBKeys.VideoTitle: title]
        
        let createdModel = VideoModel(from: myDict)
        
        let createdViewModel = VideoViewModel(model: createdModel, dataAccess: stubDataAccess)
        
        XCTAssertNotNil(createdViewModel)
        
        XCTAssertNil(createdViewModel.posterURL)
        XCTAssertEqual(createdViewModel.backdropURL, URL(string: stubDataAccess.configurationBaseUrl + backdropSizeConfig + backdropPath))
        
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
    
    func test_Init_FromModel_WithWrongParamTypes_ReturnObjWithSomeNilProps() {
        let posterPath = 2
        let backdropPath = "XYZ"
        let title = 1
        let orgTitle = "Some Original Title"
        let isAdult = "false"
        let overview = "Blah blah"
        let release = "???"
        
        myDict = [MovieDBKeys.VideoPosterPath: posterPath,
                  MovieDBKeys.VideoBackdropPath: backdropPath,
                  MovieDBKeys.VideoTitle: title,
                  MovieDBKeys.VideoOriginalTitle: orgTitle,
                  MovieDBKeys.VideoIsAdult: isAdult,
                  MovieDBKeys.VideoOverview: overview,
                  MovieDBKeys.VideoReleasedDate: release,
                  MovieDBKeys.VideoPopularity: 3.5,
                  MovieDBKeys.VideoVoteAverage: Bool(false),
                  MovieDBKeys.VideoVoteCount: "50",
                  MovieDBKeys.VideoGenreIDs: ["1","3","2"]]
        
        let createdModel = VideoModel(from: myDict)
        
        let createdViewModel = VideoViewModel(model: createdModel, dataAccess: stubDataAccess)
        
        XCTAssertNotNil(createdViewModel)
        
        XCTAssertNil(createdViewModel.posterURL)
        XCTAssertEqual(createdViewModel.backdropURL, URL(string: stubDataAccess.configurationBaseUrl + backdropSizeConfig + backdropPath))
        
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
    
    func test_Init_FromModel_WithWrongGenreFormat_ReturnFull() {
        let posterPath = "ABC"
        let backdropPath = "XYZ"
        let title = "Some Title"
        let orgTitle = "Some Original Title"
        let isAdult = Bool(false)
        let overview = "Blah blah"
        let release = "???"
        
        myDict = [MovieDBKeys.VideoPosterPath: posterPath,
                  MovieDBKeys.VideoBackdropPath: backdropPath,
                  MovieDBKeys.VideoTitle: title,
                  MovieDBKeys.VideoOriginalTitle: orgTitle,
                  MovieDBKeys.VideoIsAdult: isAdult,
                  MovieDBKeys.VideoOverview: overview,
                  MovieDBKeys.VideoReleasedDate: release,
                  MovieDBKeys.VideoPopularity: 3.5,
                  MovieDBKeys.VideoVoteAverage: 7.1,
                  MovieDBKeys.VideoVoteCount: 50,
                  MovieDBKeys.VideoGenreIDs: [1,-3,200]]
        
        let createdModel = VideoModel(from: myDict)
        let createdViewModel = VideoViewModel(model: createdModel, dataAccess: stubDataAccess)
        
        XCTAssertNotNil(createdViewModel)
        
        XCTAssertEqual(createdViewModel.posterURL, URL(string: stubDataAccess.configurationBaseUrl + posterSizeConfig + posterPath))
        XCTAssertEqual(createdViewModel.backdropURL, URL(string: stubDataAccess.configurationBaseUrl + backdropSizeConfig + backdropPath))
        
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
    
    func test_Init_FromPlainData_ReturnFull() {
        let posterPath = "ABC"
        let backdropPath = "XYZ"
        let title = "Some Title"
        let orgTitle = "Some Original Title"
        let isAdult = Bool(false)
        let overview = "Blah blah"
        let release = "???"
        
        myDict = [MovieDBKeys.VideoPosterPath: posterPath,
                  MovieDBKeys.VideoBackdropPath: backdropPath,
                  MovieDBKeys.VideoTitle: title,
                  MovieDBKeys.VideoOriginalTitle: orgTitle,
                  MovieDBKeys.VideoIsAdult: isAdult,
                  MovieDBKeys.VideoOverview: overview,
                  MovieDBKeys.VideoReleasedDate: release,
                  MovieDBKeys.VideoPopularity: 3.5,
                  MovieDBKeys.VideoVoteAverage: 7.1,
                  MovieDBKeys.VideoVoteCount: 50,
                  MovieDBKeys.VideoGenreIDs: [1,3,2]]
        
        let createdViewModel = VideoViewModel(data: myDict, dataAccess: stubDataAccess)
        
        XCTAssertNotNil(createdViewModel)
        
        XCTAssertEqual(createdViewModel.posterURL, URL(string: stubDataAccess.configurationBaseUrl + posterSizeConfig + posterPath))
        XCTAssertEqual(createdViewModel.backdropURL, URL(string: stubDataAccess.configurationBaseUrl + backdropSizeConfig + backdropPath))
        
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
}
