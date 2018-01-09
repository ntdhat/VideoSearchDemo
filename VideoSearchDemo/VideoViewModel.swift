//
//  VideoViewModel.swift
//  VideoSearchDemo
//
//  Created by admin on 5/23/17.
//  Copyright © 2017 ntdhat. All rights reserved.
//

import Foundation

class VideoViewModel {
    var model: VideoModel
    
    var posterURL : URL?
    var backdropURL: URL?
    
    let title : String
    let originalTitle : String
    
    let isAdult : Bool
    let overview : String
    let releaseDate : String
    let popularity : Float
    let voteAverage : Float
    let voteCount : Int
    var genres = [String]()
    
    var configurationBaseUrl : String = {
        return MovieDBClient.configurationBaseUrl
    }()
    var configurationPosterSize : String? = {
        return MovieDBClient.configurationPosterSize.lastObject as? String
    }()
    var configurationBackdropSize : String? = {
        return MovieDBClient.configurationBackdropSize.lastObject as? String
    }()
    
    init(_ model : VideoModel) {
        self.model = model
        
        self.title = model.title ?? "Unknown"
        self.originalTitle = model.originalTitle ?? "Unknown"
        self.isAdult = model.isAdult ?? true
        self.overview = model.overview ?? "Not specified"
        self.releaseDate = model.releaseDate ?? "Not specified"
        self.popularity = model.popularity ?? 0.0
        self.voteAverage = model.voteAverage ?? 0.0
        self.voteCount = model.voteCount ?? 0
        
        if let genreIDs = model.genres {
            for genreID in genreIDs {
                let genreName = MovieDBClient.genresList[genreID] ?? "Not specified"
                self.genres.append(genreName)
            }
        }
        
        if let poster = model.posterURL,
            let posterSizeConfig = configurationPosterSize {
            self.posterURL = URL(string: configurationBaseUrl + posterSizeConfig + poster)
        }
        
        if let backdrop = model.backdropURL,
            let backdropSizeConfig = configurationBackdropSize {
            self.backdropURL = URL(string: configurationBaseUrl + backdropSizeConfig + backdrop)
        }
    }
}
