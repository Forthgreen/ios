//
//  FollowerListVC.swift
//  forthgreen
//
//  Created by MACBOOK on 09/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit

protocol FollowCountDelegate {
    func fetchFollowerCount(follower: Int, following: Int)
}

class FollowerListVC: UIViewController {
    
    private var followListVM: FollowerListViewModel = FollowerListViewModel()
    private var followUserVM: FollowUserViewModel = FollowUserViewModel()
    var userId: String = String()
    var username: String = String()
    private var listType: FOLLOW_LIST_TYPE = .follower
    private var followUserId: String = String()
    private var followedUserIndex: Int = Int()
    private var pageOfFollower: Int = Int()
    private var pageOfFollowing: Int = Int()
    private var hasMoreOfFollowing:Bool = false
    private var hasMoreOfFollower:Bool = false
    private let refreshControl = UIRefreshControl()
    var followCountDelegate: FollowCountDelegate?
    private var follower: Int = Int()
    private var following: Int = Int()

    // OUTLETS
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
        
        titleLbl.text = username
    }
    
    //MARK: - configUI
    private func configUI() {
        let attr = NSDictionary(object: UIFont(name: APP_FONT.buenosAiresBold.rawValue, size: 12.0)!, forKey: NSAttributedString.Key.font as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as? [NSAttributedString.Key : Any] , for: .normal)
        
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.UserInfoCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.UserInfoCell.rawValue)
        
        pageOfFollower = 1
        hasMoreOfFollower = false
        let followerRequest: FollowUserListRequest = FollowUserListRequest(userId: userId, isFollowing: false, listType: .follower, page: pageOfFollower)
        followListVM.fetchList(request: followerRequest)
        hasMoreOfFollowing = false
        pageOfFollowing = 1
        let followingRequest: FollowUserListRequest = FollowUserListRequest(userId: userId, isFollowing: true, listType: .following, page: pageOfFollowing)
        followListVM.fetchList(request: followingRequest)
        
        followListVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.followListVM.success.value {
                self.shimmerView.hideSkeleton()
                self.shimmerView.isHidden = true
  //              self.refreshControl.endRefreshing()
            }
        }
        
        followListVM.hasMoreOfFollower.bind { [weak self](_) in
            guard let `self` = self else { return }
            self.hasMoreOfFollower = self.followListVM.hasMoreOfFollower.value
        }
        
        followListVM.hasMoreOfFollowing.bind { [weak self](_) in
            guard let `self` = self else { return }
            self.hasMoreOfFollowing = self.followListVM.hasMoreOfFollowing.value
        }
        
        followListVM.followerList.bind { [weak self](_) in
            guard let `self` = self else { return }
            if !self.followListVM.followerList.value.isEmpty {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        followListVM.followingList.bind { [weak self](_) in
            guard let `self` = self else { return }
            if !self.followListVM.followingList.value.isEmpty {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        followUserVM.success.bind { [weak self] (_) in
            guard let `self` = self else { return }
            if self.followUserVM.success.value {
                switch self.listType {
                case .follower:
                    self.followListVM.followUser(userId: self.followUserId, followStatus: !self.followListVM.followerList.value[self.followedUserIndex].isFollow, listType: self.listType)
                    if self.followListVM.followerList.value[self.followedUserIndex].isFollow {
                        self.follower = self.followListVM.followerList.value.count + 1
                    }
                    else {
                        self.follower = self.followListVM.followerList.value.count - 1
                    }
                    self.follower = self.followListVM.followingList.value.count
                case .following:
                    self.followListVM.followUser(userId: self.followUserId, followStatus: !self.followListVM.followingList.value[self.followedUserIndex].isFollow, listType: self.listType)
                    if self.followListVM.followingList.value[self.followedUserIndex].isFollow {
                        self.following = self.followListVM.followingList.value.count + 1
                    }
                    else {
                        self.following = self.followListVM.followingList.value.count - 1
                    }
                    self.follower = self.followListVM.followerList.value.count
                }
                self.followCountDelegate?.fetchFollowerCount(follower: self.follower, following: self.following)
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
        self.refreshControl.endRefreshing()
        followListVM.followerList.value.removeAll()
        followListVM.followingList.value.removeAll()
        pageOfFollower = 1
        hasMoreOfFollower = false
        let followerRequest: FollowUserListRequest = FollowUserListRequest(userId: userId, isFollowing: false, listType: .follower, page: pageOfFollower)
        followListVM.fetchList(request: followerRequest)
        pageOfFollowing = 1
        hasMoreOfFollowing = false
        let followingRequest: FollowUserListRequest = FollowUserListRequest(userId: userId, isFollowing: true, listType: .following, page: pageOfFollowing)
        followListVM.fetchList(request: followingRequest)
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - segmentControllerIsPressed
    @IBAction func segmentControllerIsPressed(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            log.info(STATIC_LABELS.followBtnTitle.rawValue)/
            listType = .follower
            segmentControl.selectedSegmentIndex = 0
        case 1:
            log.info(STATIC_LABELS.followingBtnTitle.rawValue)/
            listType = .following
            segmentControl.selectedSegmentIndex = 1
        default:
            break
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

//MARK: - TableView DataSource and Delegate Methods
extension FollowerListVC: UITableViewDataSource, UITableViewDelegate {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch listType {
        case .follower:
//            if followListVM.followerList.value.count == 0 {
//                tableView.sainiSetEmptyMessage(STATIC_LABELS.noDataFound.rawValue)
//            } else {
//                tableView.restore()
//                tableView.separatorStyle = .none
//            }
            return followListVM.followerList.value.count
        case .following:
//            if followListVM.followingList.value.count == 0 {
//                tableView.sainiSetEmptyMessage(STATIC_LABELS.noDataFound.rawValue)
//            } else {
//                tableView.restore()
//                tableView.separatorStyle = .none
//            }
            return followListVM.followingList.value.count
        }
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.UserInfoCell.rawValue, for: indexPath) as? UserInfoCell else { return UITableViewCell() }
        switch listType {
        case .follower:
            if followListVM.followerList.value.isEmpty {
                return UITableViewCell()
            }
            cell.nameLbl.text = "\(followListVM.followerList.value[indexPath.row].firstName)" //" \(followListVM.followerList.value[indexPath.row].lastName)"
            
            cell.profileImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: AppImageUrl.small + followListVM.followerList.value[indexPath.row].image)
            if followListVM.followerList.value[indexPath.row].bio == DocumentDefaultValues.Empty.string {
                cell.bioLbl.isHidden = true
                cell.bioView.isHidden = true
            }
            else {
                cell.bioView.isHidden = false
                cell.bioLbl.isHidden = false
                cell.bioLbl.text = followListVM.followerList.value[indexPath.row].bio
            }
            if followListVM.followerList.value[indexPath.row].username == DocumentDefaultValues.Empty.string {
                cell.userNameLbl.isHidden = true
            }
            else {
                cell.userNameLbl.isHidden = false
                cell.userNameLbl.text = STATIC_LABELS.atTheRate.rawValue +  "\(followListVM.followerList.value[indexPath.row].username)"
            }
            
            if followListVM.followerList.value[indexPath.row].isFollow {
                cell.followBtn.setTitle(STATIC_LABELS.followingBtnTitle.rawValue, for: .normal)
                cell.followBtn.backgroundColor = AppColors.paleGrey
            }
            else {
                cell.followBtn.setTitle(STATIC_LABELS.followBtnTitle.rawValue, for: .normal)
                cell.followBtn.backgroundColor = AppColors.turqoiseGreen
            }
            if AppModel.shared.currentUser?.id != followListVM.followerList.value[indexPath.row].id {
                cell.followBtn.isHidden = false
            } else {
                cell.followBtn.isHidden = true
            }
            
        case .following:
            
            if followListVM.followingList.value.isEmpty {
                return UITableViewCell()
            }
            cell.nameLbl.text = "\(followListVM.followingList.value[indexPath.row].firstName)" //" \(followListVM.followingList.value[indexPath.row].lastName)"
            
            cell.profileImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: AppImageUrl.small + followListVM.followingList.value[indexPath.row].image)
            if followListVM.followingList.value[indexPath.row].bio == DocumentDefaultValues.Empty.string {
                cell.bioLbl.isHidden = true
            }
            else {
                cell.bioLbl.isHidden = false
                cell.bioLbl.text = followListVM.followingList.value[indexPath.row].bio
            }
            if followListVM.followingList.value[indexPath.row].username == DocumentDefaultValues.Empty.string {
                cell.userNameLbl.isHidden = true
            }
            else {
                cell.userNameLbl.isHidden = false
                cell.userNameLbl.text = STATIC_LABELS.atTheRate.rawValue +  "\(followListVM.followingList.value[indexPath.row].username)"
            }
            
            if followListVM.followingList.value[indexPath.row].isFollow {
                cell.followBtn.setTitle(STATIC_LABELS.followingBtnTitle.rawValue, for: .normal)
                cell.followBtn.backgroundColor = AppColors.paleGrey
            }
            else {
                cell.followBtn.setTitle(STATIC_LABELS.followBtnTitle.rawValue, for: .normal)
                cell.followBtn.backgroundColor = AppColors.turqoiseGreen
            }
            if AppModel.shared.currentUser?.id != followListVM.followingList.value[indexPath.row].id {
                cell.followBtn.isHidden = false
            } else {
                cell.followBtn.isHidden = true
            }
        }
        cell.otherUserProfileBtn.tag = indexPath.row
        cell.otherUserProfileBtn.addTarget(self, action: #selector(gotoOtherUserProfileBtnIsPressed), for: .touchUpInside)
        cell.followBtn.tag = indexPath.row
        cell.followBtn.addTarget(self, action: #selector(followBtnIsPressed), for: .touchUpInside)
        return cell
    }
    
    //willDisplay
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Pagination
        switch listType {
        case .follower:
            if indexPath.row == followListVM.followerList.value.count - 1 && hasMoreOfFollower == true{
                pageOfFollower += 1
                let followerRequest: FollowUserListRequest = FollowUserListRequest(userId: userId, isFollowing: false, listType: .follower, page: pageOfFollower)
                followListVM.fetchList(request: followerRequest)
            }
        case .following:
            if indexPath.row == followListVM.followerList.value.count - 1 && hasMoreOfFollowing == true{
                pageOfFollowing += 1
                let followingRequest: FollowUserListRequest = FollowUserListRequest(userId: userId, isFollowing: true, listType: .following, page: pageOfFollowing)
                followListVM.fetchList(request: followingRequest)
            }
        }
    }
    
    //MARK: - followBtnIsPressed
    @objc func followBtnIsPressed(_ sender: UIButton) {
        followedUserIndex = sender.tag
        switch listType {
        case .follower:
            followUserId = followListVM.followerList.value[sender.tag].id
            let request = FollowUserRequest(followingRef: followUserId, follow: !followListVM.followerList.value[sender.tag].isFollow)
            followUserVM.followUser(request: request)
        case .following:
            followUserId = followListVM.followingList.value[sender.tag].id
            let request = FollowUserRequest(followingRef: followUserId, follow: !followListVM.followingList.value[sender.tag].isFollow)
            followUserVM.followUser(request: request)
        }
    }
    
    //MARK: - gotoOtherUserProfileBtnIsPressed
    @objc func gotoOtherUserProfileBtnIsPressed(_ sender: UIButton) {
        switch listType {
        case .follower:
            if AppModel.shared.currentUser?.id != followListVM.followerList.value[sender.tag].id {
                let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.OtherUserProfileVC.rawValue) as! OtherUserProfileVC
                vc.userId = followListVM.followerList.value[sender.tag].id
                vc.followDelegate = self
                self.navigationController?.pushViewController(vc, animated: false)
            }
        case .following:
            if AppModel.shared.currentUser?.id != followListVM.followingList.value[sender.tag].id {
                let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.OtherUserProfileVC.rawValue) as! OtherUserProfileVC
                vc.userId = followListVM.followingList.value[sender.tag].id
                vc.followDelegate = self
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
}

//MARK: - didPressFollowBtnDelegate
extension FollowerListVC: didPressFollowBtnDelegate {
    func didRecieveFollowAction(userId: String, isFollow: Bool) {
        switch listType {
        case .follower:
            for index in 0..<followListVM.followerList.value.count where followListVM.followerList.value[index].id == userId {
                followListVM.followerList.value[index].isFollow = isFollow
                if isFollow {
                    follower = followListVM.followerList.value.count + 1
                }
                else {
                    follower = followListVM.followerList.value.count - 1
                }
                following = followListVM.followingList.value.count
            }
        case .following:
            for index in 0..<followListVM.followingList.value.count where followListVM.followingList.value[index].id == userId {
                followListVM.followingList.value[index].isFollow = isFollow
                if isFollow {
                    following = followListVM.followingList.value.count + 1
                }
                else {
                    following = followListVM.followingList.value.count - 1
                }
            }
            follower = followListVM.followerList.value.count
        }
        followCountDelegate?.fetchFollowerCount(follower: follower, following: following)
    }
}
