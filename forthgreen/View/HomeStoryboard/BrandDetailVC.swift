//
//  BrandDetailVC.swift
//  forthgreen
//
//  Created by MACBOOK on 05/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import SkeletonView
import Branch

protocol UpdateBrandBookmarkList {
    func updateBrandListWithBokmark(brandRef: String, status: Bool)
}


class BrandDetailVC: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    private var followBrandVM: FollowBrandViewModel = FollowBrandViewModel()
    private var brandDetailVM: BrandDetailViewModel = BrandDetailViewModel()
    private var BookMarkAddVM: BookMarkAddViewModel = BookMarkAddViewModel()
    var brandId: String = String()
    var brandDetail: BrandDetail?
    private var lineCount: Int = Int()
    private var isAboutTextExpended: Bool = false
    var isTransition: Bool = Bool()
    var isFromBack: Bool = false
    
    var delegate: UpdateBrandBookmarkList?
    
    @IBOutlet var guestUserView: GuestUserView!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var moveToTopBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfigUI()
        // Do any additional setup after loading the view.
    }
    
    //viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        if AppModel.shared.showNabBarView == .Yes{
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        else{
            self.navigationController?.navigationBar.isHidden = true
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: AppColors.charcol,
             NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBold.rawValue, size: 18)!]
        */
        log.success("BrandDetails observer added successfully!")/
        NotificationCenter.default.addObserver(self, selector: #selector(RefreshBrandDetails(noti:)), name: NOTIFICATIONS.Refresh, object: nil)
        
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
      
     //MARK:- if Brand sharing option is available only for logged in Users uncomment below code
//        if AppModel.shared.isGuestUser {
//            self.navigationItem.rightBarButtonItem?.image = UIImage()
//            self.navigationItem.rightBarButtonItem?.isEnabled = false
//        }
//        else {
//            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
//            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "iconShareArtciel")
//            self.navigationItem.rightBarButtonItem?.isEnabled = true
//        }
        
        //MARK:- if Brand sharing option is available for logged in Users as well as for guest Users
        /*
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
        self.navigationItem.rightBarButtonItem?.image = UIImage(named: "iconShareArtciel")
        self.navigationItem.rightBarButtonItem?.isEnabled = true
         */
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self)
        
//        navigationController?.view.backgroundColor = .white
        
        log.success("BrandDetails observer removed successfully!")/
