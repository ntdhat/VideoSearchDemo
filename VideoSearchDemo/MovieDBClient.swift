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
public let MovieDB_API_BaseUrl = "https://api.themoviedb.org/3"
public let MovieDB_API_SearchMovie = "/search/movie"
public let MovieDB_API_Configuration = "/configuration"
public let MovieDB_API_GenresList = "/genre/movie/list"

class MovieDBClient {
    
    static let JSONKey_TotalResult = "total_results"
    static let JSONKey_TotalPages = "total_pages"
    static let JSONKey_ResultsArray = "results"
    static let JSONKey_CurrentPage = "page"
    
    static let JSONKey_VideoPosterPath = "poster_path"
    static let JSONKey_VideoBackdropPath = "backdrop_path"
    static let JSONKey_VideoIsAdult = "adult"
    static let JSONKey_VideoTitle = "title"
    static let JSONKey_VideoOriginalTitle = "original_title"
    static let JSONKey_VideoOverview = "overview"
    static let JSONKey_VideoReleasedDate = "release_date"
    static let JSONKey_VideoPopularity = "popularity"
    static let JSONKey_VideoVoteAverage = "vote_average"
    static let JSONKey_VideoVoteCount = "vote_count"
    static let JSONKey_VideoGenreIDs = "genre_ids"
    
    static let JSONKey_ConfigurationImages = "images"
    static let JSONKey_ConfigurationBaseURL = "base_url"
    static let JSONKey_ConfigurationBackdropSizes = "backdrop_sizes"
    static let JSONKey_ConfigurationPosterSizes = "poster_sizes"
    
    static let JSONKey_GenresList = "genres"
    
    static var searchMovieFinalUrl: String = {
        return MovieDB_API_BaseUrl + MovieDB_API_SearchMovie
    }()
    
    static var configurationFinalUrl: String = {
        return MovieDB_API_BaseUrl + MovieDB_API_Configuration
    }()
    
    static var genresListFinalUrl: String = {
        return MovieDB_API_BaseUrl + MovieDB_API_GenresList
    }()
    
    static var configurationBaseUrl : String!
    static var configurationBackdropSizes : NSArray!
    static var configurationPosterSizes : NSArray!
    
    static var genresList = [Int:String]()
    
    static func searchMovie(parameters params : Dictionary<String, Any>, completionHanler completion : @escaping (DataResponse<Any>) -> Void ) {
        var paramsWithApiKey = params
        paramsWithApiKey["api_key"] = ApiKey
        
        Alamofire.request(searchMovieFinalUrl, method: .get, parameters: paramsWithApiKey).responseJSON { response in
            completion(response)
        }
    }
    
    static func loadConfiguration(completion: ((_ error: Error?)->Void)? = nil) {
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
            
            let imagesConfiguation = json.value(forKey: JSONKey_ConfigurationImages) as? NSDictionary
            configurationBaseUrl = imagesConfiguation?.value(forKey: JSONKey_ConfigurationBaseURL) as! String
            configurationPosterSizes = imagesConfiguation?.value(forKey: JSONKey_ConfigurationPosterSizes) as! NSArray
            configurationBackdropSizes = imagesConfiguation?.value(forKey: JSONKey_ConfigurationBackdropSizes) as! NSArray
            
            completion?(nil)
        }
    }
    
    static func loadGenresList(completion: ((_ error: Error?)->Void)? = nil) {
        let params : Parameters = ["api_key" : ApiKey]
        Alamofire.request(genresListFinalUrl, method: .get, parameters: params).responseJSON { response in
            if let err = response.error {
                completion?(err)
                return
            }
            
            guard let json = response.result.value as? [String:Any],
                let genres = json[JSONKey_GenresList] as? [[String:Any]] else {
                    completion?(nil)
                    return
            }
            
            for item in genres {
                if let ID = item["id"] as? Int, let name = item["name"] as? String {
                    genresList[ID] = name
                }
            }
            
            completion?(nil)
        }
    }
}
