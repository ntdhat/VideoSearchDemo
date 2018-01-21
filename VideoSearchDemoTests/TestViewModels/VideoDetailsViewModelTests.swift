//
//  VideoDetailsViewModelTests.swift
//  VideoSearchDemoTests
//
//  Created by admin on 1/18/18.
//  Copyright © 2018 ntdhat. All rights reserved.
//

import XCTest
@testable import VideoSearchDemo

class VideoDetailsViewModelTests: XCTestCase {
    var myDict: NSMutableDictionary!
    var posterSizeConfig : String!
    var backdropSizeConfig : String!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        myDict = NSMutableDictionary()
        
        MovieDBClient.configurationBaseUrl = "_baseUrl_"
        MovieDBClient.configurationPosterSizes = ["_posterSize_1_", "_posterSize_2_", "_posterSize_3_"]
        MovieDBClient.configurationBackdropSizes = ["_bkdropSize_1_", "_bkdropSize_2_", "_bkdropSize_3_"]
        MovieDBClient.genresList = [0: "genre_1", 1: "genre_1", 2: "genre_2", 3: "genre_3", 4: "genre_4"]
        
        posterSizeConfig = MovieDBClient.configurationPosterSizes.lastObject as! String
        backdropSizeConfig = MovieDBClient.configurationBackdropSizes.lastObject as! String
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_Init_FullParams() {
        myDict = [MovieDBClient.JSONKey_VideoPosterPath: "ABC",
                  MovieDBClient.JSONKey_VideoTitle: "Some Title",
                  MovieDBClient.JSONKey_VideoOverview: "Blah blah",
                  MovieDBClient.JSONKey_VideoReleasedDate: "???",
                  MovieDBClient.JSONKey_VideoPopularity: 3.5,
                  MovieDBClient.JSONKey_VideoVoteAverage: 7.1,
                  MovieDBClient.JSONKey_VideoVoteCount: 50,
                  MovieDBClient.JSONKey_VideoGenreIDs: [1,3,2]]
        
        let viewModel = VideoViewModel(data: myDict)
        let videoDetailsViewModel = VideoDetailViewModel(childViewModel: viewModel)
        
        XCTAssertNotNil(videoDetailsViewModel)
        
        XCTAssertEqual(videoDetailsViewModel.title, viewModel.title)
        XCTAssertEqual(videoDetailsViewModel.overview, viewModel.overview)
        XCTAssertEqual(videoDetailsViewModel.posterURL, viewModel.posterURL)
        XCTAssertTrue(videoDetailsViewModel.textReleaseDateRefined.contains("\(viewModel.releaseDate)"))
        XCTAssertTrue(videoDetailsViewModel.textPopularity.contains("\(viewModel.popularity)"))
        XCTAssertTrue(videoDetailsViewModel.textVote.contains("\(viewModel.voteCount)"))
        XCTAssertTrue(videoDetailsViewModel.textVote.contains("\(viewModel.voteAverage)"))
        
        for element in viewModel.genres {
            XCTAssertTrue(videoDetailsViewModel.textGenres.contains("\(element)"))
        }
    }
    
    func test_Init_MissingSomeParams() {
        myDict = [MovieDBClient.JSONKey_VideoTitle: "Some Title",
                  MovieDBClient.JSONKey_VideoPopularity: 3.5,
                  MovieDBClient.JSONKey_VideoVoteAverage: 7.1]
        
        let viewModel = VideoViewModel(data: myDict)
        let videoDetailsViewModel = VideoDetailViewModel(childViewModel: viewModel)
        
        XCTAssertNotNil(videoDetailsViewModel)
        
        XCTAssertEqual(videoDetailsViewModel.title, viewModel.title)
        XCTAssertEqual(videoDetailsViewModel.overview, viewModel.overview)
        XCTAssertEqual(videoDetailsViewModel.posterURL, viewModel.posterURL)
        XCTAssertTrue(videoDetailsViewModel.textReleaseDateRefined.contains("\(viewModel.releaseDate)"))
        XCTAssertTrue(videoDetailsViewModel.textPopularity.contains("\(viewModel.popularity)"))
        XCTAssertTrue(videoDetailsViewModel.textVote.contains("\(viewModel.voteCount)"))
        XCTAssertTrue(videoDetailsViewModel.textVote.contains("\(viewModel.voteAverage)"))
        
        for element in viewModel.genres {
            XCTAssertTrue(videoDetailsViewModel.textGenres.contains("\(element)"))
        }
    }
}
