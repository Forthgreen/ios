//
//  MyBrandListVC.swift
//  forthgreen
//
//  Created by MACBOOK on 07/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import SkeletonView
import SainiUtils

class MyBrandListVC: UIViewController {
    
    @IBOutlet weak var bottomConstraintOfTableView: NSLayoutConstraint!
    @IBOutlet weak var segmentControlView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var guestLoginLbl: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var guestUserView: GuestUserView!
    @IBOutlet var backBtn: UIButton!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            print("Products selected")
            //show Products view
            segmentControl.selectedSegmentIndex = 0
            followingType = .product
        case 1:
            print("Brands selected")
            //show Brands view
            segmentControl.selectedSegmentIndex = 1
            followingType = .brand
        case 2:
            print("Restaurant selected")
            segmentControl.selectedSegmentIndex = 2
            //show Restaurant view
            followingType = .restaurant
        default:
            break;
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
    private let refreshControl = UIRefreshControl()
    private var myBrandListVM: MyBrandListViewModel = MyBrandListViewModel()
    private var followingRestaurantListVM: FollowingRestaurantListViewModel = FollowingRestaurantListViewModel()
    private var followingProductListVM: FollowingProductListingViewModel = FollowingProductListingViewModel()
    private var BookMarkListVM: BookMarkListViewModel = BookMarkListViewModel()
//    var brandListArray:[Brand] = [Brand]()
//    var followedRestaurantListArray: [FollowingRestaurantList] = [FollowingRestaurantList]()
//    private var followingProductListArray: [ProductList] = [ProductList]()
    var followingType: REVIEW_TYPE = .none
    var showShimmer = true
//    private var hasMore:Bool = false
//    private var page = 1
    var isFromSetting: Bool = false
    
    var productCurrentPage: Int = 1
    var productHasMore: Bool = false
    
    var brandCurrentPage: Int = 1
    var brandHasMore: Bool = false
    
    var restaurantCurrentPage: Int = 1
    var restaurantHasMore: Bool = false
    
    private var locationManager: SainiLocationManager = SainiLocationManager()
    var longitude: Double = Double()
    var latitude: Double = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfigUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.titleTextAttributes =
//            [NSAttributedString.Key.foregroundColor: AppColors.charcol,
//             NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBold.rawValue, size: 18)!]
    
        //        log.success("MyBrandList observer added successfully!")/
        //NotificationCenter.default.addObserver(self, selector: #selector(RefreshBrandList(noti:)), name: NOTIFICATIONS.Refresh, object: nil)
        
        if isFromSetting {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
        else{
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: false)
        }
        
        backBtn.isHidden = !isFromSetting
        
        if AppModel.shared.isGuestUser == true{
            showGuestView()
//            self.navigationController?.setNavigationBarHidden(true, animated: false)
            tableView.isHidden = true
            segmentControlView.isHidden = true
            log.todo("Guest user is there")/
            return
        }
        else{
            guestUserView.isHidden = true
            segmentControlView.isHidden = false
            tableView.isHidden = false
            if segmentControl.selectedSegmentIndex == 0 {
                followingType = .product
            }
            else if segmentControl.selectedSegmentIndex == 1 {
                followingType = .brand
            }
            else {
                followingType = .restaurant
            }
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
//        if SCREEN.HEIGHT >= 812 {
//            bottomConstraintOfTableView.constant = 76
//        } else {
//            bottomConstraintOfTableView.constant = 56
//        }
    }
    
    //MARK: - viewWillDisppear
    override func viewWillDisappear(_ animated: Bool) {
    //    NotificationCenter.default.removeObserver(self)
//        self.navigationController?.navigationBar.isHidden = true
        log.success("MyBrandList observer removed successfully!")/
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        let attr = NSDictionary(object: UIFont(name: "BuenosAires-Bold", size: 12.0)!, forKey: NSAttributedString.Key.font as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as? [NSAttributedString.Key : Any] , for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAllApi), name: NOTIFICATIONS.BookmarkUpdateList, object: nil)
        
