//
//  RestaurantDetailVC.swift
//  forthgreen
//
//  Created by MACBOOK on 01/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import MapKit
import Branch


protocol UpdateRestaurantBookmarkList {
    func updateRestaurantListWithBokmark(restaurantRef: String, status: Bool)
}


class RestaurantDetailVC: UIViewController {
    
    
    private var restaurantDetailVM: RestaurantDetailViewModel = RestaurantDetailViewModel()
    private var restaurantReviewListingVM: RestaurantReviewListingViewModel = RestaurantReviewListingViewModel()
    private var followRestaurantVM: FollowRestaurantViewModel = FollowRestaurantViewModel()
    private var restaurantDetail: RestaurantDetail = RestaurantDetail()
    private var reviewListArray: [RestaurantReviewListing] = [RestaurantReviewListing]()
    private var BookMarkAddVM: BookMarkAddViewModel = BookMarkAddViewModel()
    var restaurantId: String = String()
    private var localSource: [ImageSource] = [ImageSource]()
    var distance: Double = Double()
    var currentLocation: CLLocationCoordinate2D?
    private var lineCount: Int = Int()
    private var userId: String = String()
    
    var delegate : UpdateRestaurantBookmarkList?
    var isTransition: Bool = Bool()
    var isFromBack: Bool = false
    
    // OUTLETS
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet var guestUserView: GuestUserView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if AppModel.shared.showNabBarView == .Yes{
//            self.navigationController?.navigationBar.isHidden = false
//             self.navigationController?.setNavigationBarHidden(false, animated: false)
//        }
//        else{
//            self.navigationController?.navigationBar.isHidden = true
             self.navigationController?.setNavigationBarHidden(true, animated: false)
//        }
        
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
        
        //MARK:- if Restaurant sharing option is available only for logged in Users uncomment below code
        //        if AppModel.shared.isGuestUser {
        //            self.navigationItem.rightBarButtonItem?.image = UIImage()
        //            self.navigationItem.rightBarButtonItem?.isEnabled = false
        //        }
        //        else {
        //            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
        //            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "iconShareArtciel")
        //            self.navigationItem.rightBarButtonItem?.isEnabled = true
        //        }
        
        //MARK:- if Restaurant sharing option is available for logged in Users as well as for guest Users
//        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
//        self.navigationItem.rightBarButtonItem?.image = UIImage(named: "iconShareArtciel")
//        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        navigationController?.view.backgroundColor = .white
        
//        if isTransition && isFromBack {
//             self.navigationController?.setNavigationBarHidden(true, animated: animated)
//         }
//         else {
        //     self.navigationController?.setNavigationBarHidden(false, animated: animated)
//         }
    }
    
    //MARK: - configUI
    private func configUI() {
//        guestUserView.crossBtn.addTarget(self, action: #selector(close(sender:)), for: .touchUpInside)
        guestUserView.isHidden = true
        tableView.register(UINib(nibName: "RestaurantDetailCell", bundle: nil), forCellReuseIdentifier: "RestaurantDetailCell")
        tableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        if let user = AppModel.shared.currentUser {
            userId = user.id
        }
        
        followRestaurantVM.delegate = self
        restaurantDetailVM.delegate = self
        restaurantReviewListingVM.delegate = self
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        let request = RestaurantDetailRequest(restaurantId: restaurantId)
        restaurantDetailVM.fetchRestaurantDetail(request: request)
        
        let reviewRequest = RestaurantReviewListingRequest(restaurantRef: restaurantId)
        restaurantReviewListingVM.fetchReviewListing(request: reviewRequest)
        
        log.success("RestaurantDetails observer added successfully!")/
        NotificationCenter.default.addObserver(self, selector: #selector(refreshRestaurantReviews(noti:)), name: NOTIFICATIONS.RefreshRestaurantReviews, object: nil)
        
        BookMarkAddVM.bookmarkInfo.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.BookMarkAddVM.success.value {
                self.restaurantDetail.isBookmark = self.BookMarkAddVM.bookmarkInfo.value.status
                self.tableView.reloadData()
                self.delegate?.updateRestaurantListWithBokmark(restaurantRef: self.restaurantDetail.id, status: self.BookMarkAddVM.bookmarkInfo.value.status)
            }
        }
    }
    
