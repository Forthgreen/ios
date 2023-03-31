//
//  SearchCategoryTVC.swift
//  forthgreen
//
//  Created by iMac on 7/22/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit

class SearchCategoryTVC: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var brandView: UIView!
    @IBOutlet weak var categoryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - configUI
    private func configUI() {
        categoryImage.layer.cornerRadius = categoryImage.frame.height / 2
        brandView.layer.cornerRadius = brandView.frame.height / 2
    }
}
