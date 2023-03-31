//
//  RepliesVC.swift
//  forthgreen
//
//  Created by MACBOOK on 10/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils
import IQKeyboardManagerSwift

class RepliesVC: UIViewController {
    
    var profileInfoVM: ProfileInfoViewModel = ProfileInfoViewModel()
    var socialFeedVM: SocialFeedViewModel = SocialFeedViewModel()
    private var likeCommentVM: likeCommentViewModel = likeCommentViewModel()
    private var deleteCommentVM: DeleteCommentViewModel = DeleteCommentViewModel()
    private var addCommentVM: AddCommentViewModel = AddCommentViewModel()
    var commentListVM: CommentListViewModel = CommentListViewModel()
    private var reportCommentVM: ReportCommentViewModel = ReportCommentViewModel()
    private var TagListVM: TagListViewModel = TagListViewModel()
    
    var commentIndex: Int = Int()
    var postRef: String = String()
    var fromNotification: Bool = Bool()
    var commentInfo: Comment = Comment()    // if data is coming from notification > PostDetailVC
    private var deletedReplyIndex: Int = Int()
    private var buttonType: COMMENT_TYPE = .comment
    private let refreshControl = UIRefreshControl()
    private var page: Int = Int()
    private var hasMore: Bool = false
    private var reportType: REVIEW_TYPE = .comment
    var otherUserId: String = String()
    var userIsFrom: USER_IS_FROM = .home
    
    private var tagPage: Int = Int()
    
