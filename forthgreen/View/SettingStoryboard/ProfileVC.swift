//
//  ProfileVC.swift
//  forthgreen
//
//  Created by MACBOOK on 08/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import SideMenu
import Branch

class ProfileVC: UIViewController {

    private var profileInfoVM: ProfileInfoViewModel = ProfileInfoViewModel()
    private var likePostVM: LikePostViewModel = LikePostViewModel()
    private var deletePostVM: DeletePostViewModel = DeletePostViewModel()
    private var deletedPostId: String = String()
    private let refreshControl = UIRefreshControl()
    var userId: String = String()
    
    // OUTLETS
    @IBOutlet weak var bottomConstraintOfTableView: NSLayoutConstraint!
    @IBOutlet var guestUserView: GuestUserView!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: false)
        }
        
//        if AppModel.shared.isGuestUser {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
//        }
//        else {
//            self.navigationController?.setNavigationBarHidden(false, animated: false)
//        }
        setupGuestUser()
        log.success("Profile observer added successfully!")/
        NotificationCenter.default.addObserver(self, selector: #selector(RefreshProfileSetting(noti:)), name: NOTIFICATIONS.ProfileRefresh, object: nil)
        
        if SCREEN.HEIGHT >= 812 {
            bottomConstraintOfTableView.constant = 76
        } else {
            bottomConstraintOfTableView.constant = 56
        }
        
        if !self.profileInfoVM.userInfo.value.posts.isEmpty {
            delay(1.0) {
                self.tableView.reloadData()
                delay(0.1) {
                    self.pausePlayeVideos()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pausePlayeVideos()
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopPlayerVideos()
        NotificationCenter.default.removeObserver(self)
        log.success("Profile observer removed successfully!")/
    }
    
    //MARK: - RefreshProfileSetting
    @objc func RefreshProfileSetting(noti : Notification) {
        let request = ProfileInfoRequest(userRef: userId)
        profileInfoVM.fetchInfo(request: request)
    }
    
    func setupGuestUser() {
        if AppModel.shared.isGuestUser {
            if self.guestUserView == nil {
                self.guestUserView = GuestUserView.init()
            }
            displaySubViewtoParentView(self.view, subview: guestUserView)
            guestUserView.crossBtn.isHidden = true
            guestUserView.isHidden = false
        }
//        else if profileInfoVM.userInfo.value.posts.count == 0 {
//            shimmerView.isHidden = false
//            shimmerView.isSkeletonable = true
//            shimmerView.showAnimatedGradientSkeleton()
//            guestUserView.isHidden = true
//        }
    }
    
    //MARK: - configUI
    private func configUI() {
        AppDelegate().sharedDelegate().setupSideMenu()
        
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.socialFeedCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.socialFeedCell.rawValue)
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.ProfileInfoCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ProfileInfoCell.rawValue)
        
        if !AppModel.shared.isGuestUser {
            userId = AppModel.shared.currentUser?.id ?? DocumentDefaultValues.Empty.string
            let request = ProfileInfoRequest(userRef: userId)
            profileInfoVM.fetchInfo(request: request)
            
            if AppModel.shared.currentUser != nil {
                titleLbl.text = "\(AppModel.shared.currentUser!.firstName)"
            }
        }
        
        profileInfoVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.profileInfoVM.success.value {
                self.shimmerView.hideSkeleton()
                self.shimmerView.isHidden = true
            }
        }
        
        profileInfoVM.userInfo.bind { [weak self](_) in
            guard let `self` = self else { return }
            self.shimmerView.hideSkeleton()
            self.shimmerView.isHidden = true
            if self.profileInfoVM.userInfo.value.firstName != "" {
                self.navigationItem.title = "\(self.profileInfoVM.userInfo.value.firstName)" //" \(self.profileInfoVM.userInfo.value.lastName)"
            }
            
            self.tableView.reloadData()
            if !self.profileInfoVM.userInfo.value.posts.isEmpty {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    delay(1.0) {
                        self.playFirstVisibleVideo(true)
                    }
                }
            }
            
        }
        
