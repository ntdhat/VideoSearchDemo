//
//  MovieDBClient.swift
//  VideoSearchDemo
//
//  Created by admin on 5/25/17.
//  Copyright © 2017 ntdhat. All rights reserved.
//

import Foundation
import Alamofire

public let ApiKey = "5ad6992a1517c0d1708b8fe17e70ff29"

class MovieDBKeys {
    static let TotalResult = "total_results"
    static let TotalPages = "total_pages"
    static let ResultsArray = "results"
    static let CurrentPage = "page"
    
    static let VideoPosterPath = "poster_path"
    static let VideoBackdropPath = "backdrop_path"
    static let VideoIsAdult = "adult"
    static let VideoTitle = "title"
    static let VideoOriginalTitle = "original_title"
    static let VideoOverview = "overview"
    static let VideoReleasedDate = "release_date"
    static let VideoPopularity = "popularity"
    static let VideoVoteAverage = "vote_average"
    static let VideoVoteCount = "vote_count"
    static let VideoGenreIDs = "genre_ids"
    
    static let ConfigurationImages = "images"
    static let ConfigurationBaseURL = "base_url"
    static let ConfigurationBackdropSizes = "backdrop_sizes"
    static let ConfigurationPosterSizes = "poster_sizes"
    
    static let GenresList = "genres"
}

class MovieDBClient {
    
    static let shared = MovieDBClient()
    
    var searchMovieFinalUrl: String = "https://api.themoviedb.org/3/search/movie"
    var configurationFinalUrl: String = "https://api.themoviedb.org/3/configuration"
    var genresListFinalUrl: String = "https://api.themoviedb.org/3/genre/movie/list"
    
    var configurationBaseUrl : String!
    var configurationBackdropSizes : NSArray!
    var configurationPosterSizes : NSArray!
    var genresList = [Int:String]()
    
    func searchMovie(parameters params : Dictionary<String, Any>, completionHanler completion : @escaping (DataResponse<Any>) -> Void ) {
        var paramsWithApiKey = params
        paramsWithApiKey["api_key"] = ApiKey
        
        Alamofire.request(searchMovieFinalUrl, method: .get, parameters: paramsWithApiKey).responseJSON { response in
            completion(response)
        }
    }
    
    func loadConfiguration(completion: ((_ error: Error?)->Void)? = nil) {
        let params : Parameters = ["api_key" : ApiKey]
        Alamofire.request(configurationFinalUrl, method: .get, parameters: params).responseJSON { response in
            if let err = response.error {
                completion?(err)
                return
            }

            guard let result = response.result.value else {
                completion?(nil)
                return
            }

            let json = result as! NSDictionary
            //print("JSON: \(json)")

            let imagesConfiguation = json.value(forKey: MovieDBKeys.ConfigurationImages) as? NSDictionary
            self.configurationBaseUrl = imagesConfiguation?.value(forKey: MovieDBKeys.ConfigurationBaseURL) as! String
            self.configurationPosterSizes = imagesConfiguation?.value(forKey: MovieDBKeys.ConfigurationPosterSizes) as! NSArray
            self.configurationBackdropSizes = imagesConfiguation?.value(forKey: MovieDBKeys.ConfigurationBackdropSizes) as! NSArray

            completion?(nil)
        }
    }
    
    func loadGenresList(completion: ((_ error: Error?)->Void)? = nil) {
        let params : Parameters = ["api_key" : ApiKey]
        Alamofire.request(genresListFinalUrl, method: .get, parameters: params).responseJSON { response in
            if let err = response.error {
                completion?(err)
                return
            }

            guard let json = response.result.value as? [String:Any],
                let genres = json[MovieDBKeys.GenresList] as? [[String:Any]] else {
                    completion?(nil)
                    return
            }

            for item in genres {
                if let ID = item["id"] as? Int, let name = item["name"] as? String {
                    self.genresList[ID] = name
                }
            }

            completion?(nil)
        }
    }
}
