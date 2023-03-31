//
//  BrandListVC.swift
//  forthgreen
//
//  Created by MACBOOK on 14/01/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import SkeletonView

class BrandListVC: UIViewController {
    
    private var brandListVM: BrandViewModel = BrandViewModel()
    private let refreshControl = UIRefreshControl()
    var brandListArray:[BrandData] = [BrandData]()
    private var hasMore:Bool = false
    private var page = 1
    private var category:[Int] = [Int]()
    
    @IBOutlet weak var bottomConstraintOfTableView: NSLayoutConstraint!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfigUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // customTabBar
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        tabBar.setTabBarHidden(tabBarHidden: false)
        
        if SCREEN.HEIGHT >= 812 {
            bottomConstraintOfTableView.constant = 76
        } else {
            bottomConstraintOfTableView.constant = 56
        }
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        tableView.register(UINib(nibName: "BrandListCell", bundle: nil), forCellReuseIdentifier: "BrandListCell")
        
        brandListVM.delegate = self
        brandListArray.removeAll()
        page = 1
        hasMore = false
        let brandRequest = BrandRequest(getFollowers: true, category: category)
        brandListVM.BrandList(brandRequest: brandRequest,page:page)
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_ :)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:16/255, green:27/255, blue:57/255, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "")
    }
    
    //MARK: - refreshData
    @objc func refreshData(_ sender: Any) {
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        brandListArray.removeAll()
        hasMore = false
        page = 1
        let brandRequest = BrandRequest(getFollowers: true, category: category)
        brandListVM.BrandList(brandRequest: brandRequest, page: page)
    }
    
    //MARK: - searchBtnIsPressed
    @IBAction func searchBtnIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        vc.searchType = .product
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK: - filterBtnIsPressed
    @IBAction func filterBtnIsPressed(_ sender: UIButton) {
        
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        //        vc.delegate = self
        //        vc.filterType = .brand
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

//MARK: - TableView DataSource and Delegate Methods
extension BrandListVC: UITableViewDelegate, SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "BrandListCell"
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brandListArray.count
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BrandListCell", for: indexPath) as? BrandListCell else {
            return UITableViewCell()
        }
        //        cell.showAnimatedGradientSkeleton()
        if brandListArray.count > 0{
            cell.priceLbl.isHidden = true
            cell.renderProfileImage(circle: true)
            cell.brandNameLbl.text = brandListArray[indexPath.row].brandName
            cell.followersCountLbl.isHidden = true
            cell.brandImage.downloadCachedImageWithLoader(placeholder: "placeholder", urlString: AppImageUrl.average + (brandListArray[indexPath.row].logo ?? ""))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == brandListArray.count - 1 && hasMore == true{
            let brandRequest = BrandRequest(getFollowers: true, category: [])
            page = page + 1
            brandListVM.BrandList(brandRequest: brandRequest, page: page)
        }
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BrandDetailVC") as! BrandDetailVC
        vc.brandId = brandListArray[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

//MARK: - BrandDelegate
extension BrandListVC: BrandDelegate{
    func DidRecieveBrandResponse(brandResponse: BrandResponse) {
        brandListArray += brandResponse.data
        hasMore = brandResponse.hasMore
        self.refreshControl.endRefreshing()
        shimmerView.hideSkeleton()
        shimmerView.isHidden = true
        log.success("SUCCESS")/
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - FilterDelegate
extension BrandListVC: FilterDelegate {
    func didRecieveFilterParams(category: [Int]) {
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        self.category = category
        brandListArray.removeAll()
        page = 1
        hasMore = false
        let brandRequest = BrandRequest(getFollowers: false, category: category)
        brandListVM.BrandList(brandRequest: brandRequest, page: 1)
    }
}
