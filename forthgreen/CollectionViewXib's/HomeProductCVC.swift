//
//  HomeProductCVC.swift
//  forthgreen
//
//  Created by iMac on 2/2/22.
//  Copyright © 2022 SukhmaniKaur. All rights reserved.
//

import UIKit

class HomeProductCVC: UICollectionViewCell {

    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var brandNameLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - configUI
    private func configUI() {
        productImage.sainiCornerRadius(radius: 4)
    }

}
