//
//  VideoModel.swift
//  VideoSearchDemo
//
//  Created by admin on 5/23/17.
//  Copyright © 2017 ntdhat. All rights reserved.
//

import Foundation

struct VideoModel {
    let posterURL : String?
    let backdropURL: String?
    
    let title : String?
    let originalTitle : String?
    
    let isAdult : Bool?
    let overview : String?
    let releaseDate : String?
    let popularity : Float?
    let voteAverage : Float?
    let voteCount : Int?
    let genres : [Int]?
    
    init(from data: NSDictionary) {
        self.posterURL = data.value(forKey: MovieDBKeys.VideoPosterPath) as? String
        self.backdropURL = data.value(forKey: MovieDBKeys.VideoBackdropPath) as? String
        
        self.title = data.value(forKey: MovieDBKeys.VideoTitle) as? String
        self.originalTitle = data.value(forKey: MovieDBKeys.VideoOriginalTitle) as? String
        
        self.isAdult = data.value(forKey: MovieDBKeys.VideoIsAdult) as? Bool
        self.overview = data.value(forKeyPath: MovieDBKeys.VideoOverview) as? String
        self.releaseDate = data.value(forKey: MovieDBKeys.VideoReleasedDate) as? String
        self.popularity = data.value(forKey: MovieDBKeys.VideoPopularity) as? Float
        self.voteAverage = data.value(forKey: MovieDBKeys.VideoVoteAverage) as? Float
        self.voteCount = data.value(forKey: MovieDBKeys.VideoVoteCount) as? Int
        self.genres = data.value(forKey: MovieDBKeys.VideoGenreIDs) as? [Int]
    }
}
