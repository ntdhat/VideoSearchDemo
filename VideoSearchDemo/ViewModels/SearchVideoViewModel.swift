//
//  SearchVideoViewModel.swift
//  VideoSearchDemo
//
//  Created by admin on 5/23/17.
//  Copyright © 2017 ntdhat. All rights reserved.
//

import Foundation
import Alamofire

struct VideoBasicInfo {
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
    
    init(model: VideoModel) {
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
        
        let configurationPosterSize = MovieDBClient.configurationPosterSize.lastObject as? String
        if let poster = model.posterURL, let posterSizeConfig = configurationPosterSize {
            self.posterURL = URL(string: MovieDBClient.configurationBaseUrl + posterSizeConfig + poster)
        }
        
        let configurationBackdropSize = MovieDBClient.configurationBackdropSize.lastObject as? String
        if let backdrop = model.backdropURL, let backdropSizeConfig = configurationBackdropSize {
            self.backdropURL = URL(string: MovieDBClient.configurationBaseUrl + backdropSizeConfig + backdrop)
        }
    }
}

class SearchVideoViewModel {
    private var videos = [VideoBasicInfo]()
    var totalPages = 0
    var currentPage = 0
    var totalResults = 0
    var stringQuery = ""
    
    subscript (index: Int) -> VideoBasicInfo {
        get {
            return videos[index]
        }
    }
    
    typealias CompletionClosure = (Bool) -> Void
    
    func search(for str: String?, page: Int = 1, shouldReset: Bool = true, completion: CompletionClosure?) {
        guard let searchString = str else { return }
        
        prepareDataContainer(page)
        
        let params = createSearchQuery(searchString: searchString, atPage: page)
        
        // Call to DataAccess to make searching query to backend
        MovieDBClient.searchMovie(parameters: params) { response in
            // Fetch data returned
            let isFetchSuccess = self.fetchSearchResult(response : response, searchString: searchString)
            // Invoke the completion handler
            completion?(isFetchSuccess)
        }
    }
    
    func loadMoreSearchResults(completion: CompletionClosure?) {
        guard
            currentPage < totalPages,
            !stringQuery.isEmpty
            else { return }
        search(for: stringQuery, page: currentPage + 1, shouldReset: false, completion: completion)
    }
    
    func prepareDataContainer(_ page: Int) {
        if page==1 {
            videos.removeAll()
        }
    }
    
    func createSearchQuery(searchString ss: String, atPage pg: Int) -> Dictionary<String, Any> {
        return ["language" : "en-US",
                "page" : pg,
                "query" : ss]
    }
    
    func fetchSearchResult(response r: DataResponse<Any>, searchString ss: String) -> Bool {
        guard
            let searchResult = r.result.value as? NSDictionary,
            let results = searchResult.value(forKey: MovieDBClient.JSONKey_ResultsArray) as? Array<Any>,
            let totalPages = searchResult.value(forKey: MovieDBClient.JSONKey_TotalPages) as? Int,
            let curPage = searchResult.value(forKey: MovieDBClient.JSONKey_CurrentPage) as? Int
            else {
                return false
        }
        
        // Save fetched data
        for jsonObj in results {
            guard let itemDict = jsonObj as? NSDictionary
                else { break }
            let viewmodel = VideoModel(from: itemDict)
            let info = VideoBasicInfo(model: viewmodel)
            self.videos.append(info)
        }
        
        self.totalPages = totalPages
        self.currentPage = curPage
        self.totalResults = self.videos.count
        self.stringQuery = ss
        
        return true
    }
}