        guestUserView.crossBtn.isHidden = true
        segmentControl.selectedSegmentIndex = 0
        followingType = .product
        //        guestUserLoginGesture()
        
        
        followingProductListVM.delegate = self
        myBrandListVM.delegate = self
        followingRestaurantListVM.delegate = self
        //        signUpBtn.layer.cornerRadius = 5
        
        tableView.register(UINib(nibName: "BrandListCell", bundle: nil), forCellReuseIdentifier: "BrandListCell")
        tableView.register(UINib(nibName: "RestaurantNewTVC", bundle: nil), forCellReuseIdentifier: "RestaurantNewTVC")
        
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
        
        if AppModel.shared.isGuestUser{
            shimmerView.isHidden = true
            return
        }
        else{
            
//            brandListArray.removeAll()
//            hasMore = false
//            page = 1
//            myBrandListVM.brandList(myBrandRequest: MyBrandRequest(), page: page)
//            followedRestaurantListArray.removeAll()
//            followingRestaurantListVM.fetchFollowingRestaurantList(page: page)
//            followingProductListVM.fetchProductListing(page: page)
            
            BookMarkListVM.productList.bind { [weak self](_) in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    
                    
//                    if self.BookMarkListVM.productList.value.count != 0 {
                        self.shimmerView.hideSkeleton()
                        self.shimmerView.isHidden = true
                        self.tableView.reloadData()
//                    }
                }
            }

