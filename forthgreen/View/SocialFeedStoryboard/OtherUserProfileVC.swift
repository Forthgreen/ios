//
//  OtherUserProfileVC.swift
//  forthgreen
//
//  Created by MACBOOK on 09/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils

protocol didPressFollowBtnDelegate {
    func didRecieveFollowAction(userId: String, isFollow: Bool)
}

class OtherUserProfileVC: UIViewController {
    
    private var profileInfoVM: ProfileInfoViewModel = ProfileInfoViewModel()
    private var likePostVM: LikePostViewModel = LikePostViewModel()
    private var followUserVM: FollowUserViewModel = FollowUserViewModel()
    var userId: String = String()
    var followDelegate: didPressFollowBtnDelegate?
    private var selfProfile: Bool = Bool()
    var userIsFrom: USER_IS_FROM = .postDetail
    private var isBackBtnPressed: Bool = Bool()
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var bottomConstraintOfTableView: NSLayoutConstraint!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var alertVM: Alert = Alert()
    var isCurrentScreen = false
    var isMySelfBlocked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isCurrentScreen = true
//        self.navigationController?.navigationBar.titleTextAttributes =
//            [NSAttributedString.Key.foregroundColor: AppColors.charcol,
//             NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBold.rawValue, size: 18)!]
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
        
        if userId == AppModel.shared.currentUser?.id {
            selfProfile = true
            reportBtn.isHidden = true
//            self.navigationItem.rightBarButtonItem?.image = UIImage()
//            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        else {
            reportBtn.isHidden = false
//            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
        if !profileInfoVM.userInfo.value.posts.isEmpty {
            tableView.reloadData()
            delay(0.1) {
                self.pausePlayeVideos()
            }
        }
        
//        if SCREEN.HEIGHT >= 812 {
//            bottomConstraintOfTableView.constant = 76
//        } else {
//            bottomConstraintOfTableView.constant = 56
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pausePlayeVideos()
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isCurrentScreen = false
        stopPlayerVideos()
//        navigationController?.view.backgroundColor = .white
        /*
        if userIsFrom == .home {
            if isBackBtnPressed {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            } else {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        */
    }
    
