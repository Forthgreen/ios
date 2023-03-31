//
//  HomeVC.swift
//  forthgreen
//
//  Created by MACBOOK on 04/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import SkeletonView

//MARK: - NOT USED IN THIS VERSION
class HomeVC: UIViewController {
    
    private var brandListVM: BrandViewModel = BrandViewModel()
    private var productListVM: ProductListViewModel = ProductListViewModel()
    private let refreshControl = UIRefreshControl()
    var topDelegate:MoveToTopDelegate?
    var brandListArray:[BrandData] = [BrandData]()
    var productListArray:[ProductList] = [ProductList]()
    private var hasMore:Bool = false
    private var page = 1
    private var category:[Int] = [Int]()
    
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var moveToTopBtn: UIButton!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var brandCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let logo = UIImage(named: "group-1")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        tabBar.setTabBarHidden(tabBarHidden: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        productCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    //MARK: - ConfigUI
    private func configUI() {
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        
        viewAllBtn.isHidden = true
        brandCollectionView.register(UINib(nibName: "BrandCell", bundle: nil), forCellWithReuseIdentifier: "BrandCell")
        productCollectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        
//        let layout1 = UICollectionViewFlowLayout()
//        layout1.scrollDirection = .vertical
//        productCollectionView.collectionViewLayout = layout1
        
        brandListVM.delegate = self
        productListVM.delegate = self
        
        let brandRequest = BrandRequest(getFollowers: true, category: category)
        brandListVM.BrandList(brandRequest: brandRequest, page: 1)
        productListArray.removeAll()
        page = 1
        hasMore = false
        let productRequest = ProductListRequest(category: category)
        productListVM.ProductList(productListRequest: productRequest)
        
        topDelegate = self
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            scrollView.refreshControl = refreshControl
        } else {
            scrollView.addSubview(refreshControl)
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
        productListArray.removeAll()
        DispatchQueue.main.async {
            self.brandCollectionView.reloadData()
            self.productCollectionView.reloadData()
        }
        let brandRequest = BrandRequest(getFollowers: false, category: category)
        brandListVM.BrandList(brandRequest: brandRequest, page: 1)
        
        page = 1
        hasMore = false
        let productRequest = ProductListRequest(category: category)
        productListVM.ProductList(productListRequest: productRequest)
    }
    
    //MARK: - searchBtnIsPressed
    @IBAction func searchBtnIsPressed(_ sender: UIBarButtonItem) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        vc.searchType = .product
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK: - filterBtnIsPressed
    @IBAction func filterBtnIsPressed(_ sender: UIBarButtonItem) {
        
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
//        vc.delegate = self
//        vc.filterType = .shopping
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK: - ViewAllBtnIsPressed
    @IBAction func viewAllBtnIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BrandListVC") as! BrandListVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK: - clickMoveToTopBtn
    @IBAction func clickMoveToTopBtn(_ sender: UIButton) {
        self.scrollToTop()
    }
}

//MARK: - CollectionView DataSource and Delegate Methods
extension HomeVC:  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,  UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == productCollectionView{
            return UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        }
        return .zero
    }
    
    // numberOfItmsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == brandCollectionView {
            if brandListArray.count == 0 {
                // collectionView.sainiSetEmptyMessageCV("Nothing matches to your filter. Please try again.")
                return 0
            }
            collectionView.restore()
            if brandListArray.count > 25{
                return 26
            }
            else {
                return brandListArray.count
            }
        }
        else if collectionView == productCollectionView{
            if productListArray.count == 0 {
                collectionView.sainiSetEmptyMessageCV("No Data Found.")
                return 0
            }
            collectionView.restore()
            return productListArray.count
        }
        else{
            return 0
        }
    }
    
    // cellForItmeAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == brandCollectionView {
            print(indexPath.row)
            guard let cell = brandCollectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath) as? BrandCell
                else {
                    return UICollectionViewCell()
            }
            cell.viewAllView.isHidden = true
            cell.brandNameLbl.text = brandListArray[indexPath.row].brandName
