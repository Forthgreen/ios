//
//  PostDetailVC.swift
//  forthgreen
//
//  Created by MACBOOK on 09/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils

class PostDetailVC: UIViewController {
    
    var notificationVM: NotificationViewModel = NotificationViewModel()
    private var notificationDetailVM: NotificationDetailViewModel = NotificationDetailViewModel()
    private var likePostVM: LikePostViewModel = LikePostViewModel()
    private var deletePostVM: DeletePostViewModel = DeletePostViewModel()
    private var reportPostVM: ReportPostViewModel = ReportPostViewModel()
    
    private var reportCommentVM: ReportCommentViewModel = ReportCommentViewModel()
    private var likeCommentVM: likeCommentViewModel = likeCommentViewModel()
    private var deleteCommentVM: DeleteCommentViewModel = DeleteCommentViewModel()
    private var likeType: COMMENT_TYPE = .comment
    var ref: String = String()
    var refType: NOTIFICATION_TYPE = .postLike
    private var deletedPostId: String = String()
    private var deletedCommentId: String = String()
    private var deletedReplyId: String = String()
    private var reportType: REVIEW_TYPE = .comment
    
    // OUTLETS
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var isCurrentScreen = false
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isCurrentScreen = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        tabBar.setTabBarHidden(tabBarHidden: true)
        
