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
    let isAdult : Bool!
    let overview : String!
    let title : String!
    let originalTitle : String!
    var backdropURL: URL? = nil
    let releaseDate : String!
    let popularity : Float!
    let voteAverage : Float!
    let voteCount : Int!
    var genres = [String]()
    
    init(_ model : VideoModel) {
        self.title = model.title
        self.originalTitle = model.originalTitle
        self.isAdult = model.isAdult
        self.overview = model.overview
        self.releaseDate = model.releaseDate
        self.popularity = model.popularity
        self.voteAverage = model.voteAverage
        self.voteCount = model.voteCount
        
        for genreId in model.genres {
            for item in MovieDBClient.genres {
                guard let dict = item as? NSDictionary else { continue }
                let id = dict.value(forKey: "id") as! Int
                let name = dict.value(forKey: "name") as! String
                if genreId == id {
                    self.genres.append(name)
                }
            }
        }
        
        guard let poster = model.posterURL else { return }
        let posterSizeConfig : String = MovieDBClient.configurationPosterSize.lastObject as! String
        self.posterURL = URL(string: MovieDBClient.configurationBaseUrl + posterSizeConfig + poster)
        
        guard let backdrop = model.backdropURL else { return }
        let backdropSizeConfig : String = MovieDBClient.configurationBackdropSize.lastObject as! String
        self.backdropURL = URL(string: MovieDBClient.configurationBaseUrl + backdropSizeConfig + backdrop)
    }
}