    //MARK: - configUI
    private func configUI() {
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.socialFeedCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.socialFeedCell.rawValue)
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.OtherUserProfileInfoCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.OtherUserProfileInfoCell.rawValue)
        
        let request = ProfileInfoRequest(userRef: userId)
        profileInfoVM.fetchInfo(request: request)
        
        profileInfoVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.profileInfoVM.success.value {
                self.shimmerView.hideSkeleton()
                self.shimmerView.isHidden = true
                self.tableView.reloadData()
            }
        }
        self.alertVM.delegate = self
        profileInfoVM.userInfo.bind { [weak self](_) in
            guard let `self` = self else { return }
            let profileInfo = self.profileInfoVM.userInfo.value
            self.titleLbl.text = "\(profileInfo.firstName)"//" \(self.profileInfoVM.userInfo.value.lastName)"
            if self.profileInfoVM.userInfo.value.dummyUser {
                self.navigationItem.rightBarButtonItem?.image = UIImage()
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            print(profileInfo.isSenderBlock," ", self.userId)
            if profileInfo.isBlock == false && profileInfo.isSenderBlock.isEmpty == false {
                self.isMySelfBlocked = true
            } else {
                self.isMySelfBlocked = false
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                delay(0.1) {
                    self.playFirstVisibleVideo(true)
                }
            }
        }
        
        likePostVM.likePostInfo.bind { [weak self](_) in
            guard let `self` = self else { return }
            let postRef = self.likePostVM.likePostInfo.value.ref
            let likeStatus = self.likePostVM.likePostInfo.value.status
            self.profileInfoVM.likePost(postRef: postRef, status: likeStatus)
        }
        
        followUserVM.success.bind { [weak self] (_) in
            guard let `self` = self else { return }
            if self.followUserVM.success.value {
                self.followDelegate?.didRecieveFollowAction(userId: self.userId, isFollow: !self.profileInfoVM.userInfo.value.isFollow)
                self.profileInfoVM.userInfo.value.isFollow = !self.profileInfoVM.userInfo.value.isFollow
                if self.profileInfoVM.userInfo.value.isFollow {
                    self.profileInfoVM.userInfo.value.followers += 1
                }
                else {
                    if self.profileInfoVM.userInfo.value.followers > 0 {
                        self.profileInfoVM.userInfo.value.followers -= 1
                    }
                }
            }
        }
        
        profileInfoVM.successBlock.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.profileInfoVM.successBlock.value {
                delay(0.5) {
                    let request = ProfileInfoRequest(userRef: self.userId)
                    self.profileInfoVM.fetchInfo(request: request)
                }
            }
        }
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        isBackBtnPressed = true
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - shareProfileBtnIsPressed
    @IBAction func shareProfileBtnIsPressed(_ sender: UIButton) { // It is changed to report button
        stopPlayerVideos()
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: STATIC_LABELS.cancel.rawValue, style: .cancel) { _ in
            log.result(STATIC_LABELS.cancel.rawValue)/
        }
        actionSheet.addAction(cancelButton)
        
        if isMySelfBlocked == false {
            if self.profileInfoVM.userInfo.value.isBlock == true {
                let blockUserBtn = UIAlertAction(title: STATIC_LABELS.unblockUser.rawValue, style: .default)
                { _ in
                    log.result(STATIC_LABELS.blockUser.rawValue)/
                    self.shimmerView.showSkeleton()
                    self.shimmerView.isHidden = false
                    self.profileInfoVM.blockUser(request: ProfileBlockRequest(blockingRef: self.profileInfoVM.userInfo.value.id, block: false))
                }
                actionSheet.addAction(blockUserBtn)
            } else {
                let blockUserBtn = UIAlertAction(title: STATIC_LABELS.blockUser.rawValue, style: .default)
                { _ in
                    log.result(STATIC_LABELS.blockUser.rawValue)/
                    self.showBloackAlert()
                }
                actionSheet.addAction(blockUserBtn)
            }
        }
        let reportBtn = UIAlertAction(title: STATIC_LABELS.report.rawValue, style: .destructive)
        { _ in
            log.result(STATIC_LABELS.report.rawValue)/
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ReportVC") as! ReportVC
            vc.isPostReport = true
            vc.report = .user
            vc.userRef = self.profileInfoVM.userInfo.value.id
            self.navigationController?.pushViewController(vc, animated: false)
        }
        actionSheet.addAction(reportBtn)
        
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        actionSheet.popoverPresentationController?.permittedArrowDirections = []
        actionSheet.view.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showBloackAlert() {
        DispatchQueue.main.async {
            self.alertVM.displayAlert(vc: self,
                                      alertTitle: STATIC_LABELS.blockUser.rawValue,
                                      message: STATIC_LABELS.blockNotification.rawValue,
                                      okBtnTitle: STATIC_LABELS.block.rawValue,
                                      cancelBtnTitle: STATIC_LABELS.cancel.rawValue)
        }
        
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension OtherUserProfileVC: UITableViewDataSource, UITableViewDelegate {
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
            if profileInfoVM.userInfo.value.isBlock == true {
                tableView.sainiSetEmptyMessage(STATIC_LABELS.blockUserTableMessage.rawValue)
                return 0
            } else if profileInfoVM.userInfo.value.isSenderBlock.isEmpty == false {
                tableView.sainiSetEmptyMessage(STATIC_LABELS.blockByOtherUserMessage.rawValue)
                return 0
            } else {
                tableView.restore()
                tableView.separatorStyle = .none
                return profileInfoVM.userInfo.value.posts.count
            }
           
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.OtherUserProfileInfoCell.rawValue, for: indexPath) as? OtherUserProfileInfoCell else { return UITableViewCell() }
            if selfProfile || profileInfoVM.userInfo.value.dummyUser {
                cell.followBtn.isHidden = true
                cell.followBtn.setTitle(DocumentDefaultValues.Empty.string, for: .normal)
                cell.heightConstraintOfFollowBtn.constant = 0
            }
            else {
                cell.followBtn.isHidden = false
                cell.heightConstraintOfFollowBtn.constant = 32
            }
            cell.nameLbl.text = "\(profileInfoVM.userInfo.value.firstName)" //" \(profileInfoVM.userInfo.value.lastName)"
            cell.profileImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: AppImageUrl.small + profileInfoVM.userInfo.value.image)
            cell.bioLbl.text = profileInfoVM.userInfo.value.bio
            if profileInfoVM.userInfo.value.username == DocumentDefaultValues.Empty.string {
                cell.userNameLbl.isHidden = true
            }
            else {
                cell.userNameLbl.isHidden = false
                cell.userNameLbl.text = STATIC_LABELS.atTheRate.rawValue + "\(profileInfoVM.userInfo.value.username)"
            }
            cell.followersCount.text = "\(profileInfoVM.userInfo.value.followers)"
            cell.followingCount.text = "\(profileInfoVM.userInfo.value.followings)"
            if profileInfoVM.userInfo.value.isBlock == false && profileInfoVM.userInfo.value.isSenderBlock.isEmpty == true {
                cell.viewFollow.isHidden = false
                if profileInfoVM.userInfo.value.isFollow {
                    cell.followBtn.setTitle(STATIC_LABELS.followingBtnTitle.rawValue, for: .normal)
                    cell.followBtn.backgroundColor = AppColors.paleGrey
                }
                else {
                    cell.followBtn.setTitle(STATIC_LABELS.followBtnTitle.rawValue, for: .normal)
                    cell.followBtn.backgroundColor = AppColors.turqoiseGreen
                }
            } else {
                cell.viewFollow.isHidden = true
            }
            cell.followerFollowingBtn.tag = indexPath.row
            cell.followerFollowingBtn.addTarget(self, action: #selector(followerFollowingBtnIsPressed), for: .touchUpInside)
            cell.followBtn.tag = indexPath.row
            cell.followBtn.addTarget(self, action: #selector(followUserBtnIsPressed), for: .touchUpInside)
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.socialFeedCell.rawValue, for: indexPath) as? socialFeedCell else { return UITableViewCell() }
            cell.profileImageView.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: AppImageUrl.average + profileInfoVM.userInfo.value.image)
            cell.nameLbl.text = "\(profileInfoVM.userInfo.value.firstName)" //" \(profileInfoVM.userInfo.value.lastName)"
            cell.timeLbl.text = STATIC_LABELS.atTheRate.rawValue + "\(profileInfoVM.userInfo.value.createdOn)"
            
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
            cell.goToLikeListBtn.tag = indexPath.row
            cell.goToLikeListBtn.addTarget(self, action: #selector(addLikeBtnIsPressed), for: .touchUpInside)
            cell.soundBtn.tag = indexPath.row
            cell.soundBtn.addTarget(self, action: #selector(muteUnmuteSound(sender:)), for: .touchUpInside)
            
            return cell
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
    
    //MARK: - viewMoreBtnOfReplyIsPressed
    @objc func viewMoreBtnIsPressed(sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 1)) as? socialFeedCell
        cell?.viewMoreBtn.isHidden = true
        cell?.heightConstraintOfViewMoreBtnView.constant = 0
        self.profileInfoVM.userInfo.value.posts[sender.tag].isTextExpanded = true
        cell?.postTxtLbl.numberOfLines = self.profileInfoVM.userInfo.value.posts[sender.tag].postTextLineCount
    }
    
    //MARK: - followUserBtnIsPressed
    @objc func followUserBtnIsPressed(sender: UIButton) {
        let request = FollowUserRequest(followingRef: profileInfoVM.userInfo.value.id, follow: !profileInfoVM.userInfo.value.isFollow)
        followUserVM.followUser(request: request)
    }
    
    //MARK: - followerFollowingBtnIsPressed
    @objc func followerFollowingBtnIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.SETTING.instantiateViewController(withIdentifier: SETTING_STORYBOARD.FollowerListVC.rawValue) as! FollowerListVC
        vc.userId = profileInfoVM.userInfo.value.id
        vc.username = "\(profileInfoVM.userInfo.value.firstName)" //" \(profileInfoVM.userInfo.value.lastName)"
        vc.followCountDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
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
        vc.profileInfoVM = self.profileInfoVM
        vc.userIsFrom = .otherUserProfile
        vc.otherUserId = profileInfoVM.userInfo.value.id
        vc.postRef = profileInfoVM.userInfo.value.posts[sender.tag].id
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
        
        let reportBtn = UIAlertAction(title: STATIC_LABELS.reportPost.rawValue, style: .destructive)
        { _ in
            log.result(STATIC_LABELS.reportPost.rawValue)/
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ReportAbuseVC") as! ReportAbuseVC
            vc.reportType = .post
            vc.ref = self.profileInfoVM.userInfo.value.posts[sender.tag].id
            self.navigationController?.pushViewController(vc, animated: false)
        }
        actionSheet.addAction(reportBtn)
        
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        actionSheet.popoverPresentationController?.permittedArrowDirections = []
        actionSheet.view.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
        self.present(actionSheet, animated: true, completion: nil)
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
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView, appEnteredFromBackground: true)
    }
}

//MARK: - FollowCountDelegate
extension OtherUserProfileVC: FollowCountDelegate {
    func fetchFollowerCount(follower: Int, following: Int) {
        profileInfoVM.userInfo.value.followers = follower
        profileInfoVM.userInfo.value.followings = following
    }
}

extension OtherUserProfileVC: AlertDelegate {
    func didClickOkBtn() {
        print("Block User \(self.profileInfoVM.userInfo.value.id)")
        self.shimmerView.showSkeleton()
        self.shimmerView.isHidden = false
        self.profileInfoVM.blockUser(request: ProfileBlockRequest(blockingRef: self.profileInfoVM.userInfo.value.id, block: true))
    }
    
    func didClickCancelBtn() {
        
    }
}