//        profileInfoVM.postList.bind { [weak self](_) in
//            guard let `self` = self else { return }
//            if !self.profileInfoVM.postList.value.isEmpty {
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }
        
        likePostVM.likePostInfo.bind { [weak self](_) in
            guard let `self` = self else { return }
            let postRef = self.likePostVM.likePostInfo.value.ref
            let likeStatus = self.likePostVM.likePostInfo.value.status
            self.profileInfoVM.likePost(postRef: postRef, status: likeStatus)
        }
        
        deletePostVM.success.bind { [weak self] (_) in
            guard let `self` = self else { return }
            if self.deletePostVM.success.value {
                self.profileInfoVM.deletePostLocally(id: self.deletedPostId)
                AppDelegate().sharedDelegate().showErrorToast(message: STATIC_LABELS.deletePostSuccessToast.rawValue, true)
            }
        }
        addRefreshControl()
    }
    
    //MARK: - addRefreshControl
    private func addRefreshControl() {
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
//        shimmerView.isHidden = false
//        shimmerView.isSkeletonable = true
//        shimmerView.showAnimatedGradientSkeleton()
        stopPlayerVideos()
        self.refreshControl.endRefreshing()
//        profileInfoVM.userInfo.value = ProfileInfo()
        guestUserView.isHidden = true
        userId = AppModel.shared.currentUser?.id ?? DocumentDefaultValues.Empty.string
        let request = ProfileInfoRequest(userRef: userId)
        profileInfoVM.fetchInfo(request: request)
    }
    
    //MARK: - sideMenuBtnIsPressed
    @IBAction func sideMenuBtnIsPressed(_ sender: UIButton) {
        guard let sideMenu = SideMenuManager.default.leftMenuNavigationController else { return }
        present(sideMenu, animated: true, completion: nil)
    }
    
    //MARK: - shareProfileBtnIsPressed
    @IBAction func shareProfileBtnIsPressed(_ sender: UIButton) {
        shareProfile()
    }
    
    //MARK: - shareBrand
    func shareProfile() {
        let title = STATIC_LABELS.appTitle.rawValue
        
        let buo = BranchUniversalObject()
        buo.canonicalIdentifier = STATIC_LABELS.canonicalIdentifier.rawValue
        buo.title = title
        buo.publiclyIndex = true
        buo.locallyIndex = true
        buo.contentMetadata.contentSchema = BranchContentSchema.commerceProduct
        buo.contentMetadata.customMetadata[BRANCH_IO.INTENT_DEEP_LINK_PAYLOAD] = profileInfoVM.userInfo.value.toJSON()
        
        let lp = BranchLinkProperties.init()
        lp.addControlParam(BRANCH_IO.INTENT_DEEP_LINK_TIME_STAMP, withValue: getCurrentTimeStampValue())
        lp.addControlParam(BRANCH_IO.INTENT_DEEP_LINK_PAYLOAD_MAPPING, withValue: PayloadMappingType.home.rawValue)
        
        buo.getShortUrl(with: lp) { (url, error) in
            if error == nil {
                let strShare = STATIC_LABELS.shareProfile.rawValue + "\(self.profileInfoVM.userInfo.value.firstName) " + url!
                let activityViewController = UIActivityViewController(activityItems: [strShare] , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
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
            if profileInfoVM.userInfo.value.posts.count == 0 {
                tableView.sainiSetEmptyMessage(STATIC_LABELS.noPosts.rawValue)
            } else {
                tableView.restore()
                tableView.separatorStyle = .none
            }
            return profileInfoVM.userInfo.value.posts.count
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ProfileInfoCell.rawValue, for: indexPath) as? ProfileInfoCell else { return UITableViewCell() }
            cell.nameLbl.text = "\(profileInfoVM.userInfo.value.firstName)" //" \(profileInfoVM.userInfo.value.lastName)"
            cell.profileImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: AppImageUrl.small + profileInfoVM.userInfo.value.image)
            cell.bioLbl.text = profileInfoVM.userInfo.value.bio
            if profileInfoVM.userInfo.value.username == DocumentDefaultValues.Empty.string {
                cell.userNameLbl.isHidden = true
            }
            else {
                cell.userNameLbl.isHidden = false
                cell.userNameLbl.text = STATIC_LABELS.atTheRate.rawValue +  "\(profileInfoVM.userInfo.value.username)"
            }
            cell.followersCount.text = "\(profileInfoVM.userInfo.value.followers)"
            cell.followingCount.text = "\(profileInfoVM.userInfo.value.followings)"

            cell.followerFollowingBtn.tag = indexPath.row
            cell.followerFollowingBtn.addTarget(self, action: #selector(followerFollowingBtnIsPressed), for: .touchUpInside)
            return cell
        }
        else {
            if profileInfoVM.userInfo.value.posts.count == 0 {
                return UITableViewCell()
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.socialFeedCell.rawValue, for: indexPath) as? socialFeedCell else { return UITableViewCell() }
            cell.profileImageView.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: AppImageUrl.average + profileInfoVM.userInfo.value.image)
            cell.nameLbl.text = "\(profileInfoVM.userInfo.value.firstName)" //" \(profileInfoVM.userInfo.value.lastName)"
            cell.timeLbl.text = STATIC_LABELS.atTheRate.rawValue +  "\(profileInfoVM.userInfo.value.createdOn)"
            
            cell.fromSocialFeed = false
            cell.postInfo = profileInfoVM.userInfo.value.posts[indexPath.row]
            cell.soundBtn.isSelected = isMuteVideo
            cell.frame = tableView.bounds
            cell.layoutIfNeeded()
            
            cell.viewMoreBtn.tag = indexPath.row
            cell.viewMoreBtn.addTarget(self, action: #selector(viewMoreBtnIsPressed), for: .touchUpInside)
            cell.likeBtn.tag = indexPath.row
            cell.likeBtn.addTarget(self, action: #selector(likePostBtnIsPressed), for: .touchUpInside)
            cell.threeDotBtn.tag = indexPath.row
            cell.threeDotBtn.addTarget(self, action: #selector(threeDotBtnIsPressed), for: .touchUpInside)
            cell.gotoCommentListBtn.tag = indexPath.row
            cell.gotoCommentListBtn.addTarget(self, action: #selector(addCommentBtnIsPressed), for: .touchUpInside)
            cell.addCommentBtn.tag = indexPath.row
            cell.addCommentBtn.addTarget(self, action: #selector(addCommentBtnIsPressed), for: .touchUpInside)
            cell.threeDotBtn.tag = indexPath.row
            cell.threeDotBtn.addTarget(self, action: #selector(threeDotBtnIsPressed), for: .touchUpInside)
            cell.goToLikeListBtn.tag = indexPath.row
            cell.goToLikeListBtn.addTarget(self, action: #selector(addLikeBtnIsPressed), for: .touchUpInside)
            cell.soundBtn.tag = indexPath.row
            cell.soundBtn.addTarget(self, action: #selector(muteUnmuteSound(sender:)), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    
    @objc func muteUnmuteSound(sender: UIButton) {
        isMuteVideo = !isMuteVideo
        var arrData = [IndexPath]()
        arrData.append(IndexPath(row: sender.tag, section: 1))
        if sender.tag > 0 {
            arrData.append(IndexPath(row: sender.tag-1, section: 1))
        }
        if sender.tag < profileInfoVM.userInfo.value.posts.count-1 {
            arrData.append(IndexPath(row: sender.tag+1, section: 1))
        }
        for temp in arrData {
            if let cell = tableView.cellForRow(at: temp) as? socialFeedCell {
                cell.soundBtn.isSelected = !cell.soundBtn.isSelected
                if temp.row == sender.tag {
                    cell.videoLayer.player?.isMuted = isMuteVideo
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            pausePlayeVideos()
        }
    }
    
    func pausePlayeVideos() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView)
    }
    
    func stopPlayerVideos() {
        DispatchQueue.main.async {
            ASVideoPlayerController.sharedVideoPlayer.stopPlayeVideosFor(tableView: self.tableView)
        }
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView, appEnteredFromBackground: true)
    }
    
    func playFirstVisibleVideo(_ shouldPlay:Bool = true) {
        // 1.
        let cells = tableView.visibleCells.sorted {
            tableView.indexPath(for: $0)?.row ?? 0 < tableView.indexPath(for: $1)?.row ?? 0
        }
        // 2.
        let videoCells = cells.compactMap({ $0 as? socialFeedCell })
        if videoCells.count > 0 {
            // 3.
            let firstVisibileCell = videoCells.first(where: { checkVideoFrameVisibility(ofCell: $0) })
            // 4.
            for videoCell in videoCells {
                if shouldPlay && firstVisibileCell == videoCell {
                    pausePlayeVideos()
                }
            }
        }
    }
    
    func checkVideoFrameVisibility(ofCell cell: socialFeedCell) -> Bool {
        var cellRect = cell.videoView.bounds
        cellRect = cell.videoView.convert(cell.videoView.bounds, to: tableView.superview)
        return tableView.frame.contains(cellRect)
    }
    
    //MARK: - viewMoreBtnOfReplyIsPressed
    @objc func viewMoreBtnIsPressed(sender: UIButton) {
        stopPlayerVideos()
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 1)) as? socialFeedCell
        cell?.viewMoreBtn.isHidden = true
        cell?.heightConstraintOfViewMoreBtnView.constant = 0
        self.profileInfoVM.userInfo.value.posts[sender.tag].isTextExpanded = true
        cell?.postTxtLbl.numberOfLines = self.profileInfoVM.userInfo.value.posts[sender.tag].postTextLineCount
    }
    
    //MARK: - likePostBtnIsPressed
    @objc func likePostBtnIsPressed(_ sender: UIButton) {
        AppDelegate().sharedDelegate().vibrateOnTouch()
        let request = LikePostRequest(postRef: profileInfoVM.userInfo.value.posts[sender.tag].id, like: !profileInfoVM.userInfo.value.posts[sender.tag].isLike)
        likePostVM.likePost(request: request)
    }
    
    //MARK: - addLikeBtnIsPressed
    @objc func addLikeBtnIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.PostLikeVC.rawValue) as! PostLikeVC
        vc.ref = profileInfoVM.userInfo.value.posts[sender.tag].id
        vc.likeType = .POST
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - addCommentBtnIsPressed
    @objc func addCommentBtnIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.CommentListVC.rawValue) as! CommentListVC
        vc.userIsFrom = .selfProfile
        vc.postRef = profileInfoVM.userInfo.value.posts[sender.tag].id
        vc.profileInfoVM = profileInfoVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - followerFollowingBtnIsPressed
    @objc func followerFollowingBtnIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.SETTING.instantiateViewController(withIdentifier: SETTING_STORYBOARD.FollowerListVC.rawValue) as! FollowerListVC
        vc.username = "\(profileInfoVM.userInfo.value.firstName)" //" \(profileInfoVM.userInfo.value.lastName)"
        vc.followCountDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - threeDotBtnIsPressed
    @objc func threeDotBtnIsPressed(_ sender: UIButton) {
        stopPlayerVideos()
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: STATIC_LABELS.cancel.rawValue, style: .cancel) { _ in
            log.result(STATIC_LABELS.cancel.rawValue)/
        }
        actionSheet.addAction(cancelButton)
        
        let removePostBtn = UIAlertAction(title: STATIC_LABELS.removePost.rawValue, style: .default)
        { _ in
            log.result(STATIC_LABELS.removePost.rawValue)/
            self.deletedPostId = self.profileInfoVM.userInfo.value.posts[sender.tag].id
            let request = DeletePostRequest(postRef: self.deletedPostId)
            self.deletePostVM.deletePost(request: request)
        }
        actionSheet.addAction(removePostBtn)
        
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        actionSheet.popoverPresentationController?.permittedArrowDirections = []
        actionSheet.view.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
        self.present(actionSheet, animated: true, completion: nil)
    }
}

//MARK: - FollowCountDelegate
extension ProfileVC: FollowCountDelegate {
    func fetchFollowerCount(follower: Int, following: Int) {
        profileInfoVM.userInfo.value.followers = follower
        profileInfoVM.userInfo.value.followings = following
    }
}
