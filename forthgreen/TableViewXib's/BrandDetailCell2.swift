//
//  BrandDetailCell2.swift
//  forthgreen
//
//  Created by MACBOOK on 05/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

protocol MoveToTopDelegate {
    func changeStatus(isHidden:Bool)
}

class BrandDetailCell2: UITableViewCell {
    var topDelegate:MoveToTopDelegate?
    
    var brandName: String = String()
    var productData: [Product] = [Product]() {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    private var BookMarkAddVM: BookMarkAddViewModel = BookMarkAddViewModel()
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - ConfigUI
    private func configUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        
        
        BookMarkAddVM.bookmarkInfo.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.BookMarkAddVM.success.value {
                let index = self.productData.firstIndex { (data) -> Bool in
                    data.id == self.BookMarkAddVM.bookmarkInfo.value.ref
                }
                if index != nil {
                    self.productData[index!].isBookmark = self.BookMarkAddVM.bookmarkInfo.value.status
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

//MARK: - CollectionView DataSource and Delegate Methods
extension BrandDetailCell2: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // numberOfItmsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productData.count
    }
    
    // cellForItmeAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell
            else {
                return UICollectionViewCell()
        }
        cell.productImage.downloadCachedImageWithLoader(placeholder: "rectangle", urlString: AppImageUrl.average + (productData[indexPath.row].images.first ?? ""))
        if !productData[indexPath.row].currency.isEmpty {
            cell.priceLbl.text = productData[indexPath.row].currency + productData[indexPath.row].price
        } else {
            cell.priceLbl.text = STATIC_LABELS.currencySymbol.rawValue + productData[indexPath.row].price
        }
        
        cell.productNameLbl.text = brandName
        cell.brandNameLbl.text = productData[indexPath.row].name
        
        cell.bookmarkBtn.isSelected = productData[indexPath.row].isBookmark
        cell.bookmarkBtn.tag = indexPath.row
        cell.bookmarkBtn.addTarget(self, action: #selector(self.clickToBookmark), for: .touchUpInside)
        
//        cell.brandNameLbl.text = productData[indexPath.row]. // todo brandName is pending
        return cell
    }
    
    // willDisplay
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= 3{
            topDelegate?.changeStatus(isHidden: false)
        }
        else{
            topDelegate?.changeStatus(isHidden: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        vc.productId = productData[indexPath.row].id
  //      vc.isTransition = true
        if let visibleViewController = visibleViewController(){
            visibleViewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellW = (collectionView.frame.width / 2) - 5
        return CGSize(width: cellW, height: cellW + 116)
    }
    
    @objc func clickToBookmark(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
//            let GuestUserV : GuestUserView = GuestUserView()
//            displaySubViewtoParentView(UIApplication.shared.keyWindow?.rootViewController?.view, subview: GuestUserV)
        }
        else {
            AppDelegate().sharedDelegate().vibrateOnTouch()
            BookMarkAddVM.addBookmark(request: BookmarkAddRequest(ref: productData[sender.tag].id, refType: BOOKMARK_TYPES.PRODUCT.rawValue, status: !productData[sender.tag].isBookmark))
        }
    }
    
}
