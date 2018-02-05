//
//  VideoDetailViewControllerTests.swift
//  VideoSearchDemoTests
//
//  Created by admin on 1/7/18.
//  Copyright © 2018 ntdhat. All rights reserved.
//

import XCTest
@testable import VideoSearchDemo

class VideoDetailViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_SetupUIWhenViewLoaded_Successful() {
        let stubDataAccess = MovieDBClient()
        stubDataAccess.configurationBaseUrl = "_baseUrl_"
        stubDataAccess.configurationPosterSizes = ["_posterSize_1_", "_posterSize_2_", "_posterSize_3_"]
        stubDataAccess.configurationBackdropSizes = ["_bkdropSize_1_", "_bkdropSize_2_", "_bkdropSize_3_"]
        stubDataAccess.genresList = [0: "genre_1", 1: "genre_1", 2: "genre_2", 3: "genre_3", 4: "genre_4"]
        
        let posterPath = "ABC"
        let backdropPath = "XYZ"
        let title = "Some Title"
        let orgTitle = "Some Original Title"
        let isAdult = Bool(false)
        let overview = "Blah blah"
        let release = "???"
        
        let myDict = NSDictionary(dictionary: [MovieDBKeys.VideoPosterPath: posterPath,
                                               MovieDBKeys.VideoBackdropPath: backdropPath,
                                               MovieDBKeys.VideoTitle: title,
                                               MovieDBKeys.VideoOriginalTitle: orgTitle,
                                               MovieDBKeys.VideoIsAdult: isAdult,
                                               MovieDBKeys.VideoOverview: overview,
                                               MovieDBKeys.VideoReleasedDate: release,
                                               MovieDBKeys.VideoPopularity: 3.5,
                                               MovieDBKeys.VideoVoteAverage: 7.1,
                                               MovieDBKeys.VideoVoteCount: 50,
                                               MovieDBKeys.VideoGenreIDs: [1,3,2]])
        
        let sampleViewModel = VideoDetailViewModel(childViewModel: VideoViewModel(model: VideoModel(from: myDict), dataAccess: stubDataAccess))
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VideoDetailViewController")
        let sut = vc as! VideoDetailViewController
        
        sut.viewModel = sampleViewModel
        _ = sut.view // Make calling sut's viewDidLoad()
        
        XCTAssertEqual(sut.lblTitle.text, title)
        XCTAssertEqual(sut.lblReleaseDate.text, sampleViewModel.textReleaseDateRefined)
        XCTAssertEqual(sut.lblPopularity.text, sampleViewModel.textPopularity)
        XCTAssertEqual(sut.lblVote.text, sampleViewModel.textVote)
        XCTAssertEqual(sut.textViewOverview.text, sampleViewModel.overview)
        XCTAssertEqual(sut.lblGenres.text, sampleViewModel.textGenres)
        XCTAssertTrue(sut.didSetupUI)
        
        let exp = expectation(description: "Load Image")
        sut.loadImageCompletion = {
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
}
