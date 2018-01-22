//
//  VideoViewModel.swift
//  VideoSearchDemo
//
//  Created by admin on 1/18/18.
//  Copyright © 2018 ntdhat. All rights reserved.
//

import Foundation

struct VideoViewModel {
    let model: VideoModel
    
    var posterURL: URL?
    var backdropURL: URL?
    
    let title: String
    let originalTitle: String
    let isAdult: Bool
    let overview: String
    let releaseDate: String
    let popularity: Float
    let voteAverage: Float
    let voteCount: Int
    var genres = [String]()
    
    init(model: VideoModel, dataAccess: MovieDBClient = MovieDBClient.shared) {
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
                let genreName = dataAccess.genresList[genreID] ?? "Not specified"
                self.genres.append(genreName)
            }
        }
        
        let configurationPosterSize = dataAccess.configurationPosterSizes.lastObject as? String
        if let poster = model.posterURL, let posterSizeConfig = configurationPosterSize {
            self.posterURL = URL(string: dataAccess.configurationBaseUrl + posterSizeConfig + poster)
        }
        
        let configurationBackdropSize = dataAccess.configurationBackdropSizes.lastObject as? String
        if let backdrop = model.backdropURL, let backdropSizeConfig = configurationBackdropSize {
            self.backdropURL = URL(string: dataAccess.configurationBaseUrl + backdropSizeConfig + backdrop)
        }
    }
    
    init(data: NSDictionary, dataAccess: MovieDBClient = MovieDBClient.shared) {
        self.init(model: VideoModel(from: data), dataAccess: dataAccess)
    }
}