//            if indexPath.row == 25{
//                cell.viewAllView.isHidden = false
//                cell.brandNameLbl.text = ""
//                
//            }
//            else{
//                cell.viewAllView.isHidden = true
//                cell.brandNameLbl.text = brandListArray[indexPath.row].brandName
//                
//            }
            cell.brandImageView.downloadCachedImageWithLoader(placeholder: "placeholder", urlString: AppImageUrl.small + (brandListArray[indexPath.row].logo ?? ""))
            
            return cell
        }
        else {
            
            guard let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell
                else {
                    return UICollectionViewCell()
            }
            if productListArray.count > 0{
                cell.productImage.downloadCachedImageWithLoader(placeholder: "rectangle", urlString: AppImageUrl.average + (productListArray[indexPath.row].images.first ?? ""))
                cell.productNameLbl.text = "£ " + productListArray[indexPath.row].price
                cell.brandNameLbl.text = productListArray[indexPath.row].brandName
                productCollectionView.layoutIfNeeded()
                productCollectionViewHeightConstraint.constant = collectionView.contentSize.height
            }
            return cell
        }
        
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let scrollViewHeight = scrollView.frame.size.height;
    //        let scrollContentSizeHeight = scrollView.contentSize.height;
    //        let scrollOffset = scrollView.contentOffset.y;
    //
    //        if (scrollOffset == 0)
    //        {
    //            // then we are at the top
    //        }
    //        else if ((scrollOffset + scrollViewHeight) == scrollContentSizeHeight)
    //        {
    //            // then we are at the end
    //            if  hasMore == true{
    //                let productRequest = ProductListRequest(category: [])
    //                page = page + 1
    //                productListVM.ProductList(productListRequest: productRequest, page: page)
    //                log.success("Products Count\(productListArray.count)")/
    //
    //            }
    //        }
    //    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10 {
            if  hasMore == true{
                let productRequest = ProductListRequest(category: [])
                page = page + 1
                
                productListVM.ProductList(productListRequest: productRequest)
                
                log.success("Products Count\(productListArray.count)")/
                
            }
        }
    }
    
    
    // willDisplay
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        //Pagination
    //
    //        if collectionView == productCollectionView{
    //            if indexPath.row == productListArray.count - 1 && hasMore == true{
    //                let productRequest = ProductListRequest(category: [])
    //                page = page + 1
    //                productListVM.ProductList(productListRequest: productRequest, page: page)
    //                log.success("Products Count\(productListArray.count)")/
    //
    //            }
    //            //        if indexPath.row >= 3{
    //            //            topDelegate?.changeStatus(isHidden: false)
    //            //        }
    //            //        else{
    //            //            topDelegate?.changeStatus(isHidden: true)
    //            //        }
    //        }
    //    }
    
    // didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == brandCollectionView {
            if indexPath.row == 25{
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BrandListVC") as! BrandListVC
                self.navigationController?.pushViewController(vc, animated: false)
            }
            else{
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BrandDetailVC") as! BrandDetailVC
                vc.brandId = brandListArray[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        else {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            vc.productId = productListArray[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    // minimumLineSpacingForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    // sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == brandCollectionView {
            let cellH = brandCollectionView.frame.height
            return CGSize(width: 80, height: cellH)
        }
        else {
            let cellH = ((SCREEN.WIDTH/2) * 260)/200
            //            productCollectionViewHeightConstraint.constant =  collectionView.contentSize.height
            let cellW = (productCollectionView.frame.width / 2) - 5
            return CGSize(width: cellW, height: cellH)
        }
    }
}

//MARK: - BrandDelegate
extension HomeVC: BrandDelegate{
    func DidRecieveBrandResponse(brandResponse: BrandResponse) {
        brandListArray = brandResponse.data
        self.refreshControl.endRefreshing()
        shimmerView.hideSkeleton()
        shimmerView.isHidden = true
        log.success("SUCCESS")/
        if brandListArray.count > 25 {
            viewAllBtn.isHidden = false
        }
        else {
            viewAllBtn.isHidden = true
        }
        DispatchQueue.main.async {
            self.brandCollectionView.reloadData()
            //self.productCollectionView.reloadData()
        }
    }
}

//MARK: - ProductListDelegate
extension HomeVC: ProductListDelegate {
    func didRecieveProductListResponse(productListResponse: ProductListResponse) {
        productListArray += productListResponse.data
        hasMore = productListResponse.hasMore
        shimmerView.hideSkeleton()
        shimmerView.isHidden = true
        self.refreshControl.endRefreshing()
        log.success("Success")/
        log.success("\(productListArray.count)")/
        log.success("\(productListResponse.hasMore)")/
        log.success("\(productListResponse.page)")/
        DispatchQueue.main.async {
            self.productCollectionView.reloadData()
        }
    }
}

//MARK: - FilterDelegate
extension HomeVC: FilterDelegate {
    func didRecieveFilterParams(category: [Int]) {
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        self.category = category
        brandListArray.removeAll()
        productListArray.removeAll()
        DispatchQueue.main.async {
            self.brandCollectionView.reloadData()
            self.productCollectionView.reloadData()
        }
        let brandRequest = BrandRequest(getFollowers: false, category: category)
        brandListVM.BrandList(brandRequest: brandRequest, page: 1)
        
        page = 1
        hasMore = false
        let productRequest = ProductListRequest(category: category)
        productListVM.ProductList(productListRequest: productRequest)
    }
}

//MARK:- MoveToTopDelegate
extension HomeVC:MoveToTopDelegate{
    func changeStatus(isHidden: Bool) {
        moveToTopBtn.isHidden = true
    }
}
