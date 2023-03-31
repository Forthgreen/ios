//
//  CommentListVC.swift
//  forthgreen
//
//  Created by MACBOOK on 26/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils
import IQKeyboardManagerSwift
//import EasyMention

class CommentListVC: UIViewController {

    private var likeCommentVM: likeCommentViewModel = likeCommentViewModel()
    private var commentListVM: CommentListViewModel = CommentListViewModel()
    private var addCommentVM: AddCommentViewModel = AddCommentViewModel()
    private var deleteCommentVM: DeleteCommentViewModel = DeleteCommentViewModel()
    private var reportCommentVM: ReportCommentViewModel = ReportCommentViewModel()
    private var TagListVM: TagListViewModel = TagListViewModel()
    var profileInfoVM: ProfileInfoViewModel = ProfileInfoViewModel()
    var socialFeedVM: SocialFeedViewModel = SocialFeedViewModel()
    
    var postRef: String = String()
    private let refreshControl = UIRefreshControl()
    private var deletedPostIndex: Int = Int()
    private var page: Int = Int()
    private var hasMore: Bool = false
    private var isBackBtnPressed: Bool = false
    private var reportType: REVIEW_TYPE = .comment
    var otherUserId: String = String()
    var userIsFrom: USER_IS_FROM = .home
    
    private var tagPage: Int = Int()
//    private var tagHasMore: Bool = false
//    var selectedMentionArr: [MentionItem] = [MentionItem]()
    
    // OUTLETS
    @IBOutlet weak var commentView: sainiCardView!
    @IBOutlet weak var bottomConstraintOfCommentTextfieldView: NSLayoutConstraint!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var commentTextfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mentionTxtView: EasyMention!
    @IBOutlet weak var constraintHeightMentionTxt: NSLayoutConstraint!
    var mentionItems = [MentionItem]()
    let textViewMaxHeight: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.titleTextAttributes =
//            [NSAttributedString.Key.foregroundColor: AppColors.charcol,
//             NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBold.rawValue, size: 18)!]
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
//        if userIsFrom == .home {
//            if isBackBtnPressed {
//                self.navigationController?.setNavigationBarHidden(true, animated: true)
//            } else {
//                self.navigationController?.setNavigationBarHidden(false, animated: true)
//            }
//        }
//        else {
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
//        }
    }
    
    //MARK:- configUI
    private func configUI() {
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        mentionTxtView.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 0)
        mentionTxtView.layer.cornerRadius = 10

        /// Uncomment if you would like to see border on CommentTextField
        
