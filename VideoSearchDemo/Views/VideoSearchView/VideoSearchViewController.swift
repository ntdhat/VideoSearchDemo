//
//  VideoSearchViewController.swift
//  VideoSearchDemo
//
//  Created by admin on 5/23/17.
//  Copyright © 2017 ntdhat. All rights reserved.
//

import UIKit

let TABLEVIEW_MAX_ITEM = 200

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
    
    var viewModel = SearchVideoViewModel()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailView",
            let detailVC = segue.destination as? VideoDetailViewController,
            let videoDetailsBasicInfo = viewModel[currentSelectedIdxPath.row] {
            detailVC.viewModel = VideoDetailViewModel(childViewModel: videoDetailsBasicInfo)
        }
    }
    
    func startSearch(searchText : String) {
        viewModel.search(for: searchText) { isSuccess in
            guard isSuccess == true else {
                self.displaySearchError()
                return
            }
            self.updateSearchResults()
        }
    }
    
    @objc func loadMore() {        
        viewModel.loadMoreSearchResults() { isSuccess in
            guard isSuccess == true else {
                self.displaySearchError()
                return
            }
            self.videoTableView.reloadData()
        }
    }
    
    func updateSearchResults() {
        guard viewModel.totalResults > 0 else {
            displayNoSearchResult()
            return
        }
        
        videoTableView.reloadData()
        videoTableView.contentOffset = .zero
    }
    
    func isAllResultsDisplayed() -> Bool {
        return viewModel.currentPage == viewModel.totalPages
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
        return indexPath.row < viewModel.totalResults ? 160 : 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(isAllResultsDisplayed() ? viewModel.totalResults : viewModel.totalResults + 1, TABLEVIEW_MAX_ITEM)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < viewModel.totalResults  {
            let cell : SearchVideoResultCell
            cell = videoTableView.dequeueReusableCell(withIdentifier: "SearchVideoResultCell", for: indexPath) as! SearchVideoResultCell
            cell.configurate(data: viewModel[indexPath.row]!)
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
