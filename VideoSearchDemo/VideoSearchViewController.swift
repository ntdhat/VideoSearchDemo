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
    var totalPages : Int = 0
    var totalResults : Int = 0
    var currentPage : Int = 0
    var searchQuery : String = ""
}

//public class ListNode<T> {
//    public var value: T
//    public var next: ListNode<T>?
//    public init(_ x: T) {
//        self.value = x
//        self.next = nil
//    }
//
//    var isLastNode: Bool {
//        return next == nil
//    }
//}

class VideoSearchViewController: UIViewController {
    
    @IBOutlet weak var videoTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchResult : SearchResult = SearchResult()
    var videoDatas = [VideoViewModel]()
    var currentSelectedIdxPath : IndexPath!
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(VideoSearchViewController.dismissKeyboard))
        return recognizer
    }()
    
//    func isListPalindrome(l: ListNode<Int>?) -> Bool {
//        guard let l = l else { return false }
//        var m : ListNode<Int>?
//        return isInnerListPalindrome(nodeLeft: l, nodeRight: &m, nodeNil:l)
//    }
//
//    func isInnerListPalindrome(nodeLeft: ListNode<Int>, nodeRight: inout ListNode<Int>?, nodeNil: ListNode<Int>) -> Bool {
//        nodeRight = nodeNil.next == nil ? nodeLeft : nodeNil.next!.next == nil ? nodeLeft.next : nil
//
//        var b : Bool = true
//        if nodeRight == nil {
//            b = isInnerListPalindrome(nodeLeft:nodeLeft.next!, nodeRight:&nodeRight, nodeNil:nodeNil.next!.next!)
//        }
//
//        let bb = nodeLeft.value == nodeRight!.value
//        nodeRight = nodeRight!.next
//
//        return b && bb
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if segue.identifier == "showDetailView", let detailVC = segue.destination as? VideoDetailViewController {
            let viewmodel = videoDatas[currentSelectedIdxPath.row]
            let model = viewmodel.model
            detailVC.detailData = VideoDetailViewModel(model)
        }
    }
    
    func startSearch(searchText : String) {
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
    
    @objc func loadMore() {
        guard
            searchResult.currentPage < searchResult.totalPages,
            !searchResult.searchQuery.isEmpty
        else { return }
        
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
            guard let itemDict = jsonObj as? NSDictionary
                else {
                    break;
            }
            let viewmodel = VideoModel(from: itemDict)
            videoDatas.append(VideoViewModel(viewmodel))
        }
        
        videoTableView.reloadData()
        videoTableView.contentOffset = .zero
    }
    
    func addSearchResults(additionalResult : NSDictionary) {
        guard
            let totalResults = additionalResult.value(forKey: MovieDBClient.JSONKey_TotalResult) as? Int,
            let totalPages = additionalResult.value(forKey: MovieDBClient.JSONKey_TotalPages) as? Int,
            let curPage = additionalResult.value(forKey: MovieDBClient.JSONKey_CurrentPage) as? Int,
            let newResults = additionalResult.value(forKey: MovieDBClient.JSONKey_ResultsArray) as? Array<Any> else {
                return
        }
        
        searchResult.totalResults = totalResults
        searchResult.totalPages = totalPages
        searchResult.currentPage = curPage
        
        for jsonObj in newResults {
            guard let item = jsonObj as? NSDictionary else {
                break;
            }
            videoDatas.append(VideoViewModel(VideoModel(from: item)))
        }
        
        videoTableView.reloadData()
    }
    
    func isAllResultsDisplayed() -> Bool {
        return videoDatas.count == searchResult.totalResults
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
    @objc func dismissKeyboard() {
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