    //MARK: - close
    @objc func close(sender: UIButton){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.guestUserView.isHidden = true
        AppModel.shared.showNabBarView = .Yes
        self.tableView.isHidden = false
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        isFromBack = true
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - refreshRestaurantReviews
    @objc func refreshRestaurantReviews(noti : Notification) {
        let reviewRequest = RestaurantReviewListingRequest(restaurantRef: restaurantId)
        restaurantReviewListingVM.fetchReviewListing(request: reviewRequest)
    }
    
    //MARK:- Get Slide images
    func getImages(){
        let group = DispatchGroup()
        if restaurantDetail.images.count > 0{
            self.localSource.removeAll()
            for pic in restaurantDetail.images {
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
    
    //MARK: - threeDotsBtnIsPressed
    @IBAction func threeDotsBtnIsPressed(_ sender: UIButton) {
        self.shareRestaurant()
    }
    
    //MARK: - shareRestaurant
    func shareRestaurant() {
        let title = "Forthgreen"
        let desc = "\(restaurantDetail.about)"
        let imgURL = "\(AppImageUrl.small + (self.restaurantDetail.thumbnail))"
        
        let buo = BranchUniversalObject()
        buo.canonicalIdentifier = "content/12345"
        buo.title = title
        buo.contentDescription = desc
        buo.imageUrl = imgURL
        buo.publiclyIndex = true
        buo.locallyIndex = true
        buo.contentMetadata.contentSchema = BranchContentSchema.commerceProduct
        buo.contentMetadata.customMetadata[BRANCH_IO.INTENT_DEEP_LINK_PAYLOAD] = restaurantDetail.toJSON()
        
        let lp = BranchLinkProperties.init()
        lp.addControlParam(BRANCH_IO.INTENT_DEEP_LINK_TIME_STAMP, withValue: getCurrentTimeStampValue())
        lp.addControlParam(BRANCH_IO.INTENT_DEEP_LINK_PAYLOAD_MAPPING, withValue: PayloadMappingType.restaurant.rawValue)
        
        buo.getShortUrl(with: lp) { (url, error) in
            if error == nil {
                let strShare = "Check out what restaurant I just found in Forthgreen! \(self.restaurantDetail.name) link to the app " + url!
                let activityViewController = UIActivityViewController(activityItems: [strShare] , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
        
    }
}

//MARK: - Table View DataSource and Delegate Methods
extension RestaurantDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    // numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return reviewListArray.count
        }
    }
    
    // estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantDetailCell", for: indexPath) as? RestaurantDetailCell else {
                return UITableViewCell()
            }
            cell.restaurantImageView.downloadCachedImageWithLoader(placeholder: "rectangle", urlString: AppImageUrl.average + (restaurantDetail.thumbnail))
            cell.restaurantNameLbl.text = restaurantDetail.name
            cell.starRatingView.rating = restaurantDetail.ratings?.averageRating ?? DocumentDefaultValues.Empty.double
            cell.ratingCountLbl.text = "\(restaurantDetail.ratings?.count ?? DocumentDefaultValues.Empty.int)"
            cell.dishTypeLbl.text = restaurantDetail.typeOfFood
            let count = restaurantDetail.price.count
            let myString: NSString = "$$$"
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "BuenosAires-Bold", size: 14.0)!])
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.turqoiseGreen, range: NSRange(location:0,length:count))
            // set label Attribute
            cell.priceLbl.attributedText = myMutableString
            cell.distanceLbl.text = String(format: "%0.1f", distance * 0.00062137) + " miles"
            
            cell.dishImageView.contentScaleMode = .scaleAspectFill
            cell.dishImageView.setImageInputs(localSource)
            cell.dishImageView.circular = false
            cell.loaderView.sainiShowLoader(loaderColor: .gray)
            if localSource.count > 0  {
                cell.dishImageView.backgroundColor = .white
                cell.loaderView.isHidden = true
            }
            else if localSource.count == 0 {
                cell.dishImageView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.9568627451, alpha: 1)
                 cell.loaderView.isHidden = false
            }
            else{
                 cell.dishImageView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.9568627451, alpha: 1)
                 cell.loaderView.isHidden = false
            }
            cell.descriptionLbl.increaseLineSpacing(text: restaurantDetail.about)
            cell.heightConstraintOfViewMoreBtnView.constant = 0
            //=============== viewMore Btn functionality=======================
