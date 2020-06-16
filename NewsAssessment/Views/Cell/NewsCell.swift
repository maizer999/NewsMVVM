//
//  NewsCell.swift
//  NewsAssessment
//
//  Created by Mohammad Abu Maizer on 6/15/20.
//  Copyright © 2020 Mohammad Abu Maizer. All rights reserved.
//


import UIKit
import SDWebImage

class NewsCell : UITableViewCell {
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsAuthorLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!
    @IBOutlet weak var accountsLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
  
    
    var viewModel: NewsCellViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        self.newsTitleLabel?.text               = viewModel?.newsTitle
        self.newsAuthorLabel?.text              = viewModel?.newsAuthor
        self.newsDateLabel?.text                = viewModel?.newsDate
        self.accountsLabel?.text                = viewModel?.newsDate

     
        self.newsImage.sd_setImage(with: URL(string: viewModel?.newsImageUrl ?? "" ), placeholderImage: UIImage(named: "placeholder.png"))
        self.newsImage.makeRounded()

      
        
      

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}


import UIKit

extension UIImageView {

    func makeRounded() {
        self.layer.borderWidth = 0.2
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = (self.frame.width )  / 2
        self.clipsToBounds = true
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.clipsToBounds = true
    }
}



