//
//  BrandDetailCell.swift
//  forthgreen
//
//  Created by MACBOOK on 05/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class BrandDetailCell: UITableViewCell {

    @IBOutlet weak var heightConstraintOfViewMoreBtnView: NSLayoutConstraint!
    @IBOutlet weak var viewMoreBtnView: UIView!
    @IBOutlet weak var viewMoreBtn: UIButton!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var followerCountLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var brandNameLbl: UILabel!
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var websiteBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var brandImageView: UIView!
    
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ConfigUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        brandImageView.layer.cornerRadius = brandImageView.frame.height / 2
        
        brandImage.layer.cornerRadius = brandImage.frame.height / 2
        
        brandImage.layer.borderWidth = 1
        brandImage.layer.borderColor = #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.9568627451, alpha: 1)
        brandImageView.layer.borderWidth = 1
        brandImageView.layer.borderColor = #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.9568627451, alpha: 1)
        saveBtn.layer.cornerRadius = 4
        
        websiteBtn.layer.cornerRadius = 4
    }
    
}
