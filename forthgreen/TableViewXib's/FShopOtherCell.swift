//
//  FShopOtherCell.swift
//  forthgreen
//
//  Created by ARIS Pvt Ltd on 30/05/23.
//  Copyright © 2023 SukhmaniKaur. All rights reserved.
//

import UIKit

protocol FShopOtherDelegate {
    func selecteUnselectBookmark(shopData: ShopData)
}

class FShopOtherCell: UICollectionViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var btnBookMark: UIButton!
    
    var shopData: ShopData?
    var delegate: FShopOtherDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data: ShopData) {
        self.shopData = data
        self.lblBrandName.text = data.brandName
        self.lblProductName.text = data.name
        self.lblProductPrice.text = "\(data.currency ?? "")\(data.price ?? "")"
        self.btnBookMark.isSelected = data.isBookmark == true
        self.imgProduct.downloadCachedImageWithLoader(placeholder: "",
                                                    urlString: AppImageUrl.average + (data.images?.first ?? ""))
    }
    
    func updateBookmark(isBookmark: Bool) {
        self.shopData?.isBookmark = isBookmark
        self.btnBookMark.isSelected = self.shopData?.isBookmark == true
    }
    
    @IBAction func btnBookMarkAction(_ sender: UIButton) {
        if let shopData = shopData {
            self.delegate?.selecteUnselectBookmark(shopData: shopData)
        }
    }
    
}
