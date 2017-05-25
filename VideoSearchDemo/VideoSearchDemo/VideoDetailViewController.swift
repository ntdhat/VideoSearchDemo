//
//  VideoDetailViewController.swift
//  VideoSearchDemo
//
//  Created by admin on 5/25/17.
//  Copyright © 2017 ntdhat. All rights reserved.
//

import UIKit

class VideoDetailViewController: UIViewController {
    var detailData : VideoViewModel!
    
    @IBOutlet weak var imvBackdrop: UIImageView!
    @IBOutlet weak var imvPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textViewOverview: UITextView!
    @IBOutlet weak var lblOriginalTitle: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblPopularity: UILabel!
    @IBOutlet weak var lblVote: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    
    @IBAction func btnDismissClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIs()
    }
    
    func setupUIs() {
        lblTitle.text = detailData.title
        lblOriginalTitle.text = detailData.originalTitle
        lblReleaseDate.text = "Released: \(detailData.releaseDate!)"
        lblPopularity.text = "Popularity: \(detailData.popularity!)"
        lblVote.text = "User vote: \(detailData.voteAverage!) (\(detailData.voteCount!) votes)"
        lblGenres.text = "Genres: "
        textViewOverview.text = detailData.overview
        
        for element in detailData.genres {
            lblGenres.text?.append("\(element), ")
        }
        
        if let backdropUrl = detailData.backdropURL { imvBackdrop.af_setImage(withURL: backdropUrl) }
        if let posterUrl = detailData.posterURL { imvPoster.af_setImage(withURL: posterUrl) }
    }
}
