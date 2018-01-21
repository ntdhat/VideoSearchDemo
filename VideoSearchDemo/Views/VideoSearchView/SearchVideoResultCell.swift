//
//  VideoSearchResultCell.swift
//  VideoSearchDemo
//
//  Created by admin on 5/23/17.
//  Copyright © 2017 ntdhat. All rights reserved.
//

import UIKit
import AlamofireImage

class SearchVideoResultCell: UITableViewCell {
    
    @IBOutlet weak var videoScreenshot: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.isAccessibilityElement = true
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    func configurate(data : VideoViewModel) {
        self.lblTitle.text = data.title
        self.lblSubtitle.text = data.releaseDate
        
        videoScreenshot.image = nil
        guard let backdropUrl = data.backdropURL else { return }
        videoScreenshot.af_setImage(withURL: backdropUrl)
        
        self.isAccessibilityElement = true
    }
    
}

class LoadingMoreCell: UITableViewCell {
    @IBOutlet weak var btnLoadMore: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.isAccessibilityElement = true
    }
    
    @IBAction func btnLoadMoreClicked(_ sender: Any) {
        self.btnLoadMore.isHidden = true
        self.activityIndicator.startAnimating()
        NotificationCenter.default.post(name: Notification.Name("BtnLoadMoreClicked"), object: nil)
    }
    
    func configurate() {
        self.btnLoadMore.isHidden = false
        self.activityIndicator.stopAnimating()
        
        self.isAccessibilityElement = true
    }
}
