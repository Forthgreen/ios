//
//  ProductVC.swift
//  forthgreen
//
//  Created by MACBOOK on 13/01/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import SkeletonView

class ProductVC: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    private var productListVM: ProductListViewModel = ProductListViewModel()
    private var BookMarkAddVM: BookMarkAddViewModel = BookMarkAddViewModel()
    var ProductHomeVM: ProductHomeViewModel = ProductHomeViewModel()
    
    private var productListArray:[ProductList] = [ProductList]()
    private let refreshControl = UIRefreshControl()
    private var page: Int = Int()
    private var hasMore:Bool = false
    var categoryRef: Int = Int()
    var categoryName: String = String()
    private var category = [Int]()
    private var sortIndex: Int = 1
    private var lastContentOffset: CGFloat = 0
    private var clearFilter: Bool = Bool()
    private var gender: Int = 3 //both
//    var selectedProduct: ProductList!
        
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var sortFilterView: UIView!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var sortBackView: UIView!
    @IBOutlet weak var sortAnimationBackView: UIView!
    @IBOutlet weak var sortTblView: UITableView!
    
    var isBackDisplay = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLbl.text = categoryName
        backBtn.isHidden = !isBackDisplay
        
//        self.navigationItem.title = categoryName
//        self.navigationController?.navigationBar.titleTextAttributes =
//            [NSAttributedString.Key.foregroundColor: AppColors.charcol,
//             NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBold.rawValue, size: 18)!]
//        self.navigationController?.navigationBar.barTintColor = .white
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
//        let logo = UIImage(named: "group-1")
//        let imageView = UIImageView(image:logo)
//        imageView.contentMode = .scaleAspectFit
//        self.navigationItem.titleView = imageView
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        tabBar.setTabBarHidden(tabBarHidden: true)
    }
    
    //MARK: - ConfigUI
    private func configUI() {
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        noDataLbl.isHidden = true
        collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        sortTblView.register(UINib(nibName: TABLE_VIEW_CELL.ReportTypeCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ReportTypeCell.rawValue)
        sortBackView.isHidden = true
        productListVM.delegate = self
        
        page = 1
        hasMore = false
        category.removeAll()
        productListArray.removeAll()
        category.append(categoryRef)
        let request = ProductListRequest(category: category,sort: sortIndex, page: page, gender: gender)
        productListVM.ProductList(productListRequest: request)
        
        addRefreshControl()
        
        BookMarkAddVM.bookmarkInfo.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.BookMarkAddVM.success.value {
                let index = self.productListArray.firstIndex { (data) -> Bool in
                    data.id == self.BookMarkAddVM.bookmarkInfo.value.ref
                }
                if index != nil {
                    self.productListArray[index!].isBookmark = self.BookMarkAddVM.bookmarkInfo.value.status
                    self.collectionView.reloadData()
                }
                
                if self.ProductHomeVM.productList.value.count != 0 {
                    let index = self.ProductHomeVM.productList.value.firstIndex { (data) -> Bool in
                        data.id == self.categoryRef
                    }
                    if index != nil {
                        let index1 = self.ProductHomeVM.productList.value[index!].products.firstIndex { (data) -> Bool in
                            data.id == self.BookMarkAddVM.bookmarkInfo.value.ref
                        }
                        if index1 != nil {
                            self.ProductHomeVM.productList.value[index!].products[index1!].isBookmark = self.BookMarkAddVM.bookmarkInfo.value.status
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Button Click
    @IBAction func clicKToBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - addRefreshControl
    private func addRefreshControl() {
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_ :)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:16/255, green:27/255, blue:57/255, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "")
    }
    
    //MARK: - refreshData
    @objc func refreshData(_ sender: Any) {
        clearFilter = true
//        shimmerView.isHidden = false
//        shimmerView.isSkeletonable = true
//        shimmerView.showAnimatedGradientSkeleton()
        productListArray.removeAll()
        lastContentOffset = 0
        page = 1
        gender = 3
        hasMore = false
        sortIndex = 1
        let request = ProductListRequest(category: category, sort: sortIndex, page: page, gender: gender)
        productListVM.ProductList(productListRequest: request)
    }
    
    //MARK: - searchBtnIsPressed
    @IBAction func searchBtnIsPressed(_ sender: UIBarButtonItem) {
//        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
//        vc.searchType = .product
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK: - backBtnIsPressed
    // info: - changed to back Btn 
    @IBAction func filterBtnIsPressed(_ sender: UIBarButtonItem) {
//        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
//        vc.delegate = self
//        vc.filterType = .shopping
//        self.navigationController?.pushViewController(vc, animated: false)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSortBy(_ sender: Any) {
        sortBackView.isHidden = false
        displaySubViewtoParentView(UIApplication.shared.windows.last, subview: sortBackView)
        UIView.animate(withDuration: 0.25) {
            self.sortAnimationBackView.center.y -= self.sortAnimationBackView.frame.height
        }
    }
    
    @IBAction func clickToRemoveSort(_ sender: Any) {
        UIView.animate(withDuration: 0.1, animations: {
            self.sortAnimationBackView.center.y += self.sortAnimationBackView.frame.height
        }) { (success) in
            self.sortBackView.isHidden = true
        }
    }
    
    //MARK: - clickToFilter
    @IBAction func clickToFilter(_ sender: Any) {
        let selectedCategory: PRODUCT_CATEGORIES = PRODUCT_CATEGORIES(rawValue: categoryRef) ?? .ACCESSORIES
        switch selectedCategory {
        case .CLOTHING:
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: HOME_STORYBOARD.CategoryFilterVC.rawValue) as! CategoryFilterVC
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            vc.clearFilter = self.clearFilter
            vc.selectedFilter = .clothing
            self.present(vc, animated: true, completion: nil)
        case .BEAUTY:
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: HOME_STORYBOARD.CategoryFilterVC.rawValue) as! CategoryFilterVC
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            vc.clearFilter = self.clearFilter
            vc.selectedFilter = .beauty
            self.present(vc, animated: true, completion: nil)
        case .ACCESSORIES:
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: HOME_STORYBOARD.CategoryFilterVC.rawValue) as! CategoryFilterVC
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            vc.clearFilter = self.clearFilter
            vc.selectedFilter = .Accessories
            self.present(vc, animated: true, completion: nil)
        case .HEALTH:
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: HOME_STORYBOARD.FilterVC.rawValue) as! FilterVC
            vc.filterType = .health
            vc.delegate = self
            vc.clearFilter = self.clearFilter
            let navBar = UINavigationController(rootViewController: vc)
            navBar.modalPresentationStyle = .fullScreen
            self.present(navBar, animated: true, completion: nil)
        case .FOOD:
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: HOME_STORYBOARD.FilterVC.rawValue) as! FilterVC
            vc.filterType = .food
            vc.delegate = self
            vc.clearFilter = self.clearFilter
            let navBar = UINavigationController(rootViewController: vc)
            navBar.modalPresentationStyle = .fullScreen
            self.present(navBar, animated: true, completion: nil)
        case .MISCELLANEOUS:
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: HOME_STORYBOARD.FilterVC.rawValue) as! FilterVC
            vc.filterType = .miscellaneous
            vc.delegate = self
            vc.clearFilter = self.clearFilter
            let navBar = UINavigationController(rootViewController: vc)
            navBar.modalPresentationStyle = .fullScreen
            self.present(navBar, animated: true, completion: nil)
        case .DRINK:
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: HOME_STORYBOARD.FilterVC.rawValue) as! FilterVC
            vc.filterType = .drink
            vc.delegate = self
            vc.clearFilter = self.clearFilter
            let navBar = UINavigationController(rootViewController: vc)
            navBar.modalPresentationStyle = .fullScreen
            self.present(navBar, animated: true, completion: nil)
        }
    }
}