    // OUTLETS
    @IBOutlet weak var replyView: sainiCardView!
    @IBOutlet weak var bottomConstraintOfReplyTextfieldView: NSLayoutConstraint!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var commentTextfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mentionTxtView: EasyMention!
    var mentionItems = [MentionItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        tabBar.setTabBarHidden(tabBarHidden: true)
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    //MARK: - configUI
    private func configUI() {
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        
        replyView.layer.borderColor = #colorLiteral(red: 0.7568627451, green: 0.7960784314, blue: 0.8117647059, alpha: 1)
        replyView.layer.borderWidth = 1
        
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.CommentCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.CommentCell.rawValue)
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.ReplyCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ReplyCell.rawValue)
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.AddCommentCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.AddCommentCell.rawValue)
        
        var newFrame = mentionTxtView.frame
        newFrame.size.width = SCREEN.WIDTH - 35
        mentionTxtView.frame = newFrame
        mentionTxtView.textViewBorderColor = .clear
        mentionTxtView.font = UIFont.init(name: APP_FONT.buenosAiresBook.rawValue, size: 14)
        mentionTxtView.mentionDelegate = self
        
        hasMore = false
        page = 1
        if fromNotification {
            let request = CommentListRequest(postRef: postRef, commentRef: commentInfo.id, page: page, commentType: .reply)
            commentListVM.fetchCommentListing(request: request)
        }
        else {
            let request = CommentListRequest(postRef: postRef, commentRef: commentListVM.commentList.value[commentIndex].id, page: page, commentType: .reply)
            commentListVM.fetchCommentListing(request: request)
        }
        commentListVM.replySuccess.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.commentListVM.replySuccess.value {
                self.shimmerView.hideSkeleton()
                self.shimmerView.isHidden = true
                self.refreshControl.endRefreshing()
            }
        }
        
        commentListVM.replyHasMore.bind { [weak self](_) in
            guard let `self` = self else { return }
            self.hasMore = self.commentListVM.replyHasMore.value
        }
        
        commentListVM.replyList.bind { [weak self](_) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        addCommentVM.newCommentInfo.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.addCommentVM.newCommentInfo.value.status {
                switch self.userIsFrom {
                case .home:
                    self.socialFeedVM.postList.value.removeAll()
                    self.socialFeedVM.fetchPosts(page: 1)
                case .selfProfile:
                    let userId = AppModel.shared.currentUser?.id ?? DocumentDefaultValues.Empty.string
                    let request = ProfileInfoRequest(userRef: userId)
                    self.profileInfoVM.fetchInfo(request: request)
                case .otherUserProfile:
                    let request = ProfileInfoRequest(userRef: self.otherUserId)
                    self.profileInfoVM.fetchInfo(request: request)
                case .postDetail:
                    break
                }
//                self.view.sainiShowToast(message: STATIC_LABELS.newReplyToast.rawValue)
                if self.fromNotification {
                    self.commentListVM.replyList.value.insert(self.addCommentVM.newCommentInfo.value, at: 0)
                    self.commentInfo.replies += 1
                }
                else {
                    self.commentListVM.addNewReply(replyInfo: self.addCommentVM.newCommentInfo.value, commentIndex: self.commentIndex)
                }
            }
        }
        
        deleteCommentVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.deleteCommentVM.success.value {
                switch self.userIsFrom {
                case .home:
                    self.socialFeedVM.postList.value.removeAll()
                    self.socialFeedVM.fetchPosts(page: 1)
                case .selfProfile:
                    let userId = AppModel.shared.currentUser?.id ?? DocumentDefaultValues.Empty.string
                    let request = ProfileInfoRequest(userRef: userId)
                    self.profileInfoVM.fetchInfo(request: request)
                case .otherUserProfile:
                    let request = ProfileInfoRequest(userRef: self.otherUserId)
                    self.profileInfoVM.fetchInfo(request: request)
                case .postDetail:
                    break
                }
                switch self.buttonType {
                case .comment:
                    if self.fromNotification {
                        self.commentInfo = Comment()
                    }
                    else {
                        self.commentListVM.deleteComment(commentRef: self.commentListVM.commentList.value[self.commentIndex].id)
                    }
                    AppDelegate().sharedDelegate().showErrorToast(message: STATIC_LABELS.deleteCommentToast.rawValue, true)
                    self.navigationController?.popViewController(animated: false)
                case .reply:
                    self.commentListVM.deleteReply(replyRef: self.commentListVM.replyList.value[self.deletedReplyIndex].id, commentIndex: self.commentIndex)
                    AppDelegate().sharedDelegate().showErrorToast(message: STATIC_LABELS.deleteReplyToast.rawValue, true)
                }
            }
        }
        
        likeCommentVM.likeSuccess.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.likeCommentVM.likeSuccess.value {
                let likeStatus = self.likeCommentVM.likeCommentInfo.value.status
                let ref = self.likeCommentVM.likeCommentInfo.value.ref
                switch self.buttonType {
                case .comment:
                    if self.fromNotification {
                        self.commentInfo.isLike = likeStatus
                        if likeStatus {
                            self.commentInfo.likes += 1
                        }
                        else {
                            if self.commentInfo.likes > 0 {
                                self.commentInfo.likes -= 1
                            }
                        }
                    }
                    else {
                        self.commentListVM.likeComment(commentRef: ref, status: likeStatus)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .reply:
                    self.commentListVM.likeReply(replyRef: ref, status: likeStatus)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        hideKeyboardWhenTappedAround()
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
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        commentListVM.replyList.value.removeAll()
        page = 1
        hasMore = false
        let request = CommentListRequest(postRef: postRef, commentRef: commentListVM.commentList.value[commentIndex].id, page: page, commentType: .reply)
        commentListVM.fetchCommentListing(request: request)
    }
    
    //MARK: showKeyboard
    @objc func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.bottomConstraintOfReplyTextfieldView.constant = height - 15
        }
    }
    
    //MARK: - hideKeyboard
    @objc func hideKeyboard(notification: Notification) {
        self.bottomConstraintOfReplyTextfieldView.constant = 0
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - postBtnIsPressed
    @IBAction func postBtnIsPressed(_ sender: UIButton) {
        guard let comment = mentionTxtView.text else { return }
        if comment == DocumentDefaultValues.Empty.string {
            mentionTxtView.resignFirstResponder()
            return
//            self.view.sainiShowToast(message: STATIC_LABELS.replyToast.rawValue)
        }
        else {
            if fromNotification {
                var request = AddCommentRequest(postRef: postRef, comment: comment, commentRef: commentInfo.id)
                
                if mentionTxtView.getCurrentMentions().count != 0 {
                    var tagArr: [tagsRequest] = [tagsRequest]()
                    for item in mentionTxtView.getCurrentMentions() {
                        let data = tagsRequest(id: item.id!, name: item.name, type: item.type ?? 1)
                        tagArr.append(data)
                    }
                    request.tags = tagArr
                }
                addCommentVM.addComment(request: request)
            }
            else {
                var request = AddCommentRequest(postRef: postRef, comment: comment, commentRef: commentListVM.commentList.value[commentIndex].id)
                
                if mentionTxtView.getCurrentMentions().count != 0 {
                    var tagArr: [tagsRequest] = [tagsRequest]()
                    for item in mentionTxtView.getCurrentMentions() {
                        let data = tagsRequest(id: item.id!, name: item.name, type: item.type ?? 1)
                        tagArr.append(data)
                    }
                    request.tags = tagArr
                }
                addCommentVM.addComment(request: request)
            }
            
            mentionTxtView.updateTablview()
            mentionTxtView.text = DocumentDefaultValues.Empty.string
            mentionTxtView.resignFirstResponder()
        }
    }
}

