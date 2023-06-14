//
//  FShopTopCell.swift
//  forthgreen
//
//  Created by ARIS Pvt Ltd on 30/05/23.
//  Copyright © 2023 SukhmaniKaur. All rights reserved.
//

import UIKit

protocol FShopTopCellProtocol {
    func didSelectTopCell(data: ShopData)
    func moveToBrandLogo(data: ShopData)
}

class FShopTopCell: UICollectionViewCell {

    @IBOutlet weak var viewSpacer: UIView!
    @IBOutlet weak var imgBrand: UIImageView!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pagerControll: UIPageControl!
    var delegate: FShopTopCellProtocol?
    var data: ShopData?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data: ShopData, isHideSpacer: Bool) {
        self.data = data
        self.viewSpacer.isHidden = isHideSpacer
        self.imgBrand.layer.cornerRadius = imgBrand.frame.height / 2
        self.imgBrand.layer.borderColor = colorFromHex(hex: "#ECEDED").cgColor
        self.imgBrand.layer.borderWidth = 1
        self.imgBrand.sainiAddTapGesture {
            self.delegate?.moveToBrandLogo(data: data)
        }
        
        self.lblBrandName.text = data.brandName
        self.lblProductName.text = data.name
        self.lblProductPrice.text = "\(data.currency ?? "")\(data.price ?? "")"
        
        self.imgBrand.downloadCachedImageWithLoader(placeholder: "",
                                                    urlString: AppImageUrl.average + (data.brandlogo ?? ""))
        self.collectionView.register(UINib(nibName: "ShopSliderCell", bundle: nil),
                                     forCellWithReuseIdentifier: "ShopSliderCell")
        
        self.pagerControll.numberOfPages = self.data?.images?.count ?? 0
        self.pagerControll.hidesForSinglePage = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
}

extension FShopTopCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data?.images?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopSliderCell", for: indexPath) as? ShopSliderCell
        let image = data?.images?[indexPath.row] ?? ""
        let url = AppImageUrl.average + image
        print(url)
        cell?.imageView.downloadCachedImageWithLoader(placeholder: "",
                                                      urlString: url)
        cell?.layoutIfNeeded()
        return cell ?? UICollectionViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2

        self.pagerControll.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = data {
            self.delegate?.didSelectTopCell(data: data)
        }
    }
    
}
