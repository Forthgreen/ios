//
//  BrandListCell.swift
//  forthgreen
//
//  Created by MACBOOK on 04/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class BrandListCell: UITableViewCell {

    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var brandNameLbl: UILabel!
    @IBOutlet weak var brandCountLbl: UILabel!
    @IBOutlet weak var followersCountLbl: UILabel!
    @IBOutlet weak var brandCountView: UIView!
    @IBOutlet weak var brandView: UIView!
    @IBOutlet weak var brandImage: UIImageView!
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
        
        brandCountView.layer.cornerRadius = brandCountView.frame.height / 2
    }
    
    //MARK: - renderProfileImage
    func renderProfileImage(circle:Bool){
        if circle{
        brandImage.layer.cornerRadius = brandImage.frame.height / 2
        brandView.layer.cornerRadius = brandView.frame.height / 2
        brandView.layer.borderWidth = 1
        brandView.layer.borderColor = #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.9568627451, alpha: 1)
            brandImage.layer.borderWidth = 1
            brandImage.layer.borderColor = #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.9568627451, alpha: 1)
        }
        else{
            brandImage.layer.cornerRadius = 4
            brandView.layer.cornerRadius = 4
            brandImage.layer.borderWidth = 0
        }
    }
    
}
