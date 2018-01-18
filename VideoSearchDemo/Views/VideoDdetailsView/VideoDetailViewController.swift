//
//  VideoDetailViewController.swift
//  VideoSearchDemo
//
//  Created by admin on 5/25/17.
//  Copyright © 2017 ntdhat. All rights reserved.
//

import UIKit

class VideoDetailViewController: UIViewController {
    var viewModel : VideoDetailViewModel!
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
        lblTitle.text = viewModel.title
        lblReleaseDate.text = viewModel.textReleaseDateRefined
        lblPopularity.text = viewModel.textPopularity
        lblVote.text = viewModel.textVote
        lblGenres.text = viewModel.textGenres
        textViewOverview.text = viewModel.overview
        
        if let posterUrl = viewModel.posterURL {
            imvBackdrop.af_setImage(withURL: posterUrl, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: { response in
                self.loadImageCompletion?()
            })
        }
        
        didSetupUI = true
    }
}







