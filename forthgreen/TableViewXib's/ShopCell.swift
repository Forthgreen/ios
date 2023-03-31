//
//  ShopCell.swift
//  forthgreen
//
//  Created by MACBOOK on 10/01/22.
//  Copyright © 2022 SukhmaniKaur. All rights reserved.
//

import UIKit

class ShopCell: UITableViewCell {

    // OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var headingLbl: UILabel!
    
    var categoryId: Int = Int()
    
    var productData: [ProductList] = [ProductList]() {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private var BookMarkAddVM: BookMarkAddViewModel = BookMarkAddViewModel()
    var ProductHomeVM: ProductHomeViewModel = ProductHomeViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configUI()
    }
    
    //MARK: - configUI
    private func configUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "HomeProductCVC", bundle: nil), forCellWithReuseIdentifier: "HomeProductCVC")
        
        BookMarkAddVM.bookmarkInfo.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.BookMarkAddVM.success.value {
                if self.ProductHomeVM.productList.value.count != 0 {
                    let index = self.ProductHomeVM.productList.value.firstIndex { (data) -> Bool in
                        data.id == self.categoryId
                    }
                    if index != nil {
                        let index1 = self.ProductHomeVM.productList.value[index!].products.firstIndex { (data) -> Bool in
                            data.id == self.BookMarkAddVM.bookmarkInfo.value.ref
                        }
                        if index1 != nil {
                            self.ProductHomeVM.productList.value[index!].products[index1!].isBookmark = self.BookMarkAddVM.bookmarkInfo.value.status
                        //    self.productData[index1!].isBookmark = self.BookMarkAddVM.bookmarkInfo.value.status
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: - Collection View Data Source and delegate methods
extension ShopCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productData.count
    }
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeProductCVC", for: indexPath) as? HomeProductCVC else { return UICollectionViewCell() }
        
        cell.productImage.downloadCachedImageWithLoader(placeholder: "rectangle", urlString: AppImageUrl.average + (productData[indexPath.row].images.first ?? ""))
        if !productData[indexPath.row].currency.isEmpty {
            cell.priceLbl.text = productData[indexPath.row].currency + productData[indexPath.row].price
        } else {
            cell.priceLbl.text = STATIC_LABELS.currencySymbol.rawValue + productData[indexPath.row].price
        }
        
        cell.productNameLbl.text = productData[indexPath.row].brandName
        cell.brandNameLbl.text = productData[indexPath.row].name
        cell.bookmarkBtn.isSelected = productData[indexPath.row].isBookmark
        cell.bookmarkBtn.tag = indexPath.row
        cell.bookmarkBtn.addTarget(self, action: #selector(self.clickToBookmark), for: .touchUpInside)
        
        return cell
    }
    
    // sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellW = (collectionView.frame.width * 0.75) - 32
        let cellH = cellW + 116 //(collectionView.frame.height / 2)
        return CGSize(width: cellW, height: cellH)
    }
    
    // didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        vc.productId = productData[indexPath.row].id
//       vc.isTransition = true
        vc.ProductHomeVM = ProductHomeVM
        vc.categoryId = categoryId
        
        if let visibleViewController = visibleViewController(){
            visibleViewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //willDisplay
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        //Pagination
//        if indexPath.row == productListArray.count - 1 && hasMore == true{
//            page = page + 1
//            let request = ProductListRequest(category: category, sort: sortIndex, page: page, gender: gender)
//            productListVM.ProductList(productListRequest: request)
//        }
//    }

    @objc func clickToBookmark(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            let GuestUserV : GuestUserView = GuestUserView()
            displaySubViewtoParentView(UIApplication.shared.keyWindow?.rootViewController?.view, subview: GuestUserV)
        }
        else {
            AppDelegate().sharedDelegate().vibrateOnTouch()
            BookMarkAddVM.addBookmark(request: BookmarkAddRequest(ref: productData[sender.tag].id, refType: BOOKMARK_TYPES.PRODUCT.rawValue, status: !productData[sender.tag].isBookmark))
        }
    }
    
}
