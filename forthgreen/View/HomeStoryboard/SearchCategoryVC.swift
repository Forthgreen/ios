//
//  SearchCategoryVC.swift
//  forthgreen
//
//  Created by iMac on 7/22/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils

class SearchCategoryVC: UIViewController {
    
    // OUTLETS
    @IBOutlet weak var bottomConstraintOfTableView: NSLayoutConstraint!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var costaintHeightTblView: NSLayoutConstraint!
    
    private var ProductHomeVM: ProductHomeViewModel = ProductHomeViewModel()
    private let refreshControl = UIRefreshControl()
    private var page: Int = Int()
    private var hasMore:Bool = false
    
    var allProductArr: [ProductCategoryList] = [ProductCategoryList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        self.navigationController?.navigationBar.barTintColor = .white
//        self.navigationController?.navigationBar.shadowImage = colorFromHex(hex: "#F2F3F4").as1ptImage()
        
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: false)
        }
        
        if SCREEN.HEIGHT >= 812 {
            bottomConstraintOfTableView.constant = 76
        } else {
            bottomConstraintOfTableView.constant = 56
        }
    }
        
    //MARK: - configUI
    private func configUI() {
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        
//        searchBarView.layer.borderWidth = 1
//        searchBarView.layer.borderColor = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1)
        
        searchBarView.sainiCornerRadius(radius: 6)
        searchBarView.layer.cornerRadius = 6
        searchBarView.layer.masksToBounds = true
        
        tblView.register(UINib(nibName: TABLE_VIEW_CELL.ShopCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ShopCell.rawValue)
        
        addRefreshControl()
        ProductHomeVM.getProductList()
        
        ProductHomeVM.productList.bind { [weak self] (_) in
            guard let `self` = self else { return }
            if self.ProductHomeVM.success.value {
//                self.refreshControl.endRefreshing()
                
                if !self.ProductHomeVM.productList.value.isEmpty {
                    self.shimmerView.hideSkeleton()
                    self.shimmerView.isHidden = true
                   
                    self.allProductArr = [ProductCategoryList]()
                    let positionArr = PRODUCT_CATEGORIES.list //self.ProductHomeVM.productList.value.map({$0.id})
                    //       self.allProductArr = positionArr.map( {i in self.ProductHomeVM.productList.value[i]} )
                   
                    for i in positionArr {
                        var data1 : ProductCategoryList = ProductCategoryList()
                        data1.id = i

                        let catData = self.ProductHomeVM.productList.value.filter {$0.id == data1.id}
                        data1.products = catData.first?.products ?? [ProductList]()

                        self.allProductArr.append(data1)
                    }

                    self.updateTblHeight()
                }
            }
        }
    }
    
    //MARK: - addRefreshControl
    private func addRefreshControl() {
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tblView.refreshControl = refreshControl
        } else {
            tblView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:16/255, green:27/255, blue:57/255, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "")
    }
    
    //MARK: - refreshData
    @objc func refreshData() {
//        shimmerView.isHidden = false
//        shimmerView.isSkeletonable = true
//        shimmerView.showAnimatedGradientSkeleton()
        self.refreshControl.endRefreshing()
        ProductHomeVM.productList.value.removeAll()
        page = 1
        hasMore = false
        ProductHomeVM.getProductList()
    }
    
    //MARK: - searchBtnIsPressed
    @IBAction func searchBtnIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        vc.searchType = .product
        self.navigationController?.pushViewController(vc, animated: false)
    }

    //MARK: - cancelBtnIsPressed
    @IBAction func cancelBtnIsPressed(_ sender: UIButton) {
        
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension SearchCategoryVC: UITableViewDelegate, UITableViewDataSource {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allProductArr.count //PRODUCT_CATEGORIES.allCases.count
    }
    
    // estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450 //UITableView.automaticDimension
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ShopCell.rawValue, for: indexPath) as? ShopCell else { return UITableViewCell() }
        cell.headingLbl.text = PRODUCT_CATEGORIES.allCases[indexPath.row].getString()
        
        cell.ProductHomeVM = ProductHomeVM
        
        cell.categoryId = self.allProductArr[indexPath.row].id
        cell.productData = self.allProductArr[indexPath.row].products
        
        cell.viewAllBtn.tag = indexPath.row
        cell.viewAllBtn.addTarget(self, action: #selector(viewAllProductsBtnIsPressed), for: .touchUpInside)
        
        DispatchQueue.main.async {
            cell.collectionView.reloadData()
        }
        return cell
    }
    
    //MARK: - viewAllProductsBtnIsPressed
    @objc func viewAllProductsBtnIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ProductVC") as! ProductVC
        vc.categoryRef = PRODUCT_CATEGORIES.allCases[sender.tag].rawValue
        vc.categoryName = PRODUCT_CATEGORIES.allCases[sender.tag].getString()
        vc.ProductHomeVM = ProductHomeVM
        vc.isBackDisplay = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateTblHeight() {
        costaintHeightTblView.constant = CGFloat.greatestFiniteMagnitude
        tblView.reloadData()
        tblView.layoutIfNeeded()
        costaintHeightTblView.constant = tblView.contentSize.height
    }
}


extension UIColor {

    /// Converts this `UIColor` instance to a 1x1 `UIImage` instance and returns it.
    ///
    /// - Returns: `self` as a 1x1 `UIImage`.
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
