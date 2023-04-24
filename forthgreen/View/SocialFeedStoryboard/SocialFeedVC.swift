//
//  SocialFeedVC.swift
//  forthgreen
//
//  Created by MACBOOK on 07/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import SkeletonView
import SainiUtils

var isMuteVideo = true
var dictVideoHeight = [String : Float]()
var dictVideoLoad = [String : Bool]()

class SocialFeedVC: UIViewController, AddPostDeleagte {
    
    private var followUserVM: FollowUserViewModel = FollowUserViewModel()
    private var likePostVM: LikePostViewModel = LikePostViewModel()
    private var socialFeedVM: SocialFeedViewModel = SocialFeedViewModel()
    private var deletePostVM: DeletePostViewModel = DeletePostViewModel()
    private var reportPostVM: ReportPostViewModel = ReportPostViewModel()
    private var userId: String = String()
    private var deletedPostId: String = String()
    private var followedUserPostId: String = String()
    private var followedUserIndex: Int = Int()
    private let refreshControl = UIRefreshControl()
    private var imageArray: [String] = [String]()
    private var page: Int = Int()
    private var hasMore:Bool = false
    private var reportType: REVIEW_TYPE = .post
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var postProgress: UIProgressView!
    
    @IBOutlet weak var btnNewFeed: UIButton!
    @IBOutlet weak var btnFollowingFeed: UIButton!
    
    @IBOutlet weak var viewTabProgress: UIView!
    @IBOutlet weak var viewTabProgressConstatnt: NSLayoutConstraint!
    
    @IBOutlet weak var viewTopTab: UIView!
    
    // OUTLETS
    @IBOutlet var guestUserView: GuestUserView!
    @IBOutlet weak var bottomConstraintOfTableView: NSLayoutConstraint!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bedgeCountView: UIView!
    
    var isCurrentScreen = false
    var isFeedSelected = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updatePostProgress(_:)), name: NOTIFICATIONS.AddPostProgress, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
        self.viewTabProgress.backgroundColor = AppColors.turqoiseGreen
        isMuteVideo = true
        progressView.isHidden = true
        self.viewTopTab.isHidden = AppModel.shared.isGuestUser
        
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: false)
        }
        
        if SCREEN.HEIGHT >= 812 {
            bottomConstraintOfTableView.constant = 76
        } else {
            bottomConstraintOfTableView.constant = 56
        }
        isCurrentScreen = true
        if !self.socialFeedVM.postList.value.isEmpty {
            tableView.reloadData()
            delay(0.1) {
                self.pausePlayeVideos()
            }
        }
    }
    
    @objc func updatePostProgress(_ noti : Notification) {
        if let dict = noti.object as? [String : Any] {
            if let progress = dict["progress"] as? Double {
                postProgress.progress = Float(progress)
                progressLbl.text = "\(Int(progress*100))%"
                progressView.isHidden = (Int(progress) == 100)
                if Int(progress) == 100 {
                    refreshData()
                }
            }
            else{
                progressView.isHidden = true
            }
        }else{
            progressView.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isCurrentScreen = true
        pausePlayeVideos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isCurrentScreen = false
        stopPlayerVideos()
    }
    
    func dismissAddPost() {
        pausePlayeVideos()
    }
    
    //MARK: - configUI
    private func configUI() {
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        guestUserView.crossBtn.isHidden = true
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.socialFeedCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.socialFeedCell.rawValue)
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.UserInfoCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.UserInfoCell.rawValue)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateBadgeCount(noti:)), name: NOTIFICATIONS.UpdateBadge, object: nil)
        postProgress.transform = CGAffineTransform(scaleX: 1, y: 0.5)
