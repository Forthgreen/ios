//
//  PostLikeVC.swift
//  forthgreen
//
//  Created by iMac on 7/22/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import SkeletonView

class PostLikeVC: UIViewController {

    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    private var PostListListVM: PostListListViewModel = PostListListViewModel()
    private var followUserVM: FollowUserViewModel = FollowUserViewModel()
    private let refreshControl = UIRefreshControl()
    private var followedUserIndex: Int = Int()
    private var followedUserPostId: String = String()
    private var userId: String = String()
    private var isBackBtnPressed: Bool = false
    private var page: Int = Int()
    private var hasMore:Bool = false
    var userIsFrom: USER_IS_FROM = .postDetail
    var ref: String = String()
    var likeType: LIKE_TYPE = .POST
    
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    //MARK: - configUI
    private func configUI() {
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()

        tblView.register(UINib(nibName: TABLE_VIEW_CELL.UserInfoCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.UserInfoCell.rawValue)
          
        if let user = AppModel.shared.currentUser {
            userId = user.id
        }
        
        page = 1
        hasMore = false
        PostListListVM.likePost(request: LikeListRequest(ref: ref, likeType: likeType.rawValue, page: page))
        addRefreshControl()
        PostListListVM.success.bind { [weak self] (_) in
            guard let `self` = self else { return }
            if self.PostListListVM.success.value {
                self.refreshControl.endRefreshing()
                self.shimmerView.hideSkeleton()
                self.shimmerView.isHidden = true
            }
        }
        
        PostListListVM.hasMore.bind { [weak self](_) in
            guard let `self` = self else { return }
            self.hasMore = self.PostListListVM.hasMore.value
        }
        
        PostListListVM.likeList.bind { [weak self](_) in
            guard let `self` = self else { return }
            
            if !self.PostListListVM.likeList.value.isEmpty {
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
        
        followUserVM.success.bind { [weak self] (_) in
            guard let `self` = self else { return }
            if self.followUserVM.success.value {
                self.PostListListVM.followUser(userId: self.followedUserPostId, followStatus: !self.PostListListVM.likeList.value[self.followedUserIndex].isFollowing)
            }
        }
        
    }
    
    //MARK: - addRefreshControl
    private func addRefreshControl() {
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tblView.refreshControl = refreshControl
        } else {
            tblView.addSubview(refreshControl)
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
        PostListListVM.likeList.value.removeAll()
        page = 1
        hasMore = false
        PostListListVM.likePost(request: LikeListRequest(ref: ref, likeType: likeType.rawValue, page: page))
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        isBackBtnPressed = true
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK: - TableView DataSource and Delegate Methods
extension PostLikeVC: UITableViewDelegate, UITableViewDataSource {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if PostListListVM.likeList.value.isEmpty {
            tableView.sainiSetEmptyMessage(STATIC_LABELS.noLikes.rawValue)
        } else {
            tableView.restore()
            tableView.separatorStyle = .none
        }
        return PostListListVM.likeList.value.count
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
        if PostListListVM.likeList.value.isEmpty {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.UserInfoCell.rawValue, for: indexPath) as? UserInfoCell else { return UITableViewCell() }
        cell.nameLbl.text = PostListListVM.likeList.value[indexPath.row].firstName
        cell.profileImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: AppImageUrl.small + PostListListVM.likeList.value[indexPath.row].image)
        cell.bioLbl.isHidden = true
        cell.bioView.isHidden = true
        cell.userNameLbl.isHidden = true
        if PostListListVM.likeList.value[indexPath.row].isFollowing {
            cell.followBtn.setTitle(STATIC_LABELS.followingBtnTitle.rawValue, for: .normal)
            cell.followBtn.backgroundColor = AppColors.paleGrey
        }
        else {
            cell.followBtn.setTitle(STATIC_LABELS.followBtnTitle.rawValue, for: .normal)
            cell.followBtn.backgroundColor = AppColors.turqoiseGreen
        }
        
        if userId == PostListListVM.likeList.value[indexPath.row].id || PostListListVM.likeList.value[indexPath.row].dummyUser {
            cell.followBtn.isHidden = true
        } else {
            cell.followBtn.isHidden = false
        }
        
        cell.otherUserProfileBtn.tag = indexPath.row
        cell.otherUserProfileBtn.addTarget(self, action: #selector(goToOtherUserProfileBtnIsPressed), for: .touchUpInside)
        cell.followBtn.tag = indexPath.row
        cell.followBtn.addTarget(self, action: #selector(followUserBtnIsPressed), for: .touchUpInside)
        return cell
    }
    
    //willDisplay
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Pagination
        if indexPath.row == PostListListVM.likeList.value.count - 2 && hasMore {
            page = page + 1
            PostListListVM.likePost(request: LikeListRequest(ref: ref, likeType: likeType.rawValue, page: page))
        }
    }
    
    //MARK: - followUserBtnIsPressed
    @objc func followUserBtnIsPressed(sender: UIButton) {
        followedUserIndex = sender.tag
        followedUserPostId = PostListListVM.likeList.value[sender.tag].id
        let request = FollowUserRequest(followingRef: followedUserPostId, follow: !PostListListVM.likeList.value[sender.tag].isFollowing)
        followUserVM.followUser(request: request)
    }
    
    //MARK: - goToOtherUserProfileBtnIsPressed
    @objc func goToOtherUserProfileBtnIsPressed(_ sender: UIButton) {
        if userId != PostListListVM.likeList.value[sender.tag].id {
            let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.OtherUserProfileVC.rawValue) as! OtherUserProfileVC
            vc.userId = PostListListVM.likeList.value[sender.tag].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