// MARK: - TableView DataSource and Delegate Methods
extension RepliesVC: UITableViewDelegate, UITableViewDataSource {
    // numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            if commentListVM.replyList.value.isEmpty {
                tableView.sainiSetEmptyMessage(STATIC_LABELS.noReplies.rawValue)
                return 0
            }else {
                tableView.restore()
                tableView.separatorStyle = .none
                return commentListVM.replyList.value.count
            }
        } else {
//            if hasMore {
//                return 1
//            } else {
                return 0
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.CommentCell.rawValue, for: indexPath) as? CommentCell else { return UITableViewCell() }
            if fromNotification {
                cell.commentInfo = commentInfo
            }
            else {
                cell.commentList = commentListVM.commentList.value[commentIndex]
            }
            
            cell.viewMoreBtn.tag = indexPath.row
            cell.viewMoreBtn.addTarget(self, action: #selector(viewMoreBtnOfCommentIsPressed), for: .touchUpInside)
            cell.gotoProfileBtn.tag = indexPath.row
            cell.gotoProfileBtn.addTarget(self, action: #selector(gotoProfileBtnOfCommentIsPressed), for: .touchUpInside)
            cell.gotoProfileBtn2.tag = indexPath.row
            cell.gotoProfileBtn2.addTarget(self, action: #selector(gotoProfileBtnOfCommentIsPressed), for: .touchUpInside)
            cell.likeBtn.tag = indexPath.row
            cell.likeBtn.addTarget(self, action: #selector(likeCommentBtnIsPressed), for: .touchUpInside)
            cell.addReplyBtn.tag = indexPath.row
            cell.addReplyBtn.addTarget(self, action: #selector(addReplyBtnIsPressed), for: .touchUpInside)
            cell.threeDotsBtn.tag = indexPath.row
            cell.threeDotsBtn.addTarget(self, action: #selector(threeDotBtnOfCommentIsPressed), for: .touchUpInside)
            cell.goToLikeListBtn.tag = indexPath.row
            cell.goToLikeListBtn.addTarget(self, action: #selector(addLikeBtnOfCommentIsPressed), for: .touchUpInside)
            return cell
        }
        else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ReplyCell.rawValue, for: indexPath) as? ReplyCell else { return UITableViewCell() }
            cell.replyList = commentListVM.replyList.value[indexPath.row]
            
            cell.viewMoreBtn.tag = indexPath.row
            cell.viewMoreBtn.addTarget(self, action: #selector(viewMoreBtnOfReplyIsPressed), for: .touchUpInside)
            cell.gotoProfileBtn.tag = indexPath.row
            cell.gotoProfileBtn.addTarget(self, action: #selector(gotoProfileBtnOfReplyIsPressed), for: .touchUpInside)
            cell.gotoProfileBtn2.tag = indexPath.row
            cell.gotoProfileBtn2.addTarget(self, action: #selector(gotoProfileBtnOfReplyIsPressed), for: .touchUpInside)
            cell.likeBtn.tag = indexPath.row
            cell.likeBtn.addTarget(self, action: #selector(likeReplyBtnIsPressed), for: .touchUpInside)
            cell.threeDotsBtn.tag = indexPath.row
            cell.threeDotsBtn.addTarget(self, action: #selector(threeDotBtnOfReplyIsPressed), for: .touchUpInside)
            cell.gotoLikeListBtn.tag = indexPath.row
            cell.gotoLikeListBtn.addTarget(self, action: #selector(addLikeBtnOfReplyIsPressed), for: .touchUpInside)
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.AddCommentCell.rawValue, for: indexPath) as? AddCommentCell else { return UITableViewCell() }
            cell.loadMoreBtnView.isHidden = true // it should be hidden always because it is for comment list screen
            cell.loadMoreViewOfReplies.isHidden = false
            cell.loadMoreBtnOfReplies.setTitle(STATIC_LABELS.loadMoreBtnTitle.rawValue, for: .normal)
            cell.loadMoreBtnOfReplies.addTarget(self, action: #selector(loadMoreBtnOfRepliesIsPressed), for: .touchUpInside)
            return cell
        }
    }
    
    //willDisplay
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Pagination
        if indexPath.row == commentListVM.replyList.value.count - 2 && hasMore {
            page = page + 1
            let request = CommentListRequest(postRef: postRef, commentRef: commentListVM.commentList.value[commentIndex].id, page: page, commentType: .reply)
            commentListVM.fetchCommentListing(request: request)
        }
    }
    
    //MARK: - addLikeBtnIsPressed
    @objc func addLikeBtnOfCommentIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.PostLikeVC.rawValue) as! PostLikeVC
        vc.ref = commentListVM.commentList.value[commentIndex].id
        vc.likeType = .COMMENT
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - addLikeBtnOfReplyIsPressed
    @objc func addLikeBtnOfReplyIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.PostLikeVC.rawValue) as! PostLikeVC
        vc.ref = commentListVM.replyList.value[sender.tag].id
        vc.likeType = .COMMENT
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - viewMoreBtnOfCommentIsPressed
    @objc func viewMoreBtnOfCommentIsPressed(sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? CommentCell
        cell?.viewMoreBtn.isHidden = true
        cell?.heightConstraintOfViewMoreBtnView.constant = 0
        self.commentListVM.commentList.value[commentIndex].isTextExpanded = true
        cell?.commentTextLbl.numberOfLines = self.commentListVM.commentList.value[commentIndex].postTextLineCount
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - viewMoreBtnOfReplyIsPressed
    @objc func viewMoreBtnOfReplyIsPressed(sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 1)) as? ReplyCell
        cell?.viewMoreBtn.isHidden = true
        cell?.heightConstraintOfViewMoreBtnView.constant = 0
        self.commentListVM.replyList.value[sender.tag].isTextExpanded = true
        cell?.replyTextLbl.numberOfLines = self.commentListVM.replyList.value[sender.tag].postTextLineCount
    }
    
    //MARK: - gotoProfileBtnOfReplyIsPressed
    @objc func gotoProfileBtnOfCommentIsPressed(_ sender: UIButton) {
        if AppModel.shared.currentUser?.id != commentListVM.commentList.value[commentIndex].addedBy.id {
            let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.OtherUserProfileVC.rawValue) as! OtherUserProfileVC
            vc.userId = commentListVM.commentList.value[commentIndex].addedBy.id
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    //MARK: - gotoProfileBtnOfReplyIsPressed
    @objc func gotoProfileBtnOfReplyIsPressed(_ sender: UIButton) {
        if AppModel.shared.currentUser?.id != commentListVM.replyList.value[sender.tag].addedBy.id {
            let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.OtherUserProfileVC.rawValue) as! OtherUserProfileVC
            vc.userId = commentListVM.replyList.value[sender.tag].addedBy.id
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    //MARK: - loadMoreBtnOfRepliesIsPressed
    @objc func loadMoreBtnOfRepliesIsPressed(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 2)) as? AddCommentCell
        cell?.loadMoreBtnOfReplies.setTitle(STATIC_LABELS.loadingBtnTitle.rawValue, for: .normal)
        page = page + 1
        let request = CommentListRequest(postRef: postRef, commentRef: commentListVM.commentList.value[commentIndex].id, page: page, commentType: .reply)
        commentListVM.fetchCommentListing(request: request)
    }
    
    //MARK: - likeCommentBtnIsPressed
    @objc func likeCommentBtnIsPressed(_ sender: UIButton) {
        buttonType = .comment
        AppDelegate().sharedDelegate().vibrateOnTouch()
        if fromNotification {
            let commentRef = commentInfo.id
            let request = LikeCommentRequest(commentRef: commentRef, like: !commentInfo.isLike)
            likeCommentVM.likeComment(request: request)
        }
        else {
            let commentRef = commentListVM.commentList.value[commentIndex].id
            let request = LikeCommentRequest(commentRef: commentRef, like: !commentListVM.commentList.value[commentIndex].isLike)
            likeCommentVM.likeComment(request: request)
        }
    }
    
    //MARK: - likeReplyBtnIsPressed
    @objc func likeReplyBtnIsPressed(_ sender: UIButton) {
        buttonType = .reply
        AppDelegate().sharedDelegate().vibrateOnTouch()
        let commentRef = commentListVM.replyList.value[sender.tag].id
        let request = LikeCommentRequest(commentRef: commentRef, like: !commentListVM.replyList.value[sender.tag].isLike)
        likeCommentVM.likeComment(request: request)
    }
    
    //MARK: - addReplyBtnIsPressed
    @objc func addReplyBtnIsPressed(_ sender: UIButton) {
        self.mentionTxtView.becomeFirstResponder()
    }
    
    //MARK: - threeDotBtnOfReplyIsPressed
    @objc func threeDotBtnOfReplyIsPressed(_ sender: UIButton) {
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: STATIC_LABELS.cancel.rawValue, style: .cancel) { _ in
            log.result(STATIC_LABELS.cancel.rawValue)/
        }
        actionSheet.addAction(cancelButton)
        
        if AppModel.shared.currentUser?.id == commentListVM.replyList.value[sender.tag].addedBy.id {
            let removeReply = UIAlertAction(title: STATIC_LABELS.removeReply.rawValue, style: .default)
            { _ in
                log.result(STATIC_LABELS.removeReply.rawValue)/
                self.buttonType = .reply
                self.deletedReplyIndex = sender.tag
                let request = DeleteCommentRequest(commentRef: self.commentListVM.replyList.value[sender.tag].id)
                self.deleteCommentVM.deleteComment(request: request)
            }
            actionSheet.addAction(removeReply)
        }
        else {
            let reportReply = UIAlertAction(title: STATIC_LABELS.reportReply.rawValue, style: .default)
            { _ in
                log.result(STATIC_LABELS.reportReply.rawValue)/
                let ref = self.commentListVM.replyList.value[sender.tag].id
                let request = ReportCommentRequest(commentRef: ref)
                self.reportCommentVM.reportComment(request: request)
            }
            actionSheet.addAction(reportReply)
        }
        
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        actionSheet.popoverPresentationController?.permittedArrowDirections = []
        actionSheet.view.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - threeDotBtnOfCommentIsPressed
    @objc func threeDotBtnOfCommentIsPressed(_ sender: UIButton) {
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: STATIC_LABELS.cancel.rawValue, style: .cancel) { _ in
            log.result(STATIC_LABELS.cancel.rawValue)/
        }
        actionSheet.addAction(cancelButton)
        
        if AppModel.shared.currentUser?.id == commentListVM.commentList.value[self.commentIndex].addedBy.id {
            let removeComment = UIAlertAction(title: STATIC_LABELS.removeComment.rawValue, style: .default)
            { _ in
                log.result(STATIC_LABELS.removeComment.rawValue)/
                self.buttonType = .comment
                if self.fromNotification {
                    let request = DeleteCommentRequest(commentRef: self.commentInfo.id)
                    self.deleteCommentVM.deleteComment(request: request)
                }
                else {
                    let request = DeleteCommentRequest(commentRef: self.commentListVM.commentList.value[self.commentIndex].id)
                    self.deleteCommentVM.deleteComment(request: request)
                }
            }
            actionSheet.addAction(removeComment)
        }
        else {
            let reportComment = UIAlertAction(title: STATIC_LABELS.reportComment.rawValue, style: .default)
            { _ in
                log.result(STATIC_LABELS.reportComment.rawValue)/
                var commentRef: String = String()
                if self.fromNotification {
                    commentRef = self.commentInfo.id
                }
                else {
                    commentRef = self.commentListVM.commentList.value[self.commentIndex].id
                }
                let request = ReportCommentRequest(commentRef: commentRef)
                self.reportCommentVM.reportComment(request: request)
            }
            actionSheet.addAction(reportComment)
        }
        
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        actionSheet.popoverPresentationController?.permittedArrowDirections = []
        actionSheet.view.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
        self.present(actionSheet, animated: true, completion: nil)
    }
}


extension RepliesVC: EasyMentionDelegate {
    func getPostText(in textView: String) {
        print(textView)
    }

    func mentionSelected(in textView: EasyMention, mention: MentionItem) {
        print(textView.getCurrentMentions())
    }
    
    func startMentioning(in textView: EasyMention, mentionQuery: String) {
        tagPage = 1
        TagListVM.getTagListing(request: TagListRequest(text: mentionQuery, page: tagPage, limit: 100)) { (users) in
            self.mentionItems.removeAll()
            users.forEach({ (user) in
                if user.id != "" {
                    self.mentionItems.append(MentionItem(name: user.name, id: user.id, imageURL: (AppImageUrl.average + user.image!), type: user.type!))
                }
            })
            self.mentionTxtView.setMentions(mentions: self.mentionItems)
        }
    }
}