//MARK: - Collection View Data Source and delegate methods
extension ProductVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productListArray.count
    }
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else { return UICollectionViewCell() }
        if !productListArray.isEmpty {
            cell.productImage.downloadCachedImageWithLoader(placeholder: "rectangle", urlString: AppImageUrl.small + (productListArray[indexPath.row].images.first ?? ""))
            if !productListArray[indexPath.row].currency.isEmpty {
                cell.priceLbl.text = productListArray[indexPath.row].currency + productListArray[indexPath.row].price
            } else {
                cell.priceLbl.text = STATIC_LABELS.currencySymbol.rawValue + productListArray[indexPath.row].price
            }
            
            cell.productNameLbl.text = productListArray[indexPath.row].brandName
            cell.brandNameLbl.text = productListArray[indexPath.row].name
            
            cell.bookmarkBtn.isSelected = productListArray[indexPath.row].isBookmark
            cell.bookmarkBtn.tag = indexPath.row
            cell.bookmarkBtn.addTarget(self, action: #selector(self.clickToBookmark), for: .touchUpInside)
        }
        return cell
    }
    
    // sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellW = (collectionView.frame.width / 2) - 5
        let cellH = cellW + 116 //(collectionView.frame.height / 2)
        return CGSize(width: cellW, height: cellH)
    }
    
    // didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        vc.productId = productListArray[indexPath.row].id
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //willDisplay
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //Pagination
        if indexPath.row == productListArray.count - 1 && hasMore == true{
            page = page + 1
            let request = ProductListRequest(category: category, sort: sortIndex, page: page, gender: gender)
            productListVM.ProductList(productListRequest: request)
        }
    }
    
    //MARK: - Scroll animation Methods
    // scrollViewWillBeginDragging
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.y
    }
    
    @objc func clickToBookmark(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            
        }
        else {
            AppDelegate().sharedDelegate().vibrateOnTouch()
            BookMarkAddVM.addBookmark(request: BookmarkAddRequest(ref: productListArray[sender.tag].id, refType: BOOKMARK_TYPES.PRODUCT.rawValue, status: !productListArray[sender.tag].isBookmark))
        }
    }
    
}