//            lineCount = cell.descriptionLbl.calculateMaxLines()
//            print(lineCount)
//            if lineCount > 3 {
//                cell.descriptionLbl.numberOfLines = 3
//                cell.viewMoreBtnView.isHidden = false
//            }
//            else {
//                cell.descriptionLbl.numberOfLines = lineCount
//                cell.viewMoreBtnView.isHidden = true
//                cell.heightConstraintOfViewMoreBtnView.constant = 0
//            }
//            cell.viewMoreBtn.addTarget(self, action: #selector(viewBtnIsPressed), for: .touchUpInside)
            //======================================================
            
            cell.addressLine1.text = restaurantDetail.location?.address
            cell.addressLine2.text = restaurantDetail.portCode
            
            if restaurantDetail.phoneNumber.isEmpty || !restaurantDetail.showPhoneNumber {
                cell.contactView.isHidden = true
            } else {
                cell.contactView.isHidden = false
                cell.phoneNumberLbl.text = "\(restaurantDetail.phoneCode) \(restaurantDetail.phoneNumber)"
            }
            
            if restaurantDetail.isFollowed {
                cell.followBtn.setTitle(SAVE_BTN_TYPE.unsave.getUperCased(), for: .normal)
            } else {
                cell.followBtn.setTitle(SAVE_BTN_TYPE.save.getUperCased(), for: .normal)
            }
            

            let location = CLLocationCoordinate2D(latitude: restaurantDetail.location?.coordinates[0] ?? 0 , longitude:restaurantDetail.location?.coordinates[1] ?? 0)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            cell.mapView.setRegion(region, animated: true)
            let Annotation = RestaurantAnnotation()
            Annotation.title = restaurantDetail.name
            Annotation.subtitle = ""
            Annotation.coordinate = location
            cell.mapView.addAnnotation(Annotation)
            cell.mapView.isHidden = false
            
            cell.mapView.sainiAddTapGesture {
                guard let lat = self.restaurantDetail.location?.coordinates[0] else { return }
                guard let long = self.restaurantDetail.location?.coordinates[1] else { return }
                guard let url = URL(string:"http://maps.apple.com/?daddr=\(lat),\(long)") else { return }
                UIApplication.shared.open(url)
                //                }
                //                let vc = STORYBOARD.RESTAURANT.instantiateViewController(withIdentifier: "MapVC") as! MapVC
                //                vc.currentLocation = self.currentLocation
                //                vc.selectedLocation = self.restaurantDetail
                //                self.navigationController?.pushViewController(vc, animated: true)
            }
            let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
            longTapGesture.minimumPressDuration = 1
            cell.copyLocationBtn.addGestureRecognizer(longTapGesture)
            cell.websiteBtn.addTarget(self, action: #selector(websiteBtnIsPressed), for: .touchUpInside)
            cell.followBtn.addTarget(self, action: #selector(followBtnIsPressed), for: .touchUpInside)
            cell.reviewBtn.addTarget(self, action: #selector(addReviewBtnIsPressed), for: .touchUpInside)
            cell.contactView.sainiAddTapGesture {
                let number = self.restaurantDetail.phoneCode + self.restaurantDetail.phoneNumber
                if let url = URL(string: "telprompt://\(number)") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            
            cell.bookmarkBtn.isSelected = restaurantDetail.isBookmark
            cell.bookmarkBtn.tag = indexPath.row
            cell.bookmarkBtn.addTarget(self, action: #selector(self.clickToBookmark), for: .touchUpInside)
            
            cell.writeReviewBtn.tag = indexPath.row
            cell.writeReviewBtn.addTarget(self, action: #selector(self.addReviewBtnIsPressed), for: .touchUpInside)
            
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell else {
                return UITableViewCell()
            }
            cell.renderProfileImage(circle: true)
            cell.threeDotsBtn.isHidden = false
            cell.threeDotsBtn.tag = indexPath.row
            cell.threeDotsBtn.addTarget(self, action: #selector(threeDotsBtnOfReviewIsPressed(sender: )), for: .touchUpInside)
            cell.profileProductImage.downloadCachedImageWithLoader(placeholder: "ic_placeholder", urlString: AppImageUrl.average + (reviewListArray[indexPath.row].userDetails?.image ?? DocumentDefaultValues.Empty.string))
            cell.reviewTitleLbl.text = reviewListArray[indexPath.row].title
            cell.reviewTextLbl.increaseLineSpacing(text: reviewListArray[indexPath.row].review)
            cell.nameLbl.text = "\(reviewListArray[indexPath.row].userDetails?.firstName ?? "") " //\(reviewListArray[indexPath.row].userDetails?.lastName ?? "")"
            cell.renderRatingStar(count: Int(reviewListArray[indexPath.row].rating) )
            cell.renderProfileImage(circle:true)
            if AppModel.shared.isGuestUser {
                cell.threeDotsBtn.isHidden = true
            }
            else{
                if reviewListArray[indexPath.row].userDetails?.id == AppModel.shared.currentUser?.id {
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
    
    //MARK: - clickToGoToProfile
    @objc func clickToGoToProfile(_ sender: UIButton) {
        if userId != reviewListArray[sender.tag].userRef {
            let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.OtherUserProfileVC.rawValue) as! OtherUserProfileVC
            vc.userId = reviewListArray[sender.tag].userDetails?.id ?? DocumentDefaultValues.Empty.string
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @objc func clickToBookmark(_ sender: UIButton) {
        if restaurantDetail.id != "" {
            if AppModel.shared.isGuestUser {
//                self.navigationController?.setNavigationBarHidden(true, animated: false)
//                AppModel.shared.showNabBarView = .Yes
                showGuestView()
                self.tableView.isHidden = false
            }
            else {
                AppDelegate().sharedDelegate().vibrateOnTouch()
                BookMarkAddVM.addBookmark(request: BookmarkAddRequest(ref: restaurantDetail.id, refType: BOOKMARK_TYPES.RESTAURANT.rawValue, status: !restaurantDetail.isBookmark))
            }
        }
    }
    
    //MARK: - viewBtnIsPressed
    @objc func viewBtnIsPressed(sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RestaurantDetailCell
        cell?.viewMoreBtn.isHidden = true
        cell?.heightConstraintOfViewMoreBtnView.constant = 0
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            cell?.descriptionLbl.numberOfLines = self.lineCount
            self.tableView.endUpdates()
        }
    }
    
    //MARK: - websiteBtnIsPressed
    @objc func websiteBtnIsPressed(sender: UIButton) {
        var webUrl = restaurantDetail.website
        if webUrl == DocumentDefaultValues.Empty.string {
            self.view.sainiShowToast(message: "Website is not available")
        }
        else if webUrl.contains("https://") {
            webUrl = restaurantDetail.website
        }
        else if webUrl.contains("http://") {
            webUrl = restaurantDetail.website
        }
        else {
            webUrl = "https://" + restaurantDetail.website
        }
        guard let url = URL(string: webUrl) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    //MARK: - followBtnIsPressed
    @objc func followBtnIsPressed(sender: UIButton) {
        if AppModel.shared.isGuestUser {
//            self.navigationController?.setNavigationBarHidden(true, animated: false)
//            AppModel.shared.showNabBarView = .Yes
            showGuestView()
            self.tableView.isHidden = false
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.guestUserView.isHidden = true
            AppModel.shared.showNabBarView = .Yes
            self.tableView.isHidden = false
            if restaurantDetail.isFollowed {
                let request = FollowRestaurantRequest(status: false, restaurantRef: restaurantId)
                followRestaurantVM.updateFollowStatus(request: request)
            } else {
                let request = FollowRestaurantRequest(status: true, restaurantRef: restaurantId)
                followRestaurantVM.updateFollowStatus(request: request)
            }
        }
    }
    
    //MARK: - LongTapGesture
    @objc func longTap(sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            log.info(STATIC_LABELS.copyToast.rawValue)/
            UIPasteboard.general.string = restaurantDetail.location?.address
            AppDelegate().sharedDelegate().showErrorToast(message: STATIC_LABELS.copyToast.rawValue, true)
        }
    }
    
    //MARK: - addReviewBtnIsPressed
    @objc func addReviewBtnIsPressed(sender: UIButton) {
        if AppModel.shared.isGuestUser {
//            self.navigationController?.setNavigationBarHidden(true, animated: false)
//            AppModel.shared.showNabBarView = .Yes
            showGuestView()
            self.tableView.isHidden = false
        } else {
//            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.guestUserView.isHidden = true
            AppModel.shared.showNabBarView = .Yes
            self.tableView.isHidden = false
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
            vc.productId = self.restaurantId
            vc.reviewType = .restaurant
//            self.navigationController?.pushViewController(vc, animated: true)
            
             self.present(vc, animated: true)
            
//            let transition = CATransition()
//            transition.duration = 0.5
//            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//            transition.type = CATransitionType.moveIn
//            transition.subtype = CATransitionSubtype.fromTop
//            self.navigationController?.view.layer.add(transition, forKey: nil)
//            self.navigationController?.pushViewController(vc, animated: false)
            
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
            vc.reviewId = self.reviewListArray[sender.tag].id
            vc.reportType = .restaurant
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
        
        actionSheet.addAction(reportBtn)
        
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        actionSheet.popoverPresentationController?.permittedArrowDirections = []
        actionSheet.view.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showGuestView() {
        if self.guestUserView == nil {
            self.guestUserView = GuestUserView.init()
        }
        displaySubViewtoParentView(self.view, subview: guestUserView)
        guestUserView.isHidden = false
    }
    
}

//MARK: - RestaurantDetailDelegate
extension RestaurantDetailVC: RestaurantDetailDelegate {
    func didRecieveDetailResponse(response: RestaurantDetailResponse) {
        log.success(response.message)/
        shimmerView.hideSkeleton()
        shimmerView.isHidden = true
        restaurantDetail = response.data ?? RestaurantDetail()
        titleLbl.text = restaurantDetail.name
        getImages()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - RestaurantReviewListDelegate
extension RestaurantDetailVC: RestaurantReviewListDelegate {
    func didRecieveRestaurantReviewListingResponse(response: RestaurantReviewListingResponse) {
        log.success(response.message)/
        reviewListArray = response.data
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - FollowRestaurantDelegate
extension RestaurantDetailVC: FollowRestaurantDelegate {
    func didRecieveFollowUpdateResponse(response: SuccessModel) {
        log.success(response.message)/
        if restaurantDetail.isFollowed {
            restaurantDetail.isFollowed = false
        } else {
            restaurantDetail.isFollowed = true
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
