//
//  VideoDetailViewController.swift
//  VideoSearchDemo
//
//  Created by admin on 5/25/17.
//  Copyright © 2017 ntdhat. All rights reserved.
//

import UIKit

class VideoDetailViewController: UIViewController {
    var detailData : VideoDetailViewModel!
    var loadImageCompletion: (()->Void)?
    
    var didSetupUI: Bool = false
    
    @IBOutlet weak var imvBackdrop: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textViewOverview: UITextView!
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
        lblReleaseDate.text = detailData.textReleaseDateRefined
        lblPopularity.text = detailData.textPopularity
        lblVote.text = detailData.textVote
        lblGenres.text = detailData.textGenres
        textViewOverview.text = detailData.overview
        
        if let posterUrl = detailData.posterURL {
            imvBackdrop.af_setImage(withURL: posterUrl, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: { response in
                self.loadImageCompletion?()
            })
        }
        
        didSetupUI = true
    }
}

protocol VideoModelToText {
    var textReleaseDateRefined : String { get }
    var textPopularity : String { get }
    var textVote : String { get }
    var textGenres : String { get }
}

class VideoDetailViewModel : VideoViewModel, VideoModelToText {
    var textReleaseDateRefined : String {
        get {return "Released: \(releaseDate)"}
    }
    
    var textPopularity : String {
        get {return "Popularity: \(popularity)"}
    }
    
    var textVote : String {
        get {return "User vote: \(voteAverage) (\(voteCount) votes)"}
    }
    
    lazy var textGenres : String = {
        var txt = "Genres: "
        for element in genres {
            txt.append("\(element), ")
        }
        return txt
    }()
}