//        commentView.layer.borderColor = #colorLiteral(red: 0.7568627451, green: 0.7960784314, blue: 0.8117647059, alpha: 1)
//        commentView.layer.borderWidth = 1
        
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.CommentCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.CommentCell.rawValue)
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.AddCommentCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.AddCommentCell.rawValue)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        page = 1
        hasMore = false
        let request = CommentListRequest(postRef: postRef, page: page, commentType: .comment)
        commentListVM.fetchCommentListing(request: request)
        
        commentListVM.commentSuccess.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.commentListVM.commentSuccess.value {
                self.shimmerView.hideSkeleton()
                self.shimmerView.isHidden = true
                self.refreshControl.endRefreshing()
            }
        }
        
        commentListVM.commentHasMore.bind { [weak self](_) in
            guard let `self` = self else { return }
            self.hasMore = self.commentListVM.commentHasMore.value
        }
        
        commentListVM.commentList.bind { [weak self](_) in
            guard let `self` = self else { return }
            
            if !self.commentListVM.commentList.value.isEmpty {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
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
//                self.view.sainiShowToast(message: STATIC_LABELS.newCommentToast.rawValue)
                self.commentListVM.addNewComment(commentInfo: self.addCommentVM.newCommentInfo.value)
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
                let index = self.commentListVM.commentList.value.firstIndex { temp in
                    temp.id == self.commentListVM.commentList.value[self.deletedPostIndex].id
                }
                if index != nil {
                    self.commentListVM.commentList.value.remove(at: index!)
                    self.tableView.reloadData()
                }
                
                AppDelegate().sharedDelegate().showErrorToast(message: STATIC_LABELS.deleteCommentToast.rawValue, true)
                
            }
        }
        
        likeCommentVM.likeCommentInfo.bind { [weak self](_) in
            guard let `self` = self else { return }
            let commentRef = self.likeCommentVM.likeCommentInfo.value.ref
            let likeStatus = self.likeCommentVM.likeCommentInfo.value.status
            self.commentListVM.likeComment(commentRef: commentRef, status: likeStatus)
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
        
        addRefreshControl()
        hideKeyboardWhenTappedAround()
        
        var newFrame = mentionTxtView.frame
        newFrame.size.width = SCREEN.WIDTH - 35
        mentionTxtView.frame = newFrame
        mentionTxtView.isFromBottom = false
        mentionTxtView.textViewBorderColor = .clear
        mentionTxtView.font = UIFont.init(name: APP_FONT.buenosAiresBook.rawValue, size: 14)
        mentionTxtView.mentionDelegate = self
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
        commentListVM.commentList.value.removeAll()
        page = 1
        hasMore = false
        let request = CommentListRequest(postRef: postRef, page: page, commentType: .comment)
        commentListVM.fetchCommentListing(request: request)
    }
    
    //MARK: showKeyboard
    @objc func showKeyboard(notification: Notification) {
        animateWithKeyboard(notification: notification) { _ in
            if let frame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                self.bottomConstraintOfCommentTextfieldView.constant = height - 15
            }
        }
    }
    
    //MARK: - hideKeyboard
    @objc func hideKeyboard(notification: Notification) {
        animateWithKeyboard(notification: notification) { _ in
            self.bottomConstraintOfCommentTextfieldView.constant = 0
        }
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        isBackBtnPressed = true
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - postBtnIsPressed
    @IBAction func postBtnIsPressed(_ sender: UIButton) {
        guard let comment = mentionTxtView.text else { return }
        if comment == DocumentDefaultValues.Empty.string {
            commentTextfield.resignFirstResponder()
            return
//            self.view.sainiShowToast(message: STATIC_LABELS.commentToast.rawValue)
        }
        else {
            var request = AddCommentRequest(postRef: postRef, comment: comment)
            
            if mentionTxtView.getCurrentMentions().count != 0 {
                var tagArr: [tagsRequest] = [tagsRequest]()
                for item in mentionTxtView.getCurrentMentions() {
                    let data = tagsRequest(id: item.id!, name: item.name, type: item.type ?? 1)
                    tagArr.append(data)
                }
                request.tags = tagArr
            }
            
            addCommentVM.addComment(request: request)
            mentionTxtView.updateTablview()
            mentionTxtView.text = DocumentDefaultValues.Empty.string
//            mentionTxtView.resignFirstResponder()
            constraintHeightMentionTxt.constant = 37
        }
    }
}