//        progressView.setShadow(applyShadow: true)
        bedgeCountView.layer.cornerRadius =  bedgeCountView.frame.size.height / 2
        bedgeCountView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        bedgeCountView.layer.borderWidth = 2
        bedgeCountView.layer.masksToBounds = true
        
        if let user = AppModel.shared.currentUser {
            userId = user.id
        }
        
        page = 1
        hasMore = false
        socialFeedVM.fetchFollowingPosts(page: page)
        socialFeedVM.fetchPosts(page: page)
        
        
        socialFeedVM.postListSuccess.bind { [weak self] (_) in
            guard let `self` = self else { return }
            
            if self.socialFeedVM.postListSuccess.value {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.shimmerView.hideSkeleton()
                    self.shimmerView.isHidden = true
                }
            }
        }
        
        socialFeedVM.postFollowingList.bind { [weak self] (_) in
            guard let `self` = self else { return }
            
            if self.socialFeedVM.postListFollowingSuccess.value {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.shimmerView.hideSkeleton()
                    self.shimmerView.isHidden = true
                }
            }
        }
        
        socialFeedVM.hasMore.bind { [weak self](_) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.hasMore = self.socialFeedVM.hasMore.value
            }
        }
        
        socialFeedVM.hasFollowingMore.bind { [weak self](_) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.hasMore = self.socialFeedVM.hasFollowingMore.value
            }
        }
        
        socialFeedVM.postList.bind { [weak self](_) in
            guard let `self` = self else { return }
            if !self.socialFeedVM.postList.value.isEmpty {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    delay(1.0) {
                        self.pausePlayeVideos()
                    }
                }
            }
        }
        
        socialFeedVM.postFollowingList.bind { [weak self](_) in
            guard let `self` = self else { return }
            if !self.socialFeedVM.postFollowingList.value.isEmpty {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.shimmerView.hideSkeleton()
                    self.shimmerView.isHidden = true
                    self.tableView.reloadData()
                    delay(1.0) {
                        self.pausePlayeVideos()
                    }
                }
            } else {
                if self.isFeedSelected == false {
                    DispatchQueue.main.async {
                        self.shimmerView.hideSkeleton()
                        self.shimmerView.isHidden = true
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        socialFeedVM.newPostAdded.bind { [weak self](_) in
            guard let `self` = self else { return }
            if !self.isScrolledToTop {
                self.scrollToTop()
            }
        }
        
        deletePostVM.success.bind { [weak self] (_) in
            guard let `self` = self else { return }
            if self.deletePostVM.success.value {
                self.socialFeedVM.deletePostLocally(id: self.deletedPostId)
                AppDelegate().sharedDelegate().showErrorToast(message: STATIC_LABELS.deletePostSuccessToast.rawValue, true)
                self.tableView.reloadData()
                delay(1.0) {
                    self.playFirstVisibleVideo(true)
//                    self.pausePlayeVideos()
                }
            }
        }
        
        likePostVM.likePostInfo.bind { [weak self](_) in
            guard let `self` = self else { return }
            let postRef = self.likePostVM.likePostInfo.value.ref
            let likeStatus = self.likePostVM.likePostInfo.value.status
            self.socialFeedVM.likePost(postRef: postRef, status: likeStatus)
        }
        
        followUserVM.success.bind { [weak self] (_) in
            guard let `self` = self else { return }
            if self.followUserVM.success.value {
                self.socialFeedVM.followUser(userId: self.followedUserPostId, followStatus: !self.socialFeedVM.postList.value[self.followedUserIndex].isFollow)
            }
        }
        
        reportPostVM.success.bind { [weak self] (_) in
            guard let `self` = self else { return }
            if self.reportPostVM.success.value {
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ReportSentVC") as! ReportSentVC
                vc.isReviewReported = true
                vc.reportType = self.reportType
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        
        addRefreshControl()
        
        UpdateBrandBadge()
    }
    
    @objc func UpdateBadgeCount(noti : Notification) {
        UpdateBrandBadge()
    }
    
    func UpdateBrandBadge() {
        guard let show = UserDefaults.standard.value(forKey: USER_DEFAULT_KEYS.badgeCount.rawValue) as? Bool else{
            return
        }
        DispatchQueue.main.async {
            if show{
                self.bedgeCountView.isHidden = false
            }
            else{
                self.bedgeCountView.isHidden = true
            }
        }
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
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:16/255, green:27/255, blue:57/255, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "")
    }
    
    //MARK: - refreshData
    @objc func refreshData() {
//        shimmerView.isHidden = false
//        shimmerView.isSkeletonable = true
//        shimmerView.showAnimatedGradientSkeleton()
        stopPlayerVideos()
        page = 1
        hasMore = false

        if self.isFeedSelected {
            socialFeedVM.fetchPosts(page: page)
        } else {
            socialFeedVM.fetchFollowingPosts(page: page)
        }
    }
    
    //MARK: - addPostBtnIsPressed
    @IBAction func addPostBtnIsPressed(_ sender: UIButton) {
        stopPlayerVideos()
        if AppModel.shared.isGuestUser {
            showGuestView()
            guestUserView.crossBtn.isHidden = true
        }
        else {
            guestUserView.isHidden = true
            let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.AddPostVC.rawValue) as! AddPostVC
            vc.socialFeedVM = self.socialFeedVM
            vc.deleagte = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func clickToNotificaiton(_ sender: Any) {
        if AppModel.shared.isGuestUser {
            self.showGuestView()
        } else {
            let vc = STORYBOARD.NOTIFICATION.instantiateViewController(withIdentifier: NOTIFICATION_STORYBOARD.NotificationVC.rawValue) as! NotificationVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - searchBtnIsPressed
    @IBAction func searchBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            showGuestView()
            guestUserView.crossBtn.isHidden = true
        }
        else {
            guestUserView.isHidden = true
            let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.SearchPostVC.rawValue) as! SearchPostVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func feedBtnPressed(_ sender: UIButton) {
        self.isFeedSelected = true
        self.viewTabProgressConstatnt.constant = 0
        page = 1
        hasMore = false
        socialFeedVM.fetchPosts(page: page)
        self.tableView.reloadData()
    }
    
    
    @IBAction func follwoingBtnPressed(_ sender: Any) {
        self.isFeedSelected = false
        self.viewTabProgressConstatnt.constant = self.view.frame.width / 2
        if self.socialFeedVM.postFollowingList.value.isEmpty {
            self.shimmerView.showAnimatedGradientSkeleton()
            self.shimmerView.isHidden = false
        }
        page = 1
        hasMore = false
        socialFeedVM.fetchFollowingPosts(page: page)
        self.tableView.reloadData()
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
}

extension SocialFeedVC: AlertDelegate {
    func didClickOkBtn() {
        (UIApplication.shared.delegate as? AppDelegate)?.logoutUser()
    }
    
    func didClickCancelBtn() {
        
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension SocialFeedVC: UITableViewDelegate, UITableViewDataSource {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isFeedSelected {
            if socialFeedVM.postList.value.count == 0 {
                tableView.sainiSetEmptyMessage(STATIC_LABELS.noDataFound.rawValue)
            } else {
                tableView.restore()
                tableView.separatorStyle = .none
            }
            return socialFeedVM.postList.value.count
        } else {
            if socialFeedVM.postFollowingList.value.count == 0 {
                tableView.sainiSetEmptyMessage(STATIC_LABELS.noFollowUserDataFound.rawValue)
            } else {
                tableView.restore()
                tableView.separatorStyle = .none
            }
            return socialFeedVM.postFollowingList.value.count
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
      
        if self.isFeedSelected && socialFeedVM.postList.value.isEmpty {
            return UITableViewCell()
        } else if !self.isFeedSelected && socialFeedVM.postFollowingList.value.isEmpty {
            return UITableViewCell()
        }

        let objectPost = self.isFeedSelected ? socialFeedVM.postList.value[indexPath.row] : socialFeedVM.postFollowingList.value[indexPath.row]
        let postType: POST_TYPES = POST_TYPES(rawValue: objectPost.type ?? DocumentDefaultValues.Empty.int) ?? .text
        if postType == .user {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.UserInfoCell.rawValue, for: indexPath) as? UserInfoCell else { return UITableViewCell() }
            cell.nameLbl.text = objectPost.name
            cell.profileImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: AppImageUrl.small + objectPost.image[0])
            cell.bioLbl.isHidden = true
            cell.bioView.isHidden = true
            cell.userNameLbl.isHidden = true
//            cell.bioLbl.text = socialFeedVM.postList.value[indexPath.row].bio
//            cell.userNameLbl.text = STATIC_LABELS.atTheRate.rawValue +  "\(socialFeedVM.postList.value[indexPath.row].username)"
            if objectPost.addedBy.dummyUser {
                cell.followBtn.isHidden = true
            }
            else {
                cell.followBtn.isHidden = false
                if objectPost.isFollow {
                    cell.followBtn.setTitle(STATIC_LABELS.followingBtnTitle.rawValue, for: .normal)
                    cell.followBtn.backgroundColor = AppColors.paleGrey
                }
                else {
                    cell.followBtn.setTitle(STATIC_LABELS.followBtnTitle.rawValue, for: .normal)
                    cell.followBtn.backgroundColor = AppColors.turqoiseGreen
                }
            }

            cell.otherUserProfileBtn.tag = indexPath.row
            cell.otherUserProfileBtn.addTarget(self, action: #selector(goToOtherUserProfileBtnIsPressed), for: .touchUpInside)
            cell.followBtn.tag = indexPath.row
            cell.followBtn.addTarget(self, action: #selector(followUserBtnIsPressed), for: .touchUpInside)
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.socialFeedCell.rawValue, for: indexPath) as? socialFeedCell else { return UITableViewCell() }
            cell.fromSocialFeed = true
            cell.postInfo = objectPost
            cell.soundBtn.isSelected = isMuteVideo
            cell.frame = tableView.bounds
            cell.layoutIfNeeded()
            cell.likeBtn.tag = indexPath.row
            cell.likeBtn.addTarget(self, action: #selector(likePostBtnIsPressed), for: .touchUpInside)
            cell.viewMoreBtn.tag = indexPath.row
            cell.viewMoreBtn.addTarget(self, action: #selector(viewBtnIsPressed), for: .touchUpInside)
            cell.threeDotBtn.tag = indexPath.row
            cell.threeDotBtn.addTarget(self, action: #selector(threeDotBtnIsPressed), for: .touchUpInside)
            cell.gotoCommentListBtn.tag = indexPath.row
            cell.gotoCommentListBtn.addTarget(self, action: #selector(addCommentBtnIsPressed), for: .touchUpInside)
            cell.addCommentBtn.tag = indexPath.row
            cell.addCommentBtn.addTarget(self, action: #selector(addCommentBtnIsPressed), for: .touchUpInside)
            cell.profileBtn.tag = indexPath.row
            cell.profileBtn.addTarget(self, action: #selector(otherUserProfileBtnIsPressed), for: .touchUpInside)
            
            cell.goToLikeListBtn.tag = indexPath.row
            cell.goToLikeListBtn.addTarget(self, action: #selector(addLikeBtnIsPressed), for: .touchUpInside)
            
            cell.soundBtn.tag = indexPath.row
            cell.soundBtn.addTarget(self, action: #selector(muteUnmuteSound(sender:)), for: .touchUpInside)
            
//            if indexPath.row % 3 == 0 {
           //     cell.likesBackView.isHidden = false
//                if getLikedString(likeData: objectPost.whoLiked) != "" {
//                    cell.likesBackView.isHidden = false
//                    cell.othersLikeLbl.attributedText = attributedStringWithColor(getLikedString(likeData: objectPost.whoLiked), objectPost.whoLiked.map({ $0.firstName }), color: .black, font: UIFont.init(name: APP_FONT.buenosAiresBold.rawValue, size: 12.0), lineSpacing: 2)
//                }
//                else{
//                    cell.likesBackView.isHidden = true
//                }
//            }
//            else{
//                cell.likesBackView.isHidden = true
//            }
            
            return cell
        }
    }
    
    //willDisplay
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Pagination
        if indexPath.row == socialFeedVM.postList.value.count - 2 && hasMore  && self.isFeedSelected {
            page = page + 1
            socialFeedVM.fetchPosts(page: page)
        } else if indexPath.row == socialFeedVM.postFollowingList.value.count - 2 && hasMore  && !self.isFeedSelected {
            page = page + 1
            socialFeedVM.fetchFollowingPosts(page: page)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
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
    
    func pausePlayeVideos(){
        if isCurrentScreen {
            ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView)
        }
    }
    
    func stopPlayerVideos() {
        DispatchQueue.main.async {
            ASVideoPlayerController.sharedVideoPlayer.stopPlayeVideosFor(tableView: self.tableView)
        }
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
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView, appEnteredFromBackground: true)
    }
    
    func getLikedString(likeData: [AddedBy]) -> String {
        var str: String = String()
        if likeData.count == 1 {
            str = "\(likeData[0].firstName) likes this"
        }
        else if likeData.count == 2 {
            str = "\(likeData[0].firstName) and \(likeData[1].firstName) likes this"
        }
        return str
    }
    
    @objc func muteUnmuteSound(sender: UIButton) {
        isMuteVideo = !isMuteVideo
        var arrData = [IndexPath]()
        arrData.append(IndexPath(row: sender.tag, section: 0))
        if sender.tag > 0 {
            arrData.append(IndexPath(row: sender.tag-1, section: 0))
        }
        if sender.tag < socialFeedVM.postList.value.count-1 {
            arrData.append(IndexPath(row: sender.tag+1, section: 0))
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
    
    //MARK: - followUserBtnIsPressed
    @objc func followUserBtnIsPressed(sender: UIButton) {
        if AppModel.shared.isGuestUser {
            showGuestView()
            guestUserView.crossBtn.isHidden = true
        }
        else {
            guestUserView.isHidden = true
            followedUserIndex = sender.tag
            followedUserPostId = socialFeedVM.postList.value[sender.tag].id
            let request = FollowUserRequest(followingRef: followedUserPostId, follow: !socialFeedVM.postList.value[sender.tag].isFollow)
            followUserVM.followUser(request: request)
        }
    }
    
    //MARK: - goToOtherUserProfileBtnIsPressed
    @objc func goToOtherUserProfileBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            showGuestView()
            guestUserView.crossBtn.isHidden = true
        }
        else {
            guestUserView.isHidden = true
            let id = self.isFeedSelected ? socialFeedVM.postList.value[sender.tag].id : socialFeedVM.postFollowingList.value[sender.tag].id
            
            if userId != id {
                let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.OtherUserProfileVC.rawValue) as! OtherUserProfileVC
                vc.userId = id
                vc.userIsFrom = .home
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //MARK: - viewBtnIsPressed
    @objc func viewBtnIsPressed(sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? socialFeedCell
        cell?.viewMoreBtn.isHidden = true
        cell?.heightConstraintOfViewMoreBtnView.constant = 0
        if self.isFeedSelected {
            self.socialFeedVM.postList.value[sender.tag].isTextExpanded = true
            cell?.postTxtLbl.numberOfLines = self.socialFeedVM.postList.value[sender.tag].postTextLineCount
        } else {
            self.socialFeedVM.postFollowingList.value[sender.tag].isTextExpanded = true
            cell?.postTxtLbl.numberOfLines = self.socialFeedVM.postFollowingList.value[sender.tag].postTextLineCount
        }
        
    }
    
    //MARK: - addCommentBtnIsPressed
    @objc func likePostBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            showGuestView()
            guestUserView.crossBtn.isHidden = true
        }
        else {
            guestUserView.isHidden = true
            AppDelegate().sharedDelegate().vibrateOnTouch()
            if self.isFeedSelected {
                let request = LikePostRequest(postRef: socialFeedVM.postList.value[sender.tag].id,
                                              like: !socialFeedVM.postList.value[sender.tag].isLike)
                likePostVM.likePost(request: request)
            } else {
                let request = LikePostRequest(postRef: socialFeedVM.postFollowingList.value[sender.tag].id,
                                              like: !socialFeedVM.postFollowingList.value[sender.tag].isLike)
                likePostVM.likePost(request: request)
            }
        }
    }
    
    //MARK: - addCommentBtnIsPressed
    @objc func addCommentBtnIsPressed(_ sender: UIButton) {
        stopPlayerVideos()
        if AppModel.shared.isGuestUser {
            showGuestView()
            guestUserView.crossBtn.isHidden = true
        }
        else {
            guestUserView.isHidden = true
            let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.CommentListVC.rawValue) as! CommentListVC
            if self.isFeedSelected {
                vc.postRef = socialFeedVM.postList.value[sender.tag].id
            } else {
                vc.postRef = socialFeedVM.postFollowingList.value[sender.tag].id
            }
            vc.userIsFrom = .home
            vc.socialFeedVM = self.socialFeedVM
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - addLikeBtnIsPressed
    @objc func addLikeBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            showGuestView()
            guestUserView.crossBtn.isHidden = true
        }
        else {
            guestUserView.isHidden = true
            let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.PostLikeVC.rawValue) as! PostLikeVC
            vc.userIsFrom = .home
            if self.isFeedSelected {
                vc.ref = socialFeedVM.postList.value[sender.tag].id
            } else {
                vc.ref = socialFeedVM.postFollowingList.value[sender.tag].id
            }
            vc.likeType = .POST
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - otherUserProfileBtnIsPressed
    @objc func otherUserProfileBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            showGuestView()
            guestUserView.crossBtn.isHidden = true
        }
        else {
            guestUserView.isHidden = true
            if userId != socialFeedVM.postList.value[sender.tag].addedBy.id {
                let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.OtherUserProfileVC.rawValue) as! OtherUserProfileVC
                if self.isFeedSelected {
                    vc.userId = socialFeedVM.postList.value[sender.tag].addedBy.id
                } else {
                    vc.userId = socialFeedVM.postFollowingList.value[sender.tag].addedBy.id
                }
                vc.userIsFrom = .home
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //MARK: - threeDotBtnIsPressed
    @objc func threeDotBtnIsPressed(_ sender: UIButton) {
        stopPlayerVideos()
        if AppModel.shared.isGuestUser {
            showGuestView()
            guestUserView.crossBtn.isHidden = true
        }
        else {
            guestUserView.isHidden = true
            let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cancelButton = UIAlertAction(title: STATIC_LABELS.cancel.rawValue, style: .cancel) { _ in
                log.result(STATIC_LABELS.cancel.rawValue)/
                self.pausePlayeVideos()
            }
            actionSheet.addAction(cancelButton)
            
            if socialFeedVM.postList.value[sender.tag].addedBy.id == userId {
                let deleteBtn = UIAlertAction(title: STATIC_LABELS.removePost.rawValue, style: .default)
                { _ in
                    log.result(STATIC_LABELS.removePost.rawValue)/
                    if self.isFeedSelected {
                        self.deletedPostId = self.socialFeedVM.postList.value[sender.tag].id
                    } else {
                        self.deletedPostId = self.socialFeedVM.postFollowingList.value[sender.tag].id
                    }
                    let request = DeletePostRequest(postRef: self.deletedPostId)
                    self.deletePostVM.deletePost(request: request)
                }
                actionSheet.addAction(deleteBtn)
            }
            else {
                let reportBtn = UIAlertAction(title: STATIC_LABELS.reportPost.rawValue, style: .default)
                { _ in
                    log.result(STATIC_LABELS.reportPost.rawValue)/
                    let ref =  self.isFeedSelected ? self.socialFeedVM.postList.value[sender.tag].id : self.socialFeedVM.postFollowingList.value[sender.tag].id
                    let request = ReportPostRequest(postRef: ref)
                    self.reportPostVM.reportPost(request: request)
                    self.pausePlayeVideos()
                }
                actionSheet.addAction(reportBtn)
            }
            
            actionSheet.popoverPresentationController?.sourceView = self.view
            actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            actionSheet.popoverPresentationController?.permittedArrowDirections = []
            actionSheet.view.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
}

extension UIView {
    var snapshot: UIImage {
        return UIGraphicsImageRenderer(size: bounds.size).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}
