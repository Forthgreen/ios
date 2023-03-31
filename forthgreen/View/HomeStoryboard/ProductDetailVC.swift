//
//  ProductDetailVC.swift
//  forthgreen
//
//  Created by MACBOOK on 05/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import Branch

protocol UpdateProductBookmarkList {
    func updateProductListWithBokmark(productRef: String, status: Bool)
}

class ProductDetailVC: UIViewController {
    
    private var productDetailVM: ProductDetailViewModel = ProductDetailViewModel()
    private var statisticVM: StatisticsViewModel = StatisticsViewModel()
    private var saveProductVM: FollowProductViewModel = FollowProductViewModel()
    private var BookMarkAddVM: BookMarkAddViewModel = BookMarkAddViewModel()
    var ProductHomeVM: ProductHomeViewModel = ProductHomeViewModel()
    var productId: String = String()
    var productDetail: ProductDetail = ProductDetail()
    var localSource: [ImageSource] = [ImageSource]()
    private var userId: String = String()
    var isTransition: Bool = Bool()
    var delegate: UpdateProductBookmarkList?
    
    var isFromProductDetail: Bool = false
    var categoryId: Int = Int()
    
    @IBOutlet var guestUserView: GuestUserView!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfigUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if AppModel.shared.showNabBarView == .Yes{
//            self.navigationController?.navigationBar.isHidden = false
//            self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        }
//        else{
//            self.navigationController?.navigationBar.isHidden = true
//            self.navigationController?.setNavigationBarHidden(true, animated: animated)
//        }
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.titleTextAttributes =
//            [NSAttributedString.Key.foregroundColor: AppColors.charcol,
//             NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBold.rawValue, size: 18)!]
        
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
        
        //MARK:- if Product sharing option is available only for logged in Users uncomment below code
//        if AppModel.shared.isGuestUser {
//            self.navigationItem.rightBarButtonItem?.image = UIImage()
//            self.navigationItem.rightBarButtonItem?.isEnabled = false
//        }
//        else {
//            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
//            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "iconShareArtciel")
//            self.navigationItem.rightBarButtonItem?.isEnabled = true
//        }
        
//        MARK:- if Product sharing option is available for logged in Users as well as for guest Users
//        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
//        self.navigationItem.rightBarButtonItem?.image = UIImage(named: "iconShareArtciel")
//        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        BookMarkAddVM.bookmarkInfo.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.BookMarkAddVM.success.value {
                if self.isFromProductDetail {
                    self.productDetail.isBookmark = self.BookMarkAddVM.bookmarkInfo.value.status
                    self.tableView.reloadData()
                    self.delegate?.updateProductListWithBokmark(productRef: self.BookMarkAddVM.bookmarkInfo.value.ref, status: self.BookMarkAddVM.bookmarkInfo.value.status)
                }
                else {
                    let index = self.productDetail.similarProducts.firstIndex { (data) -> Bool in
                        data.id == self.BookMarkAddVM.bookmarkInfo.value.ref
                    }
                    if index != nil {
                        self.productDetail.similarProducts[index!].isBookmark = self.BookMarkAddVM.bookmarkInfo.value.status
                        self.tableView.reloadData()
                    }
                }
                
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
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.view.backgroundColor = .white
        
//        if isTransition {
//            self.navigationController?.setNavigationBarHidden(true, animated: animated)
//        }
//        else {
//            self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        }
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
//        guestUserView.crossBtn.addTarget(self, action: #selector(close(sender:)), for: .touchUpInside)
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        log.success("ProductDetails observer added successfully!")/
        NotificationCenter.default.addObserver(self, selector: #selector(RefreshProductDetails(noti:)), name: NOTIFICATIONS.RefreshProductReviews, object: nil)
        tableView.register(UINib(nibName: "ProductDetailCell", bundle: nil), forCellReuseIdentifier: "ProductDetailCell")
        tableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        tableView.register(UINib(nibName: "SimilarProductListCell", bundle: nil), forCellReuseIdentifier: "SimilarProductListCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        if let user = AppModel.shared.currentUser {
            userId = user.id
        }
        
        productDetailVM.delegate = self
        statisticVM.delegate = self
        saveProductVM.delegate = self
        
        if AppModel.shared.isGuestUser {
            let productRequest = ProductDetailRequest(productRef: productId)
            productDetailVM.productDetail(productDetailRequest: productRequest)
        }
        else {
            let productRequest = ProductDetailRequest(productRef: productId)
            productDetailVM.productDetail(productDetailRequest: productRequest)
            
            let statisticRequest = StatisticsRequest(productRef: productId)
            statisticVM.getProductStatistics(statisticRequest: statisticRequest)
        }
    }
    
    @objc func close(sender: UIButton){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.guestUserView.isHidden = true
        AppModel.shared.showNabBarView = .Yes
        self.tableView.isHidden = false
    }
    
    @objc func RefreshProductDetails(noti : Notification)
    {
        let productRequest = ProductDetailRequest(productRef: productId)
        productDetailVM.productDetail(productDetailRequest: productRequest)
    }
    
    //MARK: - Button Click
    @IBAction func clicKToBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Get Slide images
    func getImages(){
        let group = DispatchGroup()
        if productDetail.images.count > 0{
            self.localSource.removeAll()
            for pic in productDetail.images{
                group.enter()
                
                let remoteImageURL = URL(string: AppImageUrl.best + pic)
                Alamofire.request(remoteImageURL!).responseData { (response) in
                    if response.error == nil {
                        // Show the downloaded image:
                        if let data = response.data {
                            
                            let img = UIImage(data: data)
                            if img != nil {
                                log.success("\(response.result)")/
                                self.localSource.append(ImageSource(image: img!))
                                group.leave()
                            }
                        }
                    }
                    else{
                        log.error("\(String(describing: response.error))")/
                    }
                }
            }
            group.notify(queue: DispatchQueue.main) {
                log.success("\(self.localSource)")/
                log.success("*************IMAGE DOWNLOAD ACTION COMPLETE***************")/
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - shareProduct
    @IBAction func clickToShare(_ sender: UIButton) {
        let title = "Forthgreen"
        let desc = "\(productDetail.info)"
        let imgURL = "\(AppImageUrl.small + (self.productDetail.logo))"
        
        let buo = BranchUniversalObject()
        buo.canonicalIdentifier = "content/12345"
        buo.title = title
        buo.contentDescription = desc
        buo.imageUrl = imgURL
        buo.publiclyIndex = true
        buo.locallyIndex = true
        buo.contentMetadata.contentSchema = BranchContentSchema.commerceProduct
        buo.contentMetadata.customMetadata[BRANCH_IO.INTENT_DEEP_LINK_PAYLOAD] = productDetail.toJSON()
        
        let lp = BranchLinkProperties.init()
        lp.addControlParam(BRANCH_IO.INTENT_DEEP_LINK_TIME_STAMP, withValue: getCurrentTimeStampValue())
        lp.addControlParam(BRANCH_IO.INTENT_DEEP_LINK_PAYLOAD_MAPPING, withValue: PayloadMappingType.product.rawValue)
        
        buo.getShortUrl(with: lp) { (url, error) in
            if error == nil {
                let strShare = "Check out what product I just found in Forthgreen! \(self.productDetail.name) link to the app " + url!
                let activityViewController = UIActivityViewController(activityItems: [strShare] , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - threeDotsBtnOfReviewIsPressed
    @objc func threeDotsBtnOfReviewIsPressed(sender: UIButton) {
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            log.result("Cancel")/
        }
        actionSheet.addAction(cancelButton)
        
        let reportBtn = UIAlertAction(title: "Report Abuse", style: .destructive)
        { _ in
            log.result("Report Abuse")/
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ReportAbuseVC") as! ReportAbuseVC
            vc.reportType = .product
            vc.reviewId = self.productDetail.ratingAndReview[sender.tag].id
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
        actionSheet.addAction(reportBtn)
        
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        actionSheet.popoverPresentationController?.permittedArrowDirections = []
        actionSheet.view.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - backBTnISPRessed
    @IBAction func backBtnIsPressed(_ sender: UIBarButtonItem) {
        isTransition = false
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - TableView DataSource and Delegate Methods
extension ProductDetailVC: UITableViewDataSource, UITableViewDelegate {
    // numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 1
        }
        else {
            if productDetail.ratingAndReview.count >= 5 {
                return 5
            }
            else {
                return productDetail.ratingAndReview.count
            }
        }
    }
    
    // estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 1 ? 500 : UITableView.automaticDimension
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailCell", for: indexPath) as? ProductDetailCell else {
                return UITableViewCell()
            }
            cell.productSmallImageView.downloadCachedImageWithLoader(placeholder: "placeholder", urlString: AppImageUrl.average + productDetail.logo)
            
            cell.productImages.contentScaleMode = .scaleAspectFill
            cell.productImages.setImageInputs(localSource)
            cell.productImages.circular = false
            cell.loaderView.sainiShowLoader(loaderColor: .gray)
            if localSource.count > 0  {
                cell.productImages.backgroundColor = .white
                cell.loaderView.isHidden = true
            }
            else if localSource.count == 0 {
                cell.productImages.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.9568627451, alpha: 1)
                 cell.loaderView.isHidden = false
            }
            else{
                 cell.productImages.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.9568627451, alpha: 1)
                 cell.loaderView.isHidden = false
            }
            
            cell.brandNameLbl.text = productDetail.name
            cell.starCountLbl.text = "\(productDetail.ratingAndReview.count)"
            if !productDetail.currency.isEmpty {
                cell.priceLbl.text = productDetail.currency + productDetail.price
            }
            else {
                cell.priceLbl.text = STATIC_LABELS.currencySymbol.rawValue + productDetail.price
            }   
            cell.aboutLbl.increaseLineSpacing(text: productDetail.info)
            cell.renderRatingStar(count: Int(productDetail.averageRating) )
            
            cell.brandImageView.sainiAddTapGesture {
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BrandDetailVC") as! BrandDetailVC
                vc.brandId = self.productDetail.brandRef
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            if productDetail.isFollowed {
                cell.saveBtn.setTitle(SAVE_BTN_TYPE.unsave.getUperCased(), for: .normal)
            }
            else {
                cell.saveBtn.setTitle(SAVE_BTN_TYPE.save.getUperCased(), for: .normal)
            }
            
            cell.bookmarkBtn.isSelected = productDetail.isBookmark
            cell.bookmarkBtn.tag = indexPath.row
            cell.bookmarkBtn.addTarget(self, action: #selector(self.clickToBookmark), for: .touchUpInside)
            
            cell.reviewBtn.addTarget(self, action: #selector(reviewBtnIsPressed), for: .touchUpInside)
            cell.websiteBtn.addTarget(self, action: #selector(websiteBtnIsPressed), for: .touchUpInside)
            cell.saveBtn.addTarget(self, action: #selector(saveBtnIsPressed), for: .touchUpInside)
            return cell
        }
        else if indexPath.section == 1 {
            if productDetail.similarProducts.count == 0 {
                return UITableViewCell()
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimilarProductListCell", for: indexPath) as? SimilarProductListCell else { return UITableViewCell() }
                    cell.isHidden = false
                    cell.productListArray = productDetail.similarProducts
                    cell.collectionView.delegate = self
                    cell.collectionView.dataSource = self
                    DispatchQueue.main.async {
                        cell.collectionView.reloadData()
                    }
                
                cell.writeReviewBtn.tag = indexPath.row
                cell.writeReviewBtn.addTarget(self, action: #selector(self.reviewBtnIsPressed), for: .touchUpInside)
                
                return cell
            }
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell else {
                return UITableViewCell()
            }
            cell.threeDotsBtn.isHidden = false
            cell.threeDotsBtn.tag = indexPath.row
            cell.threeDotsBtn.addTarget(self, action: #selector(threeDotsBtnOfReviewIsPressed(sender: )), for: .touchUpInside)
            cell.profileProductImage.downloadCachedImage(placeholder: "ic_placeholder", urlString: AppImageUrl.average + productDetail.ratingAndReview[indexPath.row].image)
            cell.renderProfileImage(circle: true)
            cell.reviewTitleLbl.text = productDetail.ratingAndReview[indexPath.row].title
            cell.reviewTextLbl.increaseLineSpacing(text: productDetail.ratingAndReview[indexPath.row].review)
            cell.nameLbl.text = productDetail.ratingAndReview[indexPath.row].fullName
            cell.renderRatingStar(count: productDetail.ratingAndReview[indexPath.row].rating )
            cell.renderProfileImage(circle:true)
            if AppModel.shared.isGuestUser {
                cell.threeDotsBtn.isHidden = true
            }
            else{
                if productDetail.ratingAndReview[indexPath.row].userRef == AppModel.shared.currentUser?.id {
                    cell.threeDotsBtn.isHidden = true
                }
            }
            
            cell.profileBtn.tag = indexPath.row
            cell.profileBtn.addTarget(self, action: #selector(self.clickToGoToProfile), for: .touchUpInside)
            cell.gotoProfileBtn.tag = indexPath.row
            cell.gotoProfileBtn.addTarget(self, action: #selector(self.clickToGoToProfile), for: .touchUpInside)
            return cell
        }
    }
    
//    @objc func clickToWriteReview(_ sender: UIButton) {
//
//    }
    
    //MARK: - clickToGoToProfile
    @objc func clickToGoToProfile(_ sender: UIButton) {
        if userId != productDetail.ratingAndReview[sender.tag].userRef {
            let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.OtherUserProfileVC.rawValue) as! OtherUserProfileVC
            vc.userId = productDetail.ratingAndReview[sender.tag].userRef
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @objc func clickToBookmark(_ sender: UIButton) {
        if productDetail.id != "" {
            if AppModel.shared.isGuestUser {
//                self.navigationController?.setNavigationBarHidden(true, animated: false)
//                AppModel.shared.showNabBarView = .No
                showGuestView()
            }
            else {
                isFromProductDetail = true
                AppDelegate().sharedDelegate().vibrateOnTouch()
                BookMarkAddVM.addBookmark(request: BookmarkAddRequest(ref: productDetail.id, refType: BOOKMARK_TYPES.PRODUCT.rawValue, status: !productDetail.isBookmark))
            }
        }
    }
    
    // MARK: - websiteBtnIsPressed
    @objc func websiteBtnIsPressed(sender: UIButton) {
        if AppModel.shared.isGuestUser == false {
            let statisticRequest = StatisticsRequest(productRef: self.productId)
            self.statisticVM.getWebsiteStatistics(statisticRequest: statisticRequest)
        }
        else{
            let webUrl = self.productDetail.link
            if webUrl.hasPrefix("https://") || webUrl.hasPrefix("http://"){
                guard let url = URL(string: webUrl) else {
                    log.error("URL incorrect")/
                    return //be safe
                }
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
                
            }else {
                let correctedURL = "http://\(webUrl)"
                guard let url = URL(string: correctedURL) else {
                    log.error("URL incorrect")/
                    return //be safe
                }
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    // MARK: - reviewBtnIsPressed
    @objc func reviewBtnIsPressed(sender: UIButton) {
        if AppModel.shared.isGuestUser {
//            self.navigationController?.setNavigationBarHidden(true, animated: false)
//            AppModel.shared.showNabBarView = .No
            showGuestView()
        }
        else {
//            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.guestUserView.isHidden = true
            AppModel.shared.showNabBarView = .Yes
            self.tableView.isHidden = false
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
            vc.productId = self.productId
            vc.reviewType = .product
            
//            self.navigationController?.present(vc, animated: true)
            self.present(vc, animated: true, completion: nil)
            
//            let transition = CATransition()
//            transition.duration = 0.5
//            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//            transition.type = CATransitionType.moveIn
//            transition.subtype = CATransitionSubtype.fromTop
//            self.navigationController?.view.layer.add(transition, forKey: nil)
//            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    // MARK: - saveBtnIsPressed
    @objc func saveBtnIsPressed(sender: UIButton) {
        if AppModel.shared.isGuestUser {
//         self.navigationController?.setNavigationBarHidden(true, animated: false)
//            AppModel.shared.showNabBarView = .No
            showGuestView()
        }
        else {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.guestUserView.isHidden = true
            AppModel.shared.showNabBarView = .Yes
            self.tableView.isHidden = false
            var request: FollowProductRequest
            if self.productDetail.isFollowed {
                request = FollowProductRequest(productRef: self.productId, status: false)
            }
            else {
                request = FollowProductRequest(productRef: self.productId, status: true)
            }
            self.saveProductVM.SaveProduct(request: request)
        }
    }
    
    func showGuestView() {
        if self.guestUserView == nil {
            self.guestUserView = GuestUserView.init()
        }
        displaySubViewtoParentView(self.view, subview: guestUserView)
        guestUserView.isHidden = false
        guestUserView.crossBtn.isHidden = true
    }
}

//MARK: - ProductDetailDelegate
extension ProductDetailVC: ProductDetailDelegate {
    func didRecieveProductDetailResponse(response: ProductDetailResponse) {
        productDetail = response.data!
        titleLbl.text = productDetail.brandName
        getImages()
        shimmerView.hideSkeleton()
        shimmerView.isHidden = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - StatisticsDelegate
extension ProductDetailVC: StatisticsDelegate {
    func didReceivedProductStatistics(response: SuccessModel) {
        log.success(response.message)/
    }
    
    func didReceivedWebsiteStatistics(response: SuccessModel) {
        log.success(response.message)/
        let webUrl = self.productDetail.link
        if webUrl.hasPrefix("https://") || webUrl.hasPrefix("http://"){
            guard let url = URL(string: webUrl) else {
                log.error("URL incorrect")/
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }else {
            let correctedURL = "http://\(webUrl)"
            guard let url = URL(string: correctedURL) else {
                log.error("URL incorrect")/
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

//MARK: - FollowProductDelegate
extension ProductDetailVC: FollowProductDelegate{
    func didRecieveFollowProductResponse(response: SuccessModel) {
        log.success(response.message)/
        if productDetail.isFollowed {
            productDetail.isFollowed = false
        }
        else {
            productDetail.isFollowed = true
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Collection View Data Source and delegate methods
extension ProductDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if productDetail.similarProducts.count >= 8 {
            return 8
        }
        else {
            return productDetail.similarProducts.count
        }
    }
    
    // sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { 
        let cellW = (collectionView.frame.width * 0.75) - 32
        let cellH = cellW + 116 //(collectionView.frame.height / 2)
        return CGSize(width: cellW, height: cellH)
    }
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else { return UICollectionViewCell() }
        if productDetail.similarProducts.count > 0{
            cell.productImage.downloadCachedImageWithLoader(placeholder: "rectangle", urlString: AppImageUrl.average + (productDetail.similarProducts[indexPath.row].images.first ?? ""))
            if !productDetail.similarProducts[indexPath.row].currency.isEmpty {
                cell.priceLbl.text = productDetail.similarProducts[indexPath.row].currency + productDetail.similarProducts[indexPath.row].price
            } else {
                cell.priceLbl.text = STATIC_LABELS.currencySymbol.rawValue + productDetail.similarProducts[indexPath.row].price
            }
            cell.productNameLbl.text = productDetail.similarProducts[indexPath.row].brandName
            cell.brandNameLbl.text = productDetail.similarProducts[indexPath.row].name
            
            cell.bookmarkBtn.isSelected = productDetail.similarProducts[indexPath.row].isBookmark
            cell.bookmarkBtn.tag = indexPath.row
            cell.bookmarkBtn.addTarget(self, action: #selector(self.clickToProductBookmark), for: .touchUpInside)
        }
        return cell
    }
    
    // didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        vc.productId = productDetail.similarProducts[indexPath.row].id
        vc.isTransition = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickToProductBookmark(_ sender: UIButton) {
        if productDetail.id != "" {
            if AppModel.shared.isGuestUser {
//                self.navigationController?.setNavigationBarHidden(true, animated: false)
//                AppModel.shared.showNabBarView = .No
                showGuestView()
            }
            else {
                isFromProductDetail = false
                AppDelegate().sharedDelegate().vibrateOnTouch()
                BookMarkAddVM.addBookmark(request: BookmarkAddRequest(ref: productDetail.similarProducts[sender.tag].id, refType: BOOKMARK_TYPES.PRODUCT.rawValue, status: !productDetail.similarProducts[sender.tag].isBookmark))
            }
        }
    }
}
