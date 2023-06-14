//
//  ShopVC.swift
//  forthgreen
//
//  Created by ARIS Pvt Ltd on 30/05/23.
//  Copyright © 2023 SukhmaniKaur. All rights reserved.
//

import UIKit
import SkeletonView

class ShopVC: UIViewController {
    
    @IBOutlet weak var collectionShop: UICollectionView!
    private var shopVM: ShopViewModel = ShopViewModel()
    private var refreshControl = UIActivityIndicatorView()
    @IBOutlet weak var shimmerView: UIView!
    private var BookMarkAddVM: BookMarkAddViewModel = BookMarkAddViewModel()
    
    var page = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionShop.register(UINib(nibName: "FShopTopCell", bundle: nil), forCellWithReuseIdentifier: "FShopTopCell")
        self.collectionShop.register(UINib(nibName: "FShopOtherCell", bundle: nil), forCellWithReuseIdentifier: "FShopOtherCell")
        self.collectionShop.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "collectionFooterID")
        self.collectionShop.delegate = self
        self.collectionShop.dataSource = self
        
        
        self.configUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: false)
            self.collectionShop.reloadData()
        }
    }
    
    func configUI() {
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        self.shopVM.getShopList(request: ShopPageRequest(page: page))
        
        refreshControl.tintColor = UIColor(red:16/255, green:27/255, blue:57/255, alpha:1.0)
      
        BookMarkAddVM.bookmarkInfo.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.BookMarkAddVM.success.value {
                let index = self.shopVM.shopData.value.firstIndex { (data) -> Bool in
                    data.id == self.BookMarkAddVM.bookmarkInfo.value.ref
                }
                if let index = index {
                    self.shopVM.shopData.value[index].isBookmark = self.BookMarkAddVM.bookmarkInfo.value.status
                    self.collectionShop.reloadData()
                }
            }
        }
        
        shopVM.shopData.bind { [weak self] (_) in
            guard let `self` = self else { return }
            if self.shopVM.shopData.value.isEmpty == false {
                shimmerView.isHidden = true
            }
            self.refreshControl.stopAnimating()
            self.collectionShop.reloadData()
        }
     //   self.collectionShop.addSubview(refreshControl)
        
    }
    
    @objc func refreshData(_ sender: Any) {
       
       /* self.collectionShop.reloadData()
        page = 1
        self.shopVM.getShopList(request: ShopPageRequest.init(page: page))*/
    }
        
    @IBAction func btnSearchAction(_ sender: Any) {
        
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ShopCategoryVC") as! ShopCategoryVC
        self.navigationController?.pushViewController(vc, animated: false)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ShopVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shopVM.shopData.value.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let shopData = self.shopVM.shopData.value[indexPath.row]
        
        if indexPath.row % 7 == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FShopTopCell",
                                                     for: indexPath) as! FShopTopCell
            cell.setData(data: shopData, isHideSpacer: indexPath.row == 0)
            cell.delegate = self
            cell.layoutIfNeeded()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FShopOtherCell",
                                                     for: indexPath) as! FShopOtherCell
            cell.setData(data: shopData)
            cell.delegate = self
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let showSpecHeight = indexPath.row == 0 ? 16 : 0
        let cellW = (collectionView.frame.width / 2) - 7
        let topWidth = 108 + collectionView.frame.width
        let height = indexPath.row % 7 == 0 ? CGFloat((topWidth + CGFloat(showSpecHeight))) : (cellW + 90)
        let width = indexPath.row % 7 == 0 ? collectionView.frame.size.width : cellW
    
        return CGSize(width: Double(width), height: Double(height))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    // didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        vc.productId = self.shopVM.shopData.value[indexPath.row].id ?? ""
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height = shopVM.shopHasMore.value == true ? 67 : 0
        return CGSize(width: collectionView.frame.width, height: CGFloat(height))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
           if kind == UICollectionView.elementKindSectionFooter {
               if  shopVM.shopHasMore.value == true {
                   shopVM.shopHasMore.value = false
                   page = page + 1
                   self.shopVM.getShopList(request: ShopPageRequest.init(page: page))
                   log.success("Products Count\(self.shopVM.shopData.value.count)")/
               }
               let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionFooterID", for: indexPath)
               refreshControl = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: collectionView.frame.width, height: 50))
               refreshControl.hidesWhenStopped = true
               footer.addSubview(refreshControl)
               refreshControl.startAnimating()
               return footer
           }
           return UICollectionReusableView()
       }

}

//MARK: - ProductListDelegate
extension ShopVC: UpdateProductBookmarkList {
    func updateProductListWithBokmark(productRef: String, status: Bool) {
        let index = self.shopVM.shopData.value.firstIndex { (data) -> Bool in
            data.id == productRef
        }
        if index != nil {
            self.shopVM.shopData.value[index!].isBookmark = status
            self.collectionShop.reloadData()
        }
    }
}

// MARK: FShopTopCellProtocol
extension ShopVC: FShopTopCellProtocol {
    func moveToBrandLogo(data: ShopData) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BrandDetailVC") as! BrandDetailVC
        vc.brandId = data.brandId ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func didSelectTopCell(data: ShopData) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        vc.productId = data.id ?? ""
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: FShopOtherDelegate
extension ShopVC: FShopOtherDelegate {
    func selecteUnselectBookmark(shopData: ShopData) {
        if AppModel.shared.isGuestUser == false {
            AppDelegate().sharedDelegate().vibrateOnTouch()
            
            let bookmark = shopData.isBookmark ?? false
            BookMarkAddVM.addBookmark(request: BookmarkAddRequest(ref: shopData.id,
                                                                  refType: BOOKMARK_TYPES.PRODUCT.rawValue,
                                                                  status: !bookmark))
        } else if AppModel.shared.isGuestUser {
            self.showLoginAlert()
        }
    }
    
    func showLoginAlert() {
        DispatchQueue.main.async {
            var alertVM: Alert = Alert()
            alertVM.delegate = self
            alertVM.displayAlert(vc: self, alertTitle: STATIC_LABELS.loginToContinue.rawValue,
                                      message: STATIC_LABELS.loginToContinueMessage.rawValue,
                                      okBtnTitle: STATIC_LABELS.login.rawValue,
                                      cancelBtnTitle: STATIC_LABELS.cancel.rawValue)
        }
     }
}

extension ShopVC: AlertDelegate {
    func didClickOkBtn() {
        (UIApplication.shared.delegate as? AppDelegate)?.logoutUser()
    }
    
    func didClickCancelBtn() {
        
    }
}