//        if isTransition && isFromBack {
//            self.navigationController?.setNavigationBarHidden(true, animated: animated)
//        }
//        else {
       //     self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        }
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
//        guestUserView.crossBtn.addTarget(self, action: #selector(close(sender:)), for: .touchUpInside)
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        tableView.register(UINib(nibName: "BrandDetailCell", bundle: nil), forCellReuseIdentifier: "BrandDetailCell")
        tableView.register(UINib(nibName: "BrandDetailCell2", bundle: nil), forCellReuseIdentifier: "BrandDetailCell2")
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        brandDetailVM.delegate = self
        let request = BrandDetailRequest(brandRef: brandId)
        brandDetailVM.brandDetail(detailRequest: request)
        
        
        BookMarkAddVM.bookmarkInfo.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.BookMarkAddVM.success.value {
                if self.brandDetail != nil {
                    self.brandDetail!.isBookmark = self.BookMarkAddVM.bookmarkInfo.value.status
                    self.tableView.reloadData()
                    self.delegate?.updateBrandListWithBokmark(brandRef: self.brandDetail!.id, status: self.BookMarkAddVM.bookmarkInfo.value.status)
                }
            }
        }
    }
    
    @objc func close(sender: UIButton){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.guestUserView.isHidden = true
        AppModel.shared.showNabBarView = .Yes
        self.tableView.isHidden = false
    }
    
    //MARK: - RefreshBrandDetails
    @objc func RefreshBrandDetails(noti : Notification)
    {
        let request = FollowBrandRequest(brandRef: self.brandId, status: true)
        self.followBrandVM.FollowBrand(followRequest: request)
    }
    
    //MARK: - Button Click
    @IBAction func clicKToBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - clickMoveToTopBtn
    @IBAction func clickMoveToTopBtn(_ sender: UIButton) {
        self.scrollToTop()
    }
    
    //MARK: - threeDotsBtnIsPRessed
    @IBAction func clickToShare(_ sender: UIButton)
    {
        let title = "Forthgreen"
        let desc = "\(brandDetail?.about ?? "")"
        let imgURL = "\(AppImageUrl.small + (self.brandDetail?.logo ?? ""))"
        
        let buo = BranchUniversalObject()
        buo.canonicalIdentifier = "content/12345"
        buo.title = title
        buo.contentDescription = desc
        buo.imageUrl = imgURL
        buo.publiclyIndex = true
        buo.locallyIndex = true
        buo.contentMetadata.contentSchema = BranchContentSchema.commerceProduct
        buo.contentMetadata.customMetadata[BRANCH_IO.INTENT_DEEP_LINK_PAYLOAD] = brandDetail.toJSON()
        
        let lp = BranchLinkProperties.init()
        lp.addControlParam(BRANCH_IO.INTENT_DEEP_LINK_TIME_STAMP, withValue: getCurrentTimeStampValue())
        lp.addControlParam(BRANCH_IO.INTENT_DEEP_LINK_PAYLOAD_MAPPING, withValue: PayloadMappingType.brand.rawValue)
        
        buo.getShortUrl(with: lp) { (url, error) in
            if error == nil {
                let strShare = "Check out what brand I just found in Forthgreen! \(self.brandDetail?.brandName ?? "") " + url!
                let activityViewController = UIActivityViewController(activityItems: [strShare] , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
        
    }
    
    //MARK: - backBtnIsPRessed
    @IBAction func backBtnIsPRessed(_ sender: UIBarButtonItem) {
        isFromBack = true
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension BrandDetailVC: UITableViewDelegate,UITableViewDataSource {
    
    // numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BrandDetailCell", for: indexPath) as? BrandDetailCell else {
                return UITableViewCell()
            }
            if let brandInfo = brandDetail {
                cell.coverImage.downloadCachedImageWithLoader(placeholder: "rectangle", urlString: AppImageUrl.best + (brandInfo.coverImage))
                cell.brandImage.downloadCachedImageWithLoader(placeholder: "placeholder", urlString: AppImageUrl.best + (brandInfo.logo))
                cell.brandNameLbl.text = brandInfo.brandName
                cell.followerCountLbl.text = "\(brandInfo.followers) followers"
                cell.aboutLbl.increaseLineSpacing(text: brandInfo.about)
                lineCount = cell.aboutLbl.calculateMaxLines()
                print(lineCount)
                if lineCount > 3 && isAboutTextExpended == false{
                    cell.aboutLbl.numberOfLines = 3
                    cell.viewMoreBtnView.isHidden = false
                }
                else {
                    cell.aboutLbl.numberOfLines = lineCount
                    cell.viewMoreBtnView.isHidden = true
                    cell.heightConstraintOfViewMoreBtnView.constant = 0
                }
                cell.viewMoreBtn.addTarget(self, action: #selector(viewBtnIsPressed), for: .touchUpInside)
                
                cell.bookmarkBtn.isSelected = brandInfo.isBookmark
                cell.bookmarkBtn.tag = indexPath.row
                cell.bookmarkBtn.addTarget(self, action: #selector(self.clickToBookmark), for: .touchUpInside)
            }
            
            self.followBrandVM.delegate = self
            cell.saveBtn.addTarget(self, action: #selector(saveBtnIsPressed), for: .touchUpInside)
            cell.websiteBtn.addTarget(self, action: #selector(websiteBtnIsPressed), for: .touchUpInside)
            
            if brandDetail?.isFollowing ?? false {
                cell.saveBtn.setTitle(SAVE_BTN_TYPE.unsave.getUperCased(), for: .normal)
            }
            else {
                cell.saveBtn.setTitle(SAVE_BTN_TYPE.save.getUperCased(), for: .normal)
            }
            
            cell.usernameLbl.text = ""
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BrandDetailCell2", for: indexPath) as? BrandDetailCell2 else {
                return UITableViewCell()
            }
            cell.collectionView.reloadData()
            cell.topDelegate = self
            cell.brandName = brandDetail?.brandName ?? ""
            cell.productData = brandDetail?.products ?? [Product]()
            
            cell.frame = tableView.bounds
            cell.layoutIfNeeded()
            cell.collectionViewHeightConstraint.constant = cell.collectionView.contentSize.height
            return cell
        }
    }
    
    @objc func clickToBookmark(_ sender: UIButton) {
        if brandDetail != nil {
            if AppModel.shared.isGuestUser {
                self.showLoginAlert()
            }
            else {
                AppDelegate().sharedDelegate().vibrateOnTouch()
                BookMarkAddVM.addBookmark(request: BookmarkAddRequest(ref: brandDetail!.id, refType: BOOKMARK_TYPES.BRAND.rawValue, status: !brandDetail!.isBookmark))
            }
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
    
    //MARK: - viewBtnIsPressed
    @objc func viewBtnIsPressed(sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? BrandDetailCell
        cell?.viewMoreBtn.isHidden = true
        cell?.heightConstraintOfViewMoreBtnView.constant = 0
        isAboutTextExpended = true
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            cell?.aboutLbl.numberOfLines = self.lineCount
            self.tableView.endUpdates()
        }
    }
    
    //MARK: - saveBtnIsPressed
    @objc func saveBtnIsPressed(sender: UIButton) {
        if AppModel.shared.isGuestUser {
//            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.showLoginAlert()
        }
        else {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.guestUserView.isHidden = true
            AppModel.shared.showNabBarView = .Yes
            self.tableView.isHidden = false
            if self.brandDetail?.isFollowing ?? false {
                
                let request = FollowBrandRequest(brandRef: self.brandId, status: false)
                self.followBrandVM.FollowBrand(followRequest: request)
            }
            else {
                let request = FollowBrandRequest(brandRef: self.brandId, status: true)
                self.followBrandVM.FollowBrand(followRequest: request)
            }
        }
    }
    
    //MARK: - websiteBtnIsPressed
    @objc func websiteBtnIsPressed(sender: UIButton) {
        let webUrl = self.brandDetail?.website ?? ""
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

extension BrandDetailVC: AlertDelegate {
    func didClickOkBtn() {
        (UIApplication.shared.delegate as? AppDelegate)?.logoutUser()
    }
    
    func didClickCancelBtn() {
        
    }
}

//MARK: - BrandDetailDelegate
extension BrandDetailVC: BrandDetailDelegate {
    func didRecieveBrandDetailResponse(detailResponse: BrandDetailResponse) {
        brandDetail = detailResponse.data
        shimmerView.hideSkeleton()
        shimmerView.isHidden = true
        titleLbl.text = brandDetail?.brandName
//        self.navigationItem.title = brandDetail?.brandName
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

//MARK: - FollowBrandDelegate
extension BrandDetailVC: FollowBrandDelegate {
    func didRecieveFollowBrandResponse(response: SuccessModel) {
        if brandDetail?.isFollowing ?? false{
            brandDetail?.isFollowing = false
        }
        else {
            brandDetail?.isFollowing = true
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK:- MoveToTopDelegate
extension BrandDetailVC:MoveToTopDelegate{
    func changeStatus(isHidden: Bool) {
        moveToTopBtn.isHidden = true
    }
}