extension ProductVC: UpdateProductBookmarkList {
    func updateProductListWithBokmark(productRef: String, status: Bool) {
        let index = self.productListArray.firstIndex { (data) -> Bool in
            data.id == productRef
        }
        if index != nil {
            self.productListArray[index!].isBookmark = status
            self.collectionView.reloadData()
        }
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension ProductVC: UITableViewDelegate, UITableViewDataSource {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SORT_ARR.allCases.count
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66 //UITableView.automaticDimension
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ReportTypeCell.rawValue, for: indexPath) as? ReportTypeCell else { return UITableViewCell() }
        
        cell.reportReasonLbl.text = SORT_ARR.allCases[indexPath.row].getString()
        
        if sortIndex == SORT_ARR.allCases[indexPath.row].rawValue {
            cell.circleImage.image = UIImage.init(named: "circle_selected")
        }else{
            cell.circleImage.image = UIImage.init(named: "circle_empty")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sortIndex = SORT_ARR.allCases[indexPath.row].rawValue
        sortTblView.reloadData()
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        productListArray.removeAll()
        page = 1
        hasMore = false
        let request = ProductListRequest(category: category, sort: sortIndex, page: page)
        productListVM.ProductList(productListRequest: request)
        
        UIView.animate(withDuration: 0.45, animations: {
            self.sortAnimationBackView.center.y += self.sortAnimationBackView.frame.height
        }) { (success) in
            self.sortBackView.isHidden = true
        }
    }
}


//MARK: - ProductListDelegate
extension ProductVC: ProductListDelegate {
    func didRecieveProductListResponse(productListResponse: ProductListResponse) {
        self.refreshControl.endRefreshing()
        shimmerView.hideSkeleton()
        shimmerView.isHidden = true
        hasMore = productListResponse.hasMore
        productListArray += productListResponse.data
        log.success(productListResponse.message)/
        
        if !productListArray.isEmpty {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        if productListArray.isEmpty {
            noDataLbl.isHidden = false
        }else {
            noDataLbl.isHidden = true
        }
    }
}

//MARK: - FilterDelegate
extension ProductVC: FilterDelegate {
    func didRecieveFilterParams(category: [Int]) {
        clearFilter = false
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        productListArray.removeAll()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        hasMore = false
        page = 1
        sortIndex = 1
        let filter = category
        let productRequest = ProductListRequest(category: self.category,sort: sortIndex, page: page, filter: filter)
        productListVM.ProductList(productListRequest: productRequest)
    }
    
    func didRecieveCategoryFilterParams(category: [Int], gender: SELECTED_FILTER_GENDER) {
        clearFilter = false
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        productListArray.removeAll()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        hasMore = false
        page = 1
        sortIndex = 1
        self.gender = gender.getIntValue()
        let filter = category
        let productRequest = ProductListRequest(category: self.category, sort: sortIndex, page: page, filter: filter, gender: self.gender)
        productListVM.ProductList(productListRequest: productRequest)
    }
}