// MARK: - TableView DataSource and Delegate Methods
extension CommentListVC: UITableViewDelegate, UITableViewDataSource {
    // numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if commentListVM.commentList.value.isEmpty {// commentInfo.count == 0 {
                tableView.sainiSetEmptyMessage(STATIC_LABELS.noComments.rawValue)
                return 0
            }
            else {
                tableView.restore()
                tableView.separatorStyle = .none
                return commentListVM.commentList.value.count
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
            if commentListVM.commentList.value.count > 0 {
                cell.commentList = commentListVM.commentList.value[indexPath.row]
            }
            
            cell.viewMoreBtn.tag = indexPath.row
            cell.viewMoreBtn.addTarget(self, action: #selector(viewBtnIsPressed), for: .touchUpInside)
            cell.gotoProfileBtn.tag = indexPath.row
            cell.gotoProfileBtn.addTarget(self, action: #selector(gotoProfileBtnIsPressed), for: .touchUpInside)
            cell.gotoProfileBtn2.tag = indexPath.row
            cell.gotoProfileBtn2.addTarget(self, action: #selector(gotoProfileBtnIsPressed), for: .touchUpInside)
//            cell.gotoReplyBtn.tag = indexPath.row
//            cell.gotoReplyBtn.addTarget(self, action: #selector(addReplyBtnIsPressed), for: .touchUpInside)
            cell.likeBtn.tag = indexPath.row
            cell.likeBtn.addTarget(self, action: #selector(likeCommentBtnIsPressed), for: .touchUpInside)
            cell.threeDotsBtn.tag = indexPath.row
            cell.threeDotsBtn.addTarget(self, action: #selector(threeDotBtnIsPressed), for: .touchUpInside)
//            cell.addReplyBtn.tag = indexPath.row
//            cell.addReplyBtn.addTarget(self, action: #selector(addReplyBtnIsPressed), for: .touchUpInside)
            
            cell.goToLikeListBtn.tag = indexPath.row
            cell.goToLikeListBtn.addTarget(self, action: #selector(addLikeBtnIsPressed), for: .touchUpInside)
            
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.AddCommentCell.rawValue, for: indexPath) as? AddCommentCell else { return UITableViewCell() }
            cell.loadMoreViewOfReplies.isHidden = true // it should be hidden always because it is for comment list screen
            cell.loadMoreBtnView.isHidden = false
            cell.loadMoreBtn.setTitle(STATIC_LABELS.loadMoreBtnTitle.rawValue, for: .normal)
            cell.loadMoreBtn.addTarget(self, action: #selector(loadMoreBtnIsPressed), for: .touchUpInside)
            return cell
        }
    }
    
    //willDisplay
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Pagination
        if indexPath.row == commentListVM.commentList.value.count - 2 && hasMore {
            page = page + 1
            let request = CommentListRequest(postRef: postRef, page: page, commentType: .comment)
            commentListVM.fetchCommentListing(request: request)
        }
    }
    
    //MARK: - addLikeBtnIsPressed
    @objc func addLikeBtnIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.PostLikeVC.rawValue) as! PostLikeVC
        vc.ref = commentListVM.commentList.value[sender.tag].id
        vc.likeType = .COMMENT
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - viewBtnIsPressed
    @objc func viewBtnIsPressed(sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? CommentCell
        cell?.viewMoreBtn.isHidden = true
        cell?.heightConstraintOfViewMoreBtnView.constant = 0
        self.commentListVM.commentList.value[sender.tag].isTextExpanded = true
        cell?.commentTextLbl.numberOfLines = self.commentListVM.commentList.value[sender.tag].postTextLineCount
    }
    
    //MARK: - gotoProfileBtnIsPressed
    @objc func gotoProfileBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.currentUser?.id != commentListVM.commentList.value[sender.tag].addedBy.id {
            let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.OtherUserProfileVC.rawValue) as! OtherUserProfileVC
            vc.userId = commentListVM.commentList.value[sender.tag].addedBy.id
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    //MARK: - loadMoreBtnIsPressed
    @objc func loadMoreBtnIsPressed(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 1)) as? AddCommentCell
        cell?.loadMoreBtn.setTitle(STATIC_LABELS.loadingBtnTitle.rawValue, for: .normal)
        page = page + 1
        let request = CommentListRequest(postRef: postRef, page: page, commentType: .comment)
        commentListVM.fetchCommentListing(request: request)
    }
    
    //MARK: - likeCommentBtnIsPressed
    @objc func likeCommentBtnIsPressed(_ sender: UIButton) {
        let commentRef = commentListVM.commentList.value[sender.tag].id
        AppDelegate().sharedDelegate().vibrateOnTouch()
        let request = LikeCommentRequest(commentRef: commentRef, like: !commentListVM.commentList.value[sender.tag].isLike)
        likeCommentVM.likeComment(request: request)
    }
    
    //MARK: - addReplyBtnIsPressed
//    @objc func addReplyBtnIsPressed(_ sender: UIButton) {
//        let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.RepliesVC.rawValue) as! RepliesVC
//        vc.commentListVM.commentList = self.commentListVM.commentList
//        vc.postRef = postRef
//        vc.commentIndex = sender.tag
//        vc.userIsFrom = self.userIsFrom
//        vc.socialFeedVM = self.socialFeedVM
//        vc.profileInfoVM = self.profileInfoVM
//        vc.otherUserId = self.otherUserId
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    //MARK: - threeDotBtnIsPressed
    @objc func threeDotBtnIsPressed(_ sender: UIButton) {
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: STATIC_LABELS.cancel.rawValue, style: .cancel) { _ in
            log.result(STATIC_LABELS.cancel.rawValue)/
        }
        actionSheet.addAction(cancelButton)
        
        if AppModel.shared.currentUser?.id == commentListVM.commentList.value[sender.tag].addedBy.id {
            let removeComment = UIAlertAction(title: STATIC_LABELS.removeComment.rawValue, style: .default)
            { [weak self] _ in
                log.result(STATIC_LABELS.removeComment.rawValue)/
                guard let `self` = self else { return }
                self.deletedPostIndex = sender.tag
                let request = DeleteCommentRequest(commentRef: self.commentListVM.commentList.value[sender.tag].id)
                self.deleteCommentVM.deleteComment(request: request)
            }
            actionSheet.addAction(removeComment)
        }
        else {
            let reportComment = UIAlertAction(title: STATIC_LABELS.reportComment.rawValue, style: .default)
            { [weak self] _ in
                log.result(STATIC_LABELS.reportComment.rawValue)/
                guard let `self` = self else { return }
                let ref = self.commentListVM.commentList.value[sender.tag].id
                let request = ReportCommentRequest(commentRef: ref)
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


extension CommentListVC: EasyMentionDelegate {    
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

extension CommentListVC : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
//        textView.sizeToFit()
//        constraintHeightMentionTxt.constant = textView.contentSize.height
//        mentionTxtView.textContainer.heightTracksTextView = true
//        if constraintHeightMentionTxt.constant < 37 {
//            constraintHeightMentionTxt.constant = 37
//            textView.isScrollEnabled = false
//        }
//        else if constraintHeightMentionTxt.constant > 150 {
//            constraintHeightMentionTxt.constant = 150
//            textView.isScrollEnabled = true
//        }
//        self.view.layoutIfNeeded()
        
        
        // get the current height of your text from the content size
        var height = textView.contentSize.height

        // clamp your height to desired values
        if height > 150 {
            height = 150
        } else if height < 37 {
            height = 37
        }

        // update the constraint
        constraintHeightMentionTxt.constant = height
        self.view.layoutIfNeeded()
        
    }
}

extension CommentListVC {
    func animateWithKeyboard(
            notification: Notification,
            animations: ((_ keyboardFrame: CGRect) -> Void)?
        ) {
            // Extract the duration of the keyboard animation
            let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
            let duration = notification.userInfo![durationKey] as! Double
            
            // Extract the final frame of the keyboard
            let frameKey = UIResponder.keyboardFrameEndUserInfoKey
            let keyboardFrameValue = notification.userInfo![frameKey] as! NSValue
            
            // Extract the curve of the iOS keyboard animation
            let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
            let curveValue = notification.userInfo![curveKey] as! Int
            let curve = UIView.AnimationCurve(rawValue: curveValue)!

            // Create a property animator to manage the animation
            let animator = UIViewPropertyAnimator(
                duration: duration,
                curve: curve
            ) {
                // Perform the necessary animation layout updates
                animations?(keyboardFrameValue.cgRectValue)
                
                // Required to trigger NSLayoutConstraint changes
                // to animate
                self.view?.layoutIfNeeded()
            }
            
            // Start the animation
            animator.startAnimation()
        }
}
