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
        self.posterURL = data.value(forKey: MovieDBClient.JSONKey_VideoPosterPath) as? String
        self.backdropURL = data.value(forKey: MovieDBClient.JSONKey_VideoBackdropPath) as? String
        
        self.title = data.value(forKey: MovieDBClient.JSONKey_VideoTitle) as? String
        self.originalTitle = data.value(forKey: MovieDBClient.JSONKey_VideoOriginalTitle) as? String
        
        self.isAdult = data.value(forKey: MovieDBClient.JSONKey_VideoIsAdult) as? Bool
        self.overview = data.value(forKeyPath: MovieDBClient.JSONKey_VideoOverview) as? String
        self.releaseDate = data.value(forKey: MovieDBClient.JSONKey_VideoReleasedDate) as? String
        self.popularity = data.value(forKey: MovieDBClient.JSONKey_VideoPopularity) as? Float
        self.voteAverage = data.value(forKey: MovieDBClient.JSONKey_VideoVoteAverage) as? Float
        self.voteCount = data.value(forKey: MovieDBClient.JSONKey_VideoVoteCount) as? Int
        self.genres = data.value(forKey: MovieDBClient.JSONKey_VideoGenreIDs) as? [Int]
    }
}
