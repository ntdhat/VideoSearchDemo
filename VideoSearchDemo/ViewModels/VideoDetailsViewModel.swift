//
//  VideoDetailsViewModel.swift
//  VideoSearchDemo
//
//  Created by admin on 1/18/18.
//  Copyright © 2018 ntdhat. All rights reserved.
//

import Foundation

class VideoDetailViewModel {
    var childViewModel: VideoBasicInfo
    
    var title : String {
        return childViewModel.title
    }
    
    var overview : String {
        return childViewModel.overview
    }
    
    var posterURL : URL? {
        return childViewModel.posterURL
    }
    
    var textReleaseDateRefined : String {
        return "Released: \(childViewModel.releaseDate)"
    }
    
    var textPopularity : String {
        return "Popularity: \(childViewModel.popularity)"
    }
    
    var textVote : String {
        return "User vote: \(childViewModel.voteAverage) (\(childViewModel.voteCount) votes)"
    }
    
    lazy var textGenres : String = {
        var txt = "Genres: "
        for element in childViewModel.genres {
            txt.append("\(element), ")
        }
        return txt
    }()
    
    init(childViewModel: VideoBasicInfo) {
        self.childViewModel = childViewModel
    }
}