        if !self.notificationDetailVM.postDetail.value.isEmpty {
            self.tableView.reloadData()
            delay(0.1) {
                self.pausePlayeVideos()
            }
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
    
    //MARK: - configUI
    private func configUI() {
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.socialFeedCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.socialFeedCell.rawValue)
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.CommentCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.CommentCell.rawValue)
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.ReplyCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ReplyCell.rawValue)
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.AddCommentCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.AddCommentCell.rawValue)
        
        let request = NotificationDetailRequest(notificationId: ref)
        notificationDetailVM.fetchNotiDetail(request: request)
        
        notificationDetailVM.failure.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.notificationDetailVM.failure.value {
                switch self.refType {
                case .comment:
                    self.view.sainiShowToast(message: STATIC_LABELS.noCommentExist.rawValue)
                case .replyComment:
                    self.view.sainiShowToast(message: STATIC_LABELS.noReplyExist.rawValue)
                case .postLike:
                    self.view.sainiShowToast(message: STATIC_LABELS.noPostExist.rawValue)
                case .commentLike:
                    self.view.sainiShowToast(message: STATIC_LABELS.noCommentExist.rawValue)
                case .following:
                    break
                case .replyLike:
                    self.view.sainiShowToast(message: STATIC_LABELS.noReplyExist.rawValue)
                }
                self.navigationController?.popViewController(animated: false)
            }
        }
        
        notificationDetailVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.notificationDetailVM.success.value {
                self.shimmerView.hideSkeleton()
                self.shimmerView.isHidden = true
            }
        }
        
        notificationDetailVM.postDetail.bind { [weak self](_) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                delay(1.0) {
                    self.playFirstVisibleVideo(true)
                }
            }
        }
        
        likePostVM.likePostInfo.bind { [weak self](_) in
            guard let `self` = self else { return }
            let postRef = self.likePostVM.likePostInfo.value.ref
            let likeStatus = self.likePostVM.likePostInfo.value.status
            self.notificationDetailVM.likePost(postRef: postRef, status: likeStatus)
        }
        
        deletePostVM.success.bind { [weak self] (_) in
            guard let `self` = self else { return }
            if self.deletePostVM.success.value {
                self.deletePostVM.success.value = false
                self.notificationVM.deleteNotification(postRef: self.ref)
                self.notificationDetailVM.deletePostLocally(id: self.deletedPostId)
                AppDelegate().sharedDelegate().showErrorToast(message: STATIC_LABELS.deletePostSuccessToast.rawValue, true)
                self.navigationController?.popViewController(animated: false)
            }
        }
        
        deleteCommentVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.deleteCommentVM.success.value {
                switch self.likeType {
                case .comment:
                    self.notificationDetailVM.deleteComment(commentRef: self.deletedCommentId)
                    AppDelegate().sharedDelegate().showErrorToast(message: STATIC_LABELS.deleteCommentToast.rawValue, true)
                    self.notificationDetailVM.postDetail.value[0].posts.comment = Comment()
                case .reply:
                    self.notificationDetailVM.deleteReply(replyRef: self.deletedReplyId)
                    AppDelegate().sharedDelegate().showErrorToast(message: STATIC_LABELS.deleteReplyToast.rawValue, true)
                    self.notificationDetailVM.postDetail.value[0].posts.comment.reply = Reply()
                }
                self.notificationVM.deleteNotification(postRef: self.ref)
                self.navigationController?.popViewController(animated: false)
            }
        }
        
        likeCommentVM.likeSuccess.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.likeCommentVM.likeSuccess.value {
                switch self.likeType {
                case .comment:
                    let commentRef = self.likeCommentVM.likeCommentInfo.value.ref
                    let likeStatus = self.likeCommentVM.likeCommentInfo.value.status
                    self.notificationDetailVM.likeComment(commentRef: commentRef, status: likeStatus)
                case .reply:
                    let replyRef = self.likeCommentVM.likeCommentInfo.value.ref
                    let likeStatus = self.likeCommentVM.likeCommentInfo.value.status
                    self.notificationDetailVM.likeReply(replyRef: replyRef, status: likeStatus)
                }
            }
        }
        
        reportCommentVM.success.bind { [weak self] (_) in
            guard let `self` = self else { return }
            if self.reportCommentVM.success.value {
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ReportSentVC") as! ReportSentVC
                vc.isReviewReported = true
                vc.reportType = self.reportType
                self.navigationController?.pushViewController(vc, animated: false)
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
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView DataSource and Delegate Methods
extension PostDetailVC: UITableViewDelegate, UITableViewDataSource {
    // numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if notificationDetailVM.postDetail.value.first?.posts == nil {
                return 0
            }
            else {
                return 1
            }
        }
        else if section == 1 {
            if notificationDetailVM.postDetail.value.first?.posts.comment.id == DocumentDefaultValues.Empty.string {
                return 0
            }
            else {
                return 1
            }
        }else if section == 2 {
            if notificationDetailVM.postDetail.value.first?.posts.comment.reply.id == DocumentDefaultValues.Empty.string {
                return 0
            }
            else {
                return 1
            }
        } else {
            return 0
//            if notificationDetailVM.postDetail.value.first?.posts.comments ?? DocumentDefaultValues.Empty.int >= 1 &&  notificationDetailVM.postDetail.value.first?.refType != 3{
//                return 1
//            }
//            else {
//                return 0
//            }
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.socialFeedCell.rawValue, for: indexPath) as? socialFeedCell else { return UITableViewCell() }
            cell.postDetail = notificationDetailVM.postDetail.value[indexPath.row].posts
            cell.soundBtn.isSelected = isMuteVideo
            cell.frame = tableView.bounds
            cell.layoutIfNeeded()
            cell.likeBtn.tag = indexPath.row
            cell.likeBtn.addTarget(self, action: #selector(likePostBtnIsPressed), for: .touchUpInside)
            cell.viewMoreBtn.tag = indexPath.row
            cell.viewMoreBtn.addTarget(self, action: #selector(viewMoreBtnOfPostIsPressed), for: .touchUpInside)
            cell.threeDotBtn.tag = indexPath.row
            cell.threeDotBtn.addTarget(self, action: #selector(threeDotBtnOfPostIsPressed), for: .touchUpInside)
            cell.gotoCommentListBtn.tag = indexPath.row
            cell.gotoCommentListBtn.addTarget(self, action: #selector(addCommentBtnOfPostIsPressed), for: .touchUpInside)
            cell.addCommentBtn.tag = indexPath.row
            cell.addCommentBtn.addTarget(self, action: #selector(addCommentBtnOfPostIsPressed), for: .touchUpInside)
            cell.threeDotBtn.tag = indexPath.row
            cell.threeDotBtn.addTarget(self, action: #selector(threeDotBtnOfPostIsPressed), for: .touchUpInside)
            cell.soundBtn.tag = indexPath.row
            cell.soundBtn.addTarget(self, action: #selector(muteUnmuteSound(sender:)), for: .touchUpInside)
            
            return cell
        }
        else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.CommentCell.rawValue, for: indexPath) as? CommentCell else { return UITableViewCell() }
            if notificationDetailVM.postDetail.value.count >= 1 {
                cell.commentInfo = notificationDetailVM.postDetail.value[indexPath.row].posts.comment
            }
            
            cell.viewMoreBtn.tag = indexPath.row
            cell.viewMoreBtn.addTarget(self, action: #selector(viewMoreBtnOfCommentIsPressed), for: .touchUpInside)
            cell.likeBtn.tag = indexPath.row
            cell.likeBtn.addTarget(self, action: #selector(likeCommentBtnIsPressed), for: .touchUpInside)
            cell.threeDotsBtn.tag = indexPath.row
            cell.threeDotsBtn.addTarget(self, action: #selector(threeDotBtnOfCommentIsPressed), for: .touchUpInside)
            cell.gotoReplyBtn.tag = indexPath.row
            cell.gotoReplyBtn.addTarget(self, action: #selector(addReplyBtnOfCommentIsPressed), for: .touchUpInside)
            cell.addReplyBtn.tag = indexPath.row
            cell.addReplyBtn.addTarget(self, action: #selector(addReplyBtnOfCommentIsPressed), for: .touchUpInside)
            return cell
        }
        else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ReplyCell.rawValue, for: indexPath) as? ReplyCell else { return UITableViewCell() }
            if notificationDetailVM.postDetail.value.count >= 1 {
                cell.replyInfo = notificationDetailVM.postDetail.value[indexPath.row].posts.comment.reply
            }
            
            cell.viewMoreBtn.tag = indexPath.row
            cell.viewMoreBtn.addTarget(self, action: #selector(viewMoreBtnOfReplyIsPressed), for: .touchUpInside)
            cell.likeBtn.tag = indexPath.row
            cell.likeBtn.addTarget(self, action: #selector(likeReplyBtnIsPressed), for: .touchUpInside)
            cell.threeDotsBtn.tag = indexPath.row
            cell.threeDotsBtn.addTarget(self, action: #selector(threeDotBtnOfReplyIsPressed), for: .touchUpInside)
            return cell
        }
        else {
            return UITableViewCell()
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.AddCommentCell.rawValue, for: indexPath) as? AddCommentCell else { return UITableViewCell() }
//            cell.loadMoreViewOfReplies.isHidden = true
//            cell.loadMoreBtn.isHidden = false
//            cell.loadMoreBtn.tag = indexPath.row
//            cell.loadMoreBtn.addTarget(self, action: #selector(loadMoreBtnIsPressed), for: .touchUpInside)
//            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
                ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
            }
        }
    }
    
    @objc func muteUnmuteSound(sender: UIButton) {
        isMuteVideo = !isMuteVideo
        if let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? socialFeedCell {
            cell.soundBtn.isSelected = !cell.soundBtn.isSelected
            cell.videoLayer.player?.isMuted = isMuteVideo
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
    
    //=================== POST BUTTON ACTIONS ============================
    //MARK: - likePostBtnIsPressed
    @objc func likePostBtnIsPressed(_ sender: UIButton) {
        AppDelegate().sharedDelegate().vibrateOnTouch()
        let request = LikePostRequest(postRef: notificationDetailVM.postDetail.value[sender.tag].posts.id, like: !notificationDetailVM.postDetail.value[sender.tag].posts.isLike)
        likePostVM.likePost(request: request)
    }
    
    //MARK: - viewMoreBtnOfPostIsPressed
    @objc func viewMoreBtnOfPostIsPressed(sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? socialFeedCell
        cell?.viewMoreBtn.isHidden = true
        cell?.heightConstraintOfViewMoreBtnView.constant = 0
        self.notificationDetailVM.postDetail.value[sender.tag].posts.isTextExpanded = true
        cell?.postTxtLbl.numberOfLines = self.notificationDetailVM.postDetail.value[sender.tag].posts.postTextLineCount
    }
    
    //MARK: - addCommentBtnOfPostIsPressed
    @objc func addCommentBtnOfPostIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.CommentListVC.rawValue) as! CommentListVC
        vc.userIsFrom = .postDetail
        vc.postRef = notificationDetailVM.postDetail.value[sender.tag].posts.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - threeDotBtnOfPostIsPressed
    @objc func threeDotBtnOfPostIsPressed(_ sender: UIButton) {
        stopPlayerVideos()
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: STATIC_LABELS.cancel.rawValue, style: .cancel) { _ in
            log.result(STATIC_LABELS.cancel.rawValue)/
        }
        actionSheet.addAction(cancelButton)
        
        if notificationDetailVM.postDetail.value[sender.tag].posts.addedBy.id == AppModel.shared.currentUser?.id {
            let deleteBtn = UIAlertAction(title: STATIC_LABELS.removePost.rawValue, style: .default)
            { _ in
                log.result(STATIC_LABELS.removePost.rawValue)/
                self.deletedPostId = self.notificationDetailVM.postDetail.value[sender.tag].posts.id
                let request = DeletePostRequest(postRef: self.deletedPostId)
                self.deletePostVM.deletePost(request: request)
            }
            actionSheet.addAction(deleteBtn)
        }
        else {
            let reportBtn = UIAlertAction(title: STATIC_LABELS.reportPost.rawValue, style: .default)
            { _ in
                log.result(STATIC_LABELS.reportPost.rawValue)/
                self.reportType = .post
                let ref = self.notificationDetailVM.postDetail.value[sender.tag].posts.id
                let request = ReportPostRequest(postRef: ref)
                self.reportPostVM.reportPost(request: request)
            }
            actionSheet.addAction(reportBtn)
        }
        
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        actionSheet.popoverPresentationController?.permittedArrowDirections = []
        actionSheet.view.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
        self.present(actionSheet, animated: true, completion: nil)
    }
    //====================================================================
    
    //=================== COMMENT BUTTON ACTIONS ============================
    //MARK: - viewMoreBtnOfCommentIsPressed
    @objc func viewMoreBtnOfCommentIsPressed(sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 1)) as? CommentCell
        cell?.viewMoreBtn.isHidden = true
        cell?.heightConstraintOfViewMoreBtnView.constant = 0
        self.notificationDetailVM.postDetail.value[sender.tag].posts.comment.isTextExpanded = true
        cell?.commentTextLbl.numberOfLines = self.notificationDetailVM.postDetail.value[sender.tag].posts.comment.postTextLineCount
    }

    
    //MARK: - likeCommentBtnIsPressed
    @objc func likeCommentBtnIsPressed(_ sender: UIButton) {
        likeType = .comment
        let commentRef = notificationDetailVM.postDetail.value[sender.tag].posts.comment.id
        let request = LikeCommentRequest(commentRef: commentRef, like: !notificationDetailVM.postDetail.value[sender.tag].posts.comment.isLike)
        likeCommentVM.likeComment(request: request)
    }
    
    //MARK: - addReplyBtnIsPressed
    @objc func addReplyBtnOfCommentIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.RepliesVC.rawValue) as! RepliesVC
        vc.commentIndex = sender.tag
        vc.fromNotification = true
        vc.commentInfo = notificationDetailVM.postDetail.value[sender.tag].posts.comment
        vc.postRef = notificationDetailVM.postDetail.value[sender.tag].posts.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - threeDotBtnOfCommentIsPressed
    @objc func threeDotBtnOfCommentIsPressed(_ sender: UIButton) {
        stopPlayerVideos()
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: STATIC_LABELS.cancel.rawValue, style: .cancel) { _ in
            log.result(STATIC_LABELS.cancel.rawValue)/
        }
        actionSheet.addAction(cancelButton)
        
        if notificationDetailVM.postDetail.value[sender.tag].posts.comment.addedBy.id == AppModel.shared.currentUser?.id {
            likeType = .comment
            let deleteBtn = UIAlertAction(title: STATIC_LABELS.removeComment.rawValue, style: .default)
            { _ in
                log.result(STATIC_LABELS.removeComment.rawValue)/
                self.deletedCommentId = self.notificationDetailVM.postDetail.value[sender.tag].posts.comment.id
                let request = DeleteCommentRequest(commentRef: self.deletedCommentId)
                self.deleteCommentVM.deleteComment(request: request)
            }
            actionSheet.addAction(deleteBtn)
        }
        else {
            let reportBtn = UIAlertAction(title: STATIC_LABELS.reportComment.rawValue, style: .default)
            { _ in
                log.result(STATIC_LABELS.reportComment.rawValue)/
                self.reportType = .comment
                let ref = self.notificationDetailVM.postDetail.value[sender.tag].posts.comment.id
                let request = ReportCommentRequest(commentRef: ref)
                self.reportCommentVM.reportComment(request: request)
            }
            actionSheet.addAction(reportBtn)
        }
        
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        actionSheet.popoverPresentationController?.permittedArrowDirections = []
        actionSheet.view.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
        self.present(actionSheet, animated: true, completion: nil)
    }
    //====================================================================
    
    //=================== REPLY BUTTON ACTIONS ============================
    //MARK: - viewMoreBtnOfReplyIsPressed
    @objc func viewMoreBtnOfReplyIsPressed(sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 2)) as? ReplyCell
        cell?.viewMoreBtn.isHidden = true
        cell?.heightConstraintOfViewMoreBtnView.constant = 0
        self.notificationDetailVM.postDetail.value[sender.tag].posts.comment.reply.isTextExpanded = true
        cell?.replyTextLbl.numberOfLines = self.notificationDetailVM.postDetail.value[sender.tag].posts.comment.reply.postTextLineCount
    }
    
    //MARK: - likeReplyBtnIsPressed
    @objc func likeReplyBtnIsPressed(_ sender: UIButton) {
        likeType = .reply
        let commentRef = notificationDetailVM.postDetail.value[sender.tag].posts.comment.reply.id
        let request = LikeCommentRequest(commentRef: commentRef, like: !notificationDetailVM.postDetail.value[sender.tag].posts.comment.reply.isLike)
        likeCommentVM.likeComment(request: request)
    }
    
    //MARK: - threeDotBtnOfCommentIsPressed
    @objc func threeDotBtnOfReplyIsPressed(_ sender: UIButton) {
        stopPlayerVideos()
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: STATIC_LABELS.cancel.rawValue, style: .cancel) { _ in
            log.result(STATIC_LABELS.cancel.rawValue)/
        }
        actionSheet.addAction(cancelButton)
        
        if notificationDetailVM.postDetail.value[sender.tag].posts.comment.reply.addedBy.id == AppModel.shared.currentUser?.id {
            likeType = .reply
            let deleteBtn = UIAlertAction(title: STATIC_LABELS.removeReply.rawValue, style: .default)
            { _ in
                log.result(STATIC_LABELS.removeReply.rawValue)/
                self.deletedReplyId = self.notificationDetailVM.postDetail.value[sender.tag].posts.comment.reply.id
                let request = DeleteCommentRequest(commentRef: self.deletedReplyId)
                self.deleteCommentVM.deleteComment(request: request)
            }
            actionSheet.addAction(deleteBtn)
        }
        else {
            let reportBtn = UIAlertAction(title: STATIC_LABELS.reportReply.rawValue, style: .default)
            { _ in
                log.result(STATIC_LABELS.reportReply.rawValue)/
                self.reportType = .comment
                let ref = self.self.notificationDetailVM.postDetail.value[sender.tag].posts.comment.reply.id
                let request = ReportCommentRequest(commentRef: ref)
                self.reportCommentVM.reportComment(request: request)
            }
            actionSheet.addAction(reportBtn)
        }
        
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        actionSheet.popoverPresentationController?.permittedArrowDirections = []
        actionSheet.view.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
        self.present(actionSheet, animated: true, completion: nil)
    }
    //====================================================================
    
    //MARK: - loadMoreBtnIsPressed
    @objc func loadMoreBtnIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.CommentListVC.rawValue) as! CommentListVC
        vc.userIsFrom = .postDetail
        vc.postRef = notificationDetailVM.postDetail.value[sender.tag].posts.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
