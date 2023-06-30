//
//  postImageCell.swift
//  forthgreen
//
//  Created by MACBOOK on 29/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils
import SDWebImage

class postImageCell: UICollectionViewCell {

    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var crossBtnView: sainiCardView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

}
