//
//  BrandCell.swift
//  forthgreen
//
//  Created by MACBOOK on 04/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class BrandCell: UICollectionViewCell {

    
    @IBOutlet weak var brandNameLbl: UILabel!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var viewAllView: UIView!
    @IBOutlet weak var brandImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ConfigUI()
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        brandImageView.layer.cornerRadius = brandImageView.frame.height / 2
        brandImageView.layer.borderWidth = 1
        brandImageView.layer.borderColor = #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.9568627451, alpha: 1)
    }

}
