//
//  ProductCell.swift
//  forthgreen
//
//  Created by MACBOOK on 04/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {

    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var brandNameLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        configUI()
    }

    //MARK: - configUI
    private func configUI() {
        productImage.sainiCornerRadius(radius: 4)
    }
}
