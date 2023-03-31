//
//  SimilarProductListCell.swift
//  forthgreen
//
//  Created by MACBOOK on 20/02/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit

class SimilarProductListCell: UITableViewCell {
    
    var productListArray:[SimilarProduct] = [SimilarProduct]()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var writeReviewBtn: UIButton!
    
    
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
        collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
    }
}
