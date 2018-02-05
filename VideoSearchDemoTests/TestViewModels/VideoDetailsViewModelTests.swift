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
    var stubDataAccess: MovieDBClient!
    var posterSizeConfig : String!
    var backdropSizeConfig : String!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
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
        super.tearDown()
    }
    
    func test_Init_FullParams() {
        myDict = [MovieDBKeys.VideoPosterPath: "ABC",
                  MovieDBKeys.VideoTitle: "Some Title",
                  MovieDBKeys.VideoOverview: "Blah blah",
                  MovieDBKeys.VideoReleasedDate: "???",
                  MovieDBKeys.VideoPopularity: 3.5,
                  MovieDBKeys.VideoVoteAverage: 7.1,
                  MovieDBKeys.VideoVoteCount: 50,
                  MovieDBKeys.VideoGenreIDs: [1,3,2]]
        
        let viewModel = VideoViewModel(data: myDict, dataAccess: stubDataAccess)
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
        myDict = [MovieDBKeys.VideoTitle: "Some Title",
                  MovieDBKeys.VideoPopularity: 3.5,
                  MovieDBKeys.VideoVoteAverage: 7.1]
        
        let viewModel = VideoViewModel(data: myDict, dataAccess: stubDataAccess)
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
