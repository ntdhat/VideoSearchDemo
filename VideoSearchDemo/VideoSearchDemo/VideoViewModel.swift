//
//  VideoViewModel.swift
//  VideoSearchDemo
//
//  Created by admin on 5/23/17.
//  Copyright © 2017 ntdhat. All rights reserved.
//

import Foundation

struct VideoViewModel {
    var posterURL : URL? = nil
    let isAdult : Bool?
    let overview : String?
    let title : String?
    let originalTitle : String?
    var backdropURL: URL? = nil
    let releaseDate : String?
    let popularity : Float?
    let voteAverage : Float?
    let voteCount : Int?
    var genres : [String]?
    
    init(_ model : VideoModel) {
        self.title = model.title
        self.originalTitle = model.originalTitle
        self.isAdult = model.isAdult
        self.overview = model.overview
        self.releaseDate = model.releaseDate
        self.popularity = model.popularity
        self.voteAverage = model.voteAverage
        self.voteCount = model.voteCount
        
        if let modelGenres = model.genres {
            for genreId in modelGenres {
                guard let genresData = MovieDBClient.genres else { break }
                self.genres = [String]()
                for dict in genresData {
                    guard
                        let genre = dict as? NSDictionary,
                        let id = genre.value(forKey: "id") as? Int,
                        let name = genre.value(forKey: "name") as? String else { continue }
                    
                    if genreId == id {
                        self.genres!.append(name)
                    }
                }
            }
        }
        
        if let poster = model.posterURL,
            let configBaseUrl = MovieDBClient.configurationBaseUrl,
            let posterSizeConfig = MovieDBClient.configurationPosterSize?.lastObject as? String {
            self.posterURL = URL(string: configBaseUrl + posterSizeConfig + poster)
        }
        
        if let backdrop = model.backdropURL,
            let configBaseUrl = MovieDBClient.configurationBaseUrl,
            let backdropSizeConfig = MovieDBClient.configurationBackdropSize?.lastObject as? String {
            self.backdropURL = URL(string: configBaseUrl + backdropSizeConfig + backdrop)
        }
    }
}
