//
//  SearchVideoViewModel.swift
//  VideoSearchDemo
//
//  Created by admin on 5/23/17.
//  Copyright © 2017 ntdhat. All rights reserved.
//

import Foundation
import Alamofire

protocol SearchVideoViewModelOutput {
    func didSearch(success: Bool) -> Void
}

class SearchVideoViewModel {
    private var videos = [VideoViewModel]()
    var totalPages = 0
    var currentPage = 0
    var totalResults = 0
    var stringQuery = ""
    
    var dataAccess: MovieDBClient = MovieDBClient.shared
    var output: SearchVideoViewModelOutput?
    
    subscript (index: Int) -> VideoViewModel? {
        get {
            return videos[index]
        }
    }
    
    typealias CompletionClosure = (Bool) -> Void
    
    convenience init(outputHandler: SearchVideoViewModelOutput? = nil) {
        self.init()
        self.output = outputHandler
    }
    
    func search(for searchString: String, page: Int = 1) {
        var tempPage = page
        if page<1 {tempPage = 1}
        
        reset(tempPage)
        
        let params = createSearchQuery(searchString: searchString, atPage: tempPage)
        
        // Call to DataAccess to make searching query to backend
        dataAccess.searchMovie(parameters: params) { response in
            // Fetch data returned
            let isFetchSuccess = self.fetchSearchResult(response : response, searchString: searchString)
            // Invoke the completion handler
            self.output?.didSearch(success: isFetchSuccess)
        }
    }
    
    func loadMoreSearchResults() {
        guard
            currentPage < totalPages,
            !stringQuery.isEmpty
            else { return }
        search(for: stringQuery, page: currentPage + 1)
    }
    
    private func reset(_ page: Int) {
        if page==1 {
            totalResults=0
            totalPages=0
            currentPage=0
            stringQuery=""
            videos.removeAll()
        }
    }
    
    private func createSearchQuery(searchString ss: String, atPage pg: Int) -> Dictionary<String, Any> {
        return ["language" : "en-US",
                "page" : pg,
                "query" : ss]
    }
    
    private func fetchSearchResult(response r: DataResponse<Any>, searchString ss: String) -> Bool {
        guard
            let searchResult = r.result.value as? NSDictionary,
            let results = searchResult.value(forKey: MovieDBKeys.ResultsArray) as? Array<Any>,
            let totalPages = searchResult.value(forKey: MovieDBKeys.TotalPages) as? Int,
            let curPage = searchResult.value(forKey: MovieDBKeys.CurrentPage) as? Int
            else {
                return false
        }
        
        // Save fetched data
        for jsonObj in results {
            guard let itemDict = jsonObj as? NSDictionary
                else { break }
            
            self.videos.append(VideoViewModel(data: itemDict, dataAccess: dataAccess))
        }
        
        self.totalPages = totalPages
        self.currentPage = curPage
        self.totalResults = self.videos.count
        self.stringQuery = ss
        
        return true
    }
}