            BookMarkListVM.productHasMore.bind { [weak self](_) in
                guard let `self` = self else { return }
                self.productHasMore = self.BookMarkListVM.productHasMore.value
            }
            
            
            BookMarkListVM.brandList.bind { [weak self](_) in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    
//                    if self.BookMarkListVM.brandList.value.count != 0 {
                        self.shimmerView.hideSkeleton()
                        self.shimmerView.isHidden = true
                        self.tableView.reloadData()
//                    }
                }
            }

            BookMarkListVM.brandHasMore.bind { [weak self](_) in
                guard let `self` = self else { return }
                self.brandHasMore = self.BookMarkListVM.brandHasMore.value
            }
            
            
            BookMarkListVM.restaurantList.bind { [weak self](_) in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    
//                    if self.BookMarkListVM.restaurantList.value.count != 0 {
                        self.shimmerView.hideSkeleton()
                        self.shimmerView.isHidden = true
                        self.tableView.reloadData()
//                    }
                }
            }

            BookMarkListVM.restaurantHasMore.bind { [weak self](_) in
                guard let `self` = self else { return }
                self.restaurantHasMore = self.BookMarkListVM.restaurantHasMore.value
            }
            
            shimmerView.isHidden = false
            shimmerView.isSkeletonable = true
            shimmerView.showAnimatedGradientSkeleton()
            
            if !AppModel.shared.isGuestUser{
                serviceCallToBrandList()
                serviceCallToProductList()
                
                if let currentLocation = locationManager.exposedLocation {
                    log.success("\(currentLocation)")/
                    latitude = currentLocation.coordinate.latitude
                    longitude = currentLocation.coordinate.longitude
                    serviceCallToRestaurantList()
                } else {
                    self.view.sainiShowToast(message: "Kindly enable your location services.")
                }
            }
        }
    }
    
    //MARK: - refreshData
    @objc func refreshData(_ sender: Any) {
        if AppModel.shared.isGuestUser{
            return
        }
//        shimmerView.isHidden = false
//        shimmerView.isSkeletonable = true
//        shimmerView.showAnimatedGradientSkeleton()
        
//        hasMore = false
//        page = 1
        if followingType == .brand {
       //     brandListArray.removeAll()
       //     myBrandListVM.brandList(myBrandRequest: MyBrandRequest(), page: page)
            
            serviceCallToBrandList()
//            BookMarkListVM.brandList.value.removeAll()
//            brandHasMore = false
//            refreshControl.endRefreshing()
//            brandCurrentPage = 1
//
//            BookMarkListVM.getBookMarkBrandListing(request: BookmarkListRequest(page: page, refType: BOOKMARK_TYPES.BRAND.rawValue))
        }
        else if followingType == .restaurant {
       //     followedRestaurantListArray.removeAll()
       //     followingRestaurantListVM.fetchFollowingRestaurantList(page: page)
            
            serviceCallToRestaurantList()
            
//            BookMarkListVM.restaurantList.value.removeAll()
//            restaurantHasMore = false
//            refreshControl.endRefreshing()
//            restaurantCurrentPage = 1
//
//            BookMarkListVM.getBookMarkRestaurantListing(request: BookmarkListRequest(page: restaurantCurrentPage, refType: BOOKMARK_TYPES.RESTAURANT.rawValue))
        }
        else if followingType == .product {
       //     followingProductListArray.removeAll()
       //     followingProductListVM.fetchProductListing(page: page)
            
            serviceCallToProductList()
            
//            BookMarkListVM.productList.value.removeAll()
//            productHasMore = false
//            refreshControl.endRefreshing()
//            productCurrentPage = 1
//
//            self.BookMarkListVM.getBookMarkProductListing(request: BookmarkListRequest(page: self.productCurrentPage, refType: BOOKMARK_TYPES.PRODUCT.rawValue))
        }
    }
    
    
    //MARK: - Button Click
    @IBAction func clicKToBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func serviceCallToBrandList() {
        BookMarkListVM.brandList.value.removeAll()
        brandHasMore = false
        refreshControl.endRefreshing()
        brandCurrentPage = 1
        
        BookMarkListVM.getBookMarkBrandListing(request: BookmarkListRequest(page: brandCurrentPage, refType: BOOKMARK_TYPES.BRAND.rawValue))
    }
    
    @objc func serviceCallToRestaurantList() {
        BookMarkListVM.restaurantList.value.removeAll()
        restaurantHasMore = false
        refreshControl.endRefreshing()
        restaurantCurrentPage = 1
        
        if let currentLocation = locationManager.exposedLocation {
            log.success("\(currentLocation)")/
            latitude = currentLocation.coordinate.latitude
            longitude = currentLocation.coordinate.longitude
            BookMarkListVM.getBookMarkRestaurantListing(request: BookmarkListRequest(longitude: longitude, latitude: latitude, page: restaurantCurrentPage, refType: BOOKMARK_TYPES.RESTAURANT.rawValue))
        } else {
            self.view.sainiShowToast(message: "Kindly enable your location services.")
        }
    }
    
    @objc func serviceCallToProductList() {
        BookMarkListVM.productList.value.removeAll()
        productHasMore = false
        refreshControl.endRefreshing()
        productCurrentPage = 1
        
        self.BookMarkListVM.getBookMarkProductListing(request: BookmarkListRequest(page: self.productCurrentPage, refType: BOOKMARK_TYPES.PRODUCT.rawValue))
    }
    
    @objc func refreshAllApi() {
        if AppModel.shared.isGuestUser{
            return
        }
        serviceCallToBrandList()
        serviceCallToRestaurantList()
        serviceCallToProductList()
    }
    
    //AMRK:- RefreshBrandList
    @objc func RefreshBrandList(noti : Notification)
    {
        //Refreshing Brand data
        if AppModel.shared.isGuestUser {
            showGuestView()
            tableView.isHidden = true
            log.todo("Guest user is there")/
            return
        }
        else{
            guestUserView.isHidden = true
            tableView.isHidden = false
        }
//        BookMarkListVM.brandList.value.removeAll()
//        hasMore = false
//        page = 1
//        myBrandListVM.brandList(myBrandRequest: MyBrandRequest(), page: page)
    }
    
    //MARK: - guestUserLoginGesture
    private func guestUserLoginGesture(){
        guestLoginLbl.sainiAddTapGesture {
            AppModel.shared.guestUserType = .BrandListing
            let vc: LoginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as!  LoginVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK:- clickGuestSignUpBtn
    @IBAction func clickGuestSignUpBtn(_ sender: UIButton) {
        //        AppModel.shared.guestUserType = .BrandListing
        //        let vc: WelcomeVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "WelcomeVC") as!  WelcomeVC
        //        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func showGuestView() {
        self.showLoginAlert()
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
    
    deinit{
        log.success("MyBrandListVC deallocated successfully!")/
    }
    
}

extension MyBrandListVC: AlertDelegate {
    func didClickOkBtn() {
        (UIApplication.shared.delegate as? AppDelegate)?.logoutUser()
    }
    
    func didClickCancelBtn() {
        
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension MyBrandListVC: UITableViewDelegate,SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "BrandListCell"
    }
    
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if followingType == .restaurant {
            if BookMarkListVM.restaurantList.value.count == 0 {
                tableView.sainiSetEmptyMessage("You haven’t saved any restaurants yet")
                return 0
            }
            tableView.restore()
            tableView.separatorStyle = .none
            return BookMarkListVM.restaurantList.value.count
        }
        else if followingType == .brand {
            if BookMarkListVM.brandList.value.count == 0 {
                tableView.sainiSetEmptyMessage("You haven’t saved any  brands yet")
                return 0
            }
            tableView.restore()
            tableView.separatorStyle = .none
            return BookMarkListVM.brandList.value.count
        }
        else if followingType == .product { // for products
            if BookMarkListVM.productList.value.count == 0 {
                tableView.sainiSetEmptyMessage("You haven’t saved any products yet")
                return 0
            }
            tableView.restore()
            tableView.separatorStyle = .none
            return BookMarkListVM.productList.value.count
        }
        else {
            return 0
        }
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if followingType == .restaurant { // for restaurant
            return UITableView.automaticDimension
        }
        else if followingType == .brand { // for brands
            return 100
        }
        else if followingType == .product {  // for products
            return 116
        }
        else {
            return 0
        }
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if followingType == .restaurant {// for restaurant
            if BookMarkListVM.restaurantList.value.isEmpty {
                return UITableViewCell()
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantNewTVC", for: indexPath) as? RestaurantNewTVC else {
                return UITableViewCell()
            }
            cell.restaurantImageView.downloadCachedImageWithLoader(placeholder: "rectangle", urlString: AppImageUrl.average + (BookMarkListVM.restaurantList.value[indexPath.row].thumbnail))
            cell.restaurantNameLbl.text = BookMarkListVM.restaurantList.value[indexPath.row].name
            cell.starRatingView.rating = BookMarkListVM.restaurantList.value[indexPath.row].ratings?.averageRating ?? DocumentDefaultValues.Empty.double
            cell.ratingCountLbl.text = "\(BookMarkListVM.restaurantList.value[indexPath.row].ratings?.count ?? DocumentDefaultValues.Empty.int)"
            cell.dishTypeLbl.text = BookMarkListVM.restaurantList.value[indexPath.row].typeOfFood
            let count = BookMarkListVM.restaurantList.value[indexPath.row].price.count
            print(count)
            let myString: NSString = "$$$"
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "BuenosAires-Bold", size: 14.0)!])
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.turqoiseGreen, range: NSRange(location:0,length:count))
            // set label Attribute
            cell.priceLbl.attributedText = myMutableString
            let distance = (BookMarkListVM.restaurantList.value[indexPath.row].distance) * 0.00062137
            cell.distanceLbl.text = String(format: "%0.1f", distance) + " miles"
            return cell
        }
        else if followingType == .brand { // for brands
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BrandListCell", for: indexPath) as? BrandListCell else {
                return UITableViewCell()
            }
            //hide show notification count
            if BookMarkListVM.brandList.value.count > 0 {
                cell.brandCountView.isHidden = BookMarkListVM.brandList.value[indexPath.row].count != 0 ? false : true
                cell.renderProfileImage(circle: true)
                cell.priceLbl.isHidden = true
                cell.brandNameLbl.text = BookMarkListVM.brandList.value[indexPath.row].brandName
                //cell.brandCountLbl.text = "\(brandListArray[indexPath.row].count)"
                cell.brandImage.downloadCachedImageWithLoader(placeholder: "placeholder", urlString: AppImageUrl.small + BookMarkListVM.brandList.value[indexPath.row].logo)
                cell.followersCountLbl.isHidden = true
            }
            return cell
        } else if followingType == .product {    // for Products
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BrandListCell", for: indexPath) as? BrandListCell else {
                return UITableViewCell()
            }
            if BookMarkListVM.productList.value.count > 0 {
                cell.brandCountView.isHidden = true
                cell.renderProfileImage(circle: false)
                cell.priceLbl.isHidden = false
                if !BookMarkListVM.productList.value[indexPath.row].currency.isEmpty {
                    cell.priceLbl.text = BookMarkListVM.productList.value[indexPath.row].currency + BookMarkListVM.productList.value[indexPath.row].price
                } else {
                    cell.priceLbl.text = STATIC_LABELS.currencySymbol.rawValue + BookMarkListVM.productList.value[indexPath.row].price
                }
                
                cell.brandNameLbl.text = BookMarkListVM.productList.value[indexPath.row].brandName
                cell.followersCountLbl.text = BookMarkListVM.productList.value[indexPath.row].name
                cell.brandImage.downloadCachedImageWithLoader(placeholder: "placeholder", urlString: AppImageUrl.average + (BookMarkListVM.productList.value[indexPath.row].images.first ?? DocumentDefaultValues.Empty.string))
                cell.followersCountLbl.isHidden = false
                
            }
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    // willDisplay
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if followingType == .restaurant { // for resraurants
            if indexPath.row == BookMarkListVM.restaurantList.value.count - 1 && restaurantHasMore == true{
                restaurantCurrentPage = restaurantCurrentPage + 1
                BookMarkListVM.getBookMarkRestaurantListing(request: BookmarkListRequest(page: restaurantCurrentPage, refType: BOOKMARK_TYPES.RESTAURANT.rawValue))
            }
        }
        else if followingType == .brand { // for brands
            if indexPath.row == BookMarkListVM.brandList.value.count - 1 && brandHasMore == true{
                brandCurrentPage = brandCurrentPage + 1
                BookMarkListVM.getBookMarkBrandListing(request: BookmarkListRequest(page: brandCurrentPage, refType: BOOKMARK_TYPES.BRAND.rawValue))
            }
        }
        else if followingType == .product { // for products
            if indexPath.row == BookMarkListVM.productList.value.count - 1 && productHasMore == true {
                productCurrentPage = productCurrentPage + 1
                BookMarkListVM.getBookMarkProductListing(request: BookmarkListRequest(page: productCurrentPage, refType: BOOKMARK_TYPES.PRODUCT.rawValue))
            }
        }
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if followingType == .restaurant { // for resraurants
            let vc = STORYBOARD.RESTAURANT.instantiateViewController(withIdentifier: "RestaurantDetailVC") as! RestaurantDetailVC
            vc.distance = BookMarkListVM.restaurantList.value[indexPath.row].distance
            vc.restaurantId = BookMarkListVM.restaurantList.value[indexPath.row].id
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if followingType == .brand { // for brands
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BrandDetailVC") as! BrandDetailVC
            vc.brandId = BookMarkListVM.brandList.value[indexPath.row].id
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if followingType == .product { // for products
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            vc.isTransition = false
            vc.delegate = self
            vc.productId = BookMarkListVM.productList.value[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MyBrandListVC: UpdateProductBookmarkList, UpdateBrandBookmarkList, UpdateRestaurantBookmarkList {
    func updateRestaurantListWithBokmark(restaurantRef: String, status: Bool) {
        let index = self.BookMarkListVM.restaurantList.value.firstIndex { (data) -> Bool in
            data.id == restaurantRef
        }
        if index != nil {
            self.BookMarkListVM.restaurantList.value.remove(at: index!)
            self.tableView.reloadData()
        }
    }
    
    func updateBrandListWithBokmark(brandRef: String, status: Bool) {
        let index = self.BookMarkListVM.brandList.value.firstIndex { (data) -> Bool in
            data.id == brandRef
        }
        if index != nil {
            self.BookMarkListVM.brandList.value.remove(at: index!)
            self.tableView.reloadData()
        }
    }
    
    func updateProductListWithBokmark(productRef: String, status: Bool) {
        let index = self.BookMarkListVM.productList.value.firstIndex { (data) -> Bool in
            data.id == productRef
        }
        if index != nil {
            self.BookMarkListVM.productList.value.remove(at: index!)
            self.tableView.reloadData()
        }
        else {
            
        }
    }
}

//MARK: - MyBrandListDelegate
extension MyBrandListVC:MyBrandListDelegate{
    func didReceiveMyBrandListResponse(response: MyBrandResponse) {
        self.refreshControl.endRefreshing()
//        hasMore = response.hasMore
        BookMarkListVM.brandList.value += response.data
        //        let brandSum = brandListArray.reduce(0, { sum, brand in
        //            sum + brand.count
        //        })
        //        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        //        if brandSum > 0 {
        //            tabBar.isNewBrandAdded(isBrandAdded: true)
        //        }
        //        else{
        //            tabBar.isNewBrandAdded(isBrandAdded: false)
        //        }
        shimmerView.hideSkeleton()
        shimmerView.isHidden = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - FollowingRestaurantListDelegate
extension MyBrandListVC: FollowingRestaurantListDelegate {
    func didRecieveFollowingRestaurantListResponse(response: FollowingRestaurantListingResponse) {
        self.refreshControl.endRefreshing()
        //        self.restaurantRefreshControl.endRefreshing()
        shimmerView.hideSkeleton()
        shimmerView.isHidden = true
        log.success(response.message)/
//        hasMore = response.hasMore
//        followedRestaurantListArray += response.data
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - FollowingProductListingDelegate
extension MyBrandListVC: FollowingProductListingDelegate {
    func didRecieveFollowingProductListingResponse(response: FollowingProductListResponse) {
        log.success(response.message)/
        self.refreshControl.endRefreshing()
        shimmerView.hideSkeleton()
        shimmerView.isHidden = true
        log.success(response.message)/
  //      hasMore = response.hasMore
   //     followingProductListArray += response.data
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


//extension MyBrandListVC: BookMarkListDelegate {
//    func didRecieveBookmarkProductListingResponse(response: ProductListResponse) {
//        log.success(response.message)/
//        self.refreshControl.endRefreshing()
//        shimmerView.hideSkeleton()
//        shimmerView.isHidden = true
//        log.success(response.message)/
//        hasMore = response.hasMore
//        followingProductListArray += response.data
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
//
//    func didRecieveBookmarkBrandListingResponse(response: MyBrandResponse) {
//        self.refreshControl.endRefreshing()
//        hasMore = response.hasMore
//        brandListArray += response.data
////        let brandSum = brandListArray.reduce(0, { sum, brand in
////            sum + brand.count
////        })
////        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
////        if brandSum > 0 {
////            tabBar.isNewBrandAdded(isBrandAdded: true)
////        }
////        else{
////            tabBar.isNewBrandAdded(isBrandAdded: false)
////        }
//        shimmerView.hideSkeleton()
//        shimmerView.isHidden = true
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
//
//    func didRecieveBookmarkRestaurantListingResponse(response: FollowingRestaurantListingResponse) {
//        self.refreshControl.endRefreshing()
//        //        self.restaurantRefreshControl.endRefreshing()
//        shimmerView.hideSkeleton()
//        shimmerView.isHidden = true
//        log.success(response.message)/
//        hasMore = response.hasMore
//        followedRestaurantListArray += response.data
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
//
//
//}
