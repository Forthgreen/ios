//
//  NotificationVC.swift
//  forthgreen
//
//  Created by MACBOOK on 08/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils

class NotificationVC: UIViewController {
    
    private var notificationVM: NotificationViewModel = NotificationViewModel()
    private let refreshControl = UIRefreshControl()
    private var notificationType: NOTIFICATION_TYPE = .comment
    
    var currentPage: Int = 1
    var hasMore: Bool = false
    
    // OUTLETS
    @IBOutlet var guestUserView: GuestUserView!
    @IBOutlet weak var bottomConstraintOfTableView: NSLayoutConstraint!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
//        if AppModel.shared.isGuestUser {
//            self.navigationController?.setNavigationBarHidden(true, animated: false)
//        }
//        else {
//            self.navigationController?.setNavigationBarHidden(false, animated: false)
//        }
//        if SCREEN.HEIGHT >= 812 {
//            bottomConstraintOfTableView.constant = 76
//        } else {
//            bottomConstraintOfTableView.constant = 56
//        }
        
    }
        
    //MARK: - configUI
    private func configUI() {
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.NotificationCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.NotificationCell.rawValue)
        
        if AppModel.shared.isGuestUser {
            if self.guestUserView == nil {
                self.guestUserView = GuestUserView.init()
            }
            displaySubViewtoParentView(self.view, subview: guestUserView)
            guestUserView.crossBtn.isHidden = true
            guestUserView.isHidden = false
        }
        else {
            guestUserView.isHidden = true
            shimmerView.isHidden = false
            shimmerView.isSkeletonable = true
            shimmerView.showAnimatedGradientSkeleton()
            notificationVM.fetchNotiList(page: currentPage)
        }
        
        notificationVM.hasMore.bind { [weak self](_) in
            guard let `self` = self else { return }
            self.hasMore = self.notificationVM.hasMore.value
        }
        
        notificationVM.listSuccess.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.notificationVM.listSuccess.value {
                self.refreshControl.endRefreshing()
                self.shimmerView.hideSkeleton()
                self.shimmerView.isHidden = true
            }
        }
        
        notificationVM.notificationList.bind { [weak self](_) in
            guard let `self` = self else { return }
            if !self.notificationVM.notificationList.value.isEmpty {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        addRefreshControl()
        UserDefaults.standard.set(false, forKey: USER_DEFAULT_KEYS.badgeCount.rawValue)
        NotificationCenter.default.post(name: NOTIFICATIONS.UpdateBadge, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNotificationList(noti:)), name: NOTIFICATIONS.UpdateBadge, object: nil)
    }
    
    //MARK: - refreshNotificationList
    @objc func refreshNotificationList(noti : Notification) {
        refreshData()
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
        notificationVM.notificationList.value.removeAll()
        
        hasMore = false
        refreshControl.endRefreshing()
        currentPage = 1
        
        notificationVM.fetchNotiList(page: currentPage)
    }
    
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notificationVM.notificationList.value.count == 0 {
            tableView.sainiSetEmptyMessage(STATIC_LABELS.noNotifications.rawValue)
        } else {
            tableView.restore()
            tableView.separatorStyle = .none
        }
        return notificationVM.notificationList.value.count
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.NotificationCell.rawValue, for: indexPath) as? NotificationCell else { return UITableViewCell() }
        if notificationVM.notificationList.value.count > 0 {
            cell.profileImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: AppImageUrl.average +  notificationVM.notificationList.value[indexPath.row].image)
            let name = notificationVM.notificationList.value[indexPath.row].name
            
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.19
             let nameS = NSMutableAttributedString(string: name, attributes:
                                                [NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBold.rawValue,
                                                                                     size: 14)!,
                                                 NSAttributedString.Key.foregroundColor: UIColor.black])
            nameS.append(NSAttributedString(string: notificationVM.notificationList.value[indexPath.row].message,
                                            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]))
            cell.commentTextLbl.attributedText = nameS
            cell.timeLbl.text = getDifferenceFromCurrentTimeInHourInDays(notificationVM.notificationList.value[indexPath.row].createdOn)
            if notificationVM.notificationList.value[indexPath.row].seen {
                cell.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            else {
                cell.view.backgroundColor = AppColors.paleGrey
            }
        }
        return cell
    }
    
    //willDisplay
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Pagination
        if indexPath.row == notificationVM.notificationList.value.count - 2 && hasMore {
            currentPage = currentPage + 1
            notificationVM.fetchNotiList(page: currentPage)
        }
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !notificationVM.notificationList.value[indexPath.row].seen {
            notificationVM.notificationList.value[indexPath.row].seen = true
            let request = NotificationSeenRequest(notificationId: notificationVM.notificationList.value[indexPath.row].id)
            notificationVM.notificationSeen(request: request)
        }
        notificationType = NOTIFICATION_TYPE(rawValue: notificationVM.notificationList.value[indexPath.row].refType) ?? .comment
        switch notificationType {
        case .comment:
            let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.PostDetailVC.rawValue) as! PostDetailVC
            vc.ref = notificationVM.notificationList.value[indexPath.row].id
            vc.refType = NOTIFICATION_TYPE(rawValue: notificationVM.notificationList.value[indexPath.row].refType) ?? .postLike
            vc.notificationVM = notificationVM
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .replyComment:
            let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.PostDetailVC.rawValue) as! PostDetailVC
            vc.ref = notificationVM.notificationList.value[indexPath.row].id
            vc.refType = NOTIFICATION_TYPE(rawValue: notificationVM.notificationList.value[indexPath.row].refType) ?? .postLike
            vc.notificationVM = notificationVM
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .postLike:
            let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.PostDetailVC.rawValue) as! PostDetailVC
            vc.ref = notificationVM.notificationList.value[indexPath.row].id
            vc.refType = NOTIFICATION_TYPE(rawValue: notificationVM.notificationList.value[indexPath.row].refType) ?? .postLike
            vc.notificationVM = notificationVM
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .commentLike:
            let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.PostDetailVC.rawValue) as! PostDetailVC
            vc.ref = notificationVM.notificationList.value[indexPath.row].id
            vc.refType = NOTIFICATION_TYPE(rawValue: notificationVM.notificationList.value[indexPath.row].refType) ?? .postLike
            vc.notificationVM = notificationVM
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .following:
            let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.OtherUserProfileVC.rawValue) as! OtherUserProfileVC
            vc.userId = notificationVM.notificationList.value[indexPath.row].ref
            self.navigationController?.pushViewController(vc, animated: true)
        case .replyLike:
            let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.PostDetailVC.rawValue) as! PostDetailVC
            vc.ref = notificationVM.notificationList.value[indexPath.row].id
            vc.refType = NOTIFICATION_TYPE(rawValue: notificationVM.notificationList.value[indexPath.row].refType) ?? .postLike
            vc.notificationVM = notificationVM
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
}
