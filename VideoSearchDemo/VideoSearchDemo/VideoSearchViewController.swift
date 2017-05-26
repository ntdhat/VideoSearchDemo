//
//  VideoSearchViewController.swift
//  VideoSearchDemo
//
//  Created by admin on 5/23/17.
//  Copyright © 2017 ntdhat. All rights reserved.
//

import UIKit

let TABLEVIEW_MAX_ITEM = 200

struct SearchResult {
    var totalPages : Int!
    var totalResults : Int!
    var currentPage : Int!
    var searchQuery : String!
}

class VideoSearchViewController: UIViewController {
    
    @IBOutlet weak var lblGreeting: UILabel!
    @IBOutlet weak var videoTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var searchResult : SearchResult = SearchResult(totalPages: 0, totalResults: 0, currentPage: 0, searchQuery: "")
    var videoDatas = [VideoViewModel]()
    var currentSelectedIdxPath : IndexPath!
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(VideoSearchViewController.dismissKeyboard))
        return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoDatas = [VideoViewModel]()
        registerForNotifications()
    }
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.loadMore),
            name: Notification.Name("BtnLoadMoreClicked"),
            object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetailView") {
            let detailViewController = segue.destination as! VideoDetailViewController
            detailViewController.detailData = videoDatas[currentSelectedIdxPath.row]
        }
    }
    
    func startSearch(searchText : String) {
        activityIndicator.startAnimating()
        lblGreeting.isHidden = true
        videoTableView.isHidden = false
        
        searchResult.searchQuery = searchBar.text!
        let parameters: Dictionary<String, Any> = ["language" : "en-US",
                                                   "page" : 1,
                                                   "query" : searchResult.searchQuery]
        
        MovieDBClient.searchMovie(parameters: parameters, completionHanler: { response in
            guard let result = response.result.value else {
                self.displaySearchError()
                return
            }
            
            let dict = result as! NSDictionary
            self.updateSearchResult(result: dict)
        })
    }
    
    func loadMore() {
        guard
            searchResult.currentPage < searchResult.totalPages,
            !searchResult.searchQuery.isEmpty
        else { return }
        
        activityIndicator .startAnimating()
        
        let parameters: Dictionary<String, Any> = ["language" : "en-US",
                                                   "page" : searchResult.currentPage + 1,
                                                   "query" : searchResult.searchQuery]
        
        MovieDBClient.searchMovie(parameters: parameters, completionHanler: { response in
            guard let result = response.result.value else {
                self.displaySearchError()
                return
            }
            
            let dict = result as! NSDictionary
            self.addSearchResults(additionalResult: dict)
        })
    }
    
    func updateSearchResult(result : NSDictionary) {
        activityIndicator .stopAnimating()
        
        guard
            let totalResults = result.value(forKey: MovieDBClient.JSONKey_TotalResult) as? Int,
            let totalPages = result.value(forKey: MovieDBClient.JSONKey_TotalPages) as? Int,
            let curPage = result.value(forKey: MovieDBClient.JSONKey_CurrentPage) as? Int,
            let results = result.value(forKey: MovieDBClient.JSONKey_ResultsArray) as? Array<Any> else {
            displaySearchError()
            return
        }
        
        searchResult.totalResults = totalResults
        searchResult.totalPages = totalPages
        searchResult.currentPage = curPage
        
        guard totalResults > 0 else {
            displayNoSearchResult()
            return
        }
        
        videoDatas.removeAll()
        for jsonObj in results {
            guard let item = jsonObj as? NSDictionary else {
                break;
            }
            let model = createVideoModel(item)
            videoDatas.append(VideoViewModel(model))
        }
        
        videoTableView.reloadData()
        videoTableView.contentOffset = .zero
    }
    
    func addSearchResults(additionalResult : NSDictionary) {
        activityIndicator .stopAnimating()
        
        guard
            let totalResults = additionalResult.value(forKey: MovieDBClient.JSONKey_TotalResult) as? Int,
            let totalPages = additionalResult.value(forKey: MovieDBClient.JSONKey_TotalPages) as? Int,
            let curPage = additionalResult.value(forKey: MovieDBClient.JSONKey_CurrentPage) as? Int,
            let newResults = additionalResult.value(forKey: MovieDBClient.JSONKey_ResultsArray) as? Array<Any> else { return }
        searchResult.totalResults = totalResults
        searchResult.totalPages = totalPages
        searchResult.currentPage = curPage
        
        for jsonObj in newResults {
            guard let item = jsonObj as? NSDictionary else {
                break;
            }
            let model = createVideoModel(item)
            videoDatas.append(VideoViewModel(model))
        }
        
        videoTableView.reloadData()
    }
    
    func isAllResultsDisplayed() -> Bool {
        return videoDatas.count == searchResult.totalResults
    }
    
    func createVideoModel(_ data: NSDictionary) -> VideoModel {
        let videoModel : VideoModel = VideoModel(posterURL: data.value(forKey: MovieDBClient.JSONKey_VideoPosterPath) as? String,
                                                 isAdult: data.value(forKey: MovieDBClient.JSONKey_VideoIsAdult) as? Bool,
                                                 overview: data.value(forKeyPath: MovieDBClient.JSONKey_VideoOverview) as? String,
                                                 title: data.value(forKey: MovieDBClient.JSONKey_VideoTitle) as? String,
                                                 originalTitle: data.value(forKey: MovieDBClient.JSONKey_VideoOriginalTitle) as? String,
                                                 backdropURL: data.value(forKey: MovieDBClient.JSONKey_VideoBackdropPath) as? String,
                                                 releaseDate: data.value(forKey: MovieDBClient.JSONKey_VideoReleasedDate) as? String,
                                                 popularity: data.value(forKey: MovieDBClient.JSONKey_VideoPopularity) as? Float,
                                                 voteAverage: data.value(forKey: MovieDBClient.JSONKey_VideoVoteAverage) as? Float,
                                                 voteCount: data.value(forKey: MovieDBClient.JSONKey_VideoVoteCount) as? Int,
                                                 genres: data.value(forKey: MovieDBClient.JSONKey_VideoGenreIDs) as? [Int])
        return videoModel
    }
    
    func displaySearchError() {
        let alert = UIAlertController(title: "Oops!", message: "Error!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayNoSearchResult() {
        let alert = UIAlertController(title: "Oops!", message: "There's no result", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UISearchBar hanlders
extension VideoSearchViewController : UISearchBarDelegate {
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Dimiss the keyboard
        dismissKeyboard()
        guard !searchBar.text!.isEmpty else {
            return;
        }
        self.startSearch(searchText: searchBar.text!)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
}

// MARK: - UITableView hanlders
extension VideoSearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row < videoDatas.count ? 160 : 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(isAllResultsDisplayed() ? videoDatas.count : videoDatas.count + 1, TABLEVIEW_MAX_ITEM)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < videoDatas.count {
            let cell : VideoSearchResultCell
            cell = videoTableView.dequeueReusableCell(withIdentifier: "VideoSearchResultCell", for: indexPath) as! VideoSearchResultCell
            let videoData = videoDatas[indexPath.row]
            cell.configurate(data: videoData)
            return cell
        }
        else {
            let cell : LoadingMoreCell
            cell = videoTableView.dequeueReusableCell(withIdentifier: "LoadingMoreCell", for: indexPath) as! LoadingMoreCell
            cell.configurate()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedIdxPath = indexPath
        performSegue(withIdentifier: "showDetailView", sender: nil)
    }
}
