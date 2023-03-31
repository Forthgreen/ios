//
//  SearchPostVC.swift
//  forthgreen
//
//  Created by MACBOOK on 09/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import Contacts

class SearchPostVC: UIViewController {
    
    private var followUserVM: FollowUserViewModel = FollowUserViewModel()
    private var searchUserVM: SearchUserViewModel = SearchUserViewModel()
    private var followedUserIndex: Int = Int()
    private var followedUserPostId: String = String()
    private var workItemReferance: DispatchWorkItem?
    private var page: Int = Int()
    private var hasMore: Bool = false
    private var searchedText: String = String()
    
    //OUTLETS
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var viewInviteContacts: UIView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    private var alertVM: Alert = Alert()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        tabBar.setTabBarHidden(tabBarHidden: true)
    }
    
    override func viewWillLayoutSubviews() {
        self.tableView.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableViewHeight.constant = self.tableView.contentSize.height
        }
    }
    
    //MARK: - configUI
    private func configUI() {
        alertVM.delegate = self
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        
        searchView.sainiCornerRadius(radius: 8)
       // searchView.layer.borderWidth = 1
   //     searchView.layer.borderColor = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1)
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.UserInfoCell.rawValue, bundle: nil),
                           forCellReuseIdentifier: TABLE_VIEW_CELL.UserInfoCell.rawValue)
        
        searchTextfield.delegate = self
        page = 1
        hasMore = false
        let request = SearchUserRequest(text: searchedText, page: page)
        searchUserVM.userSearch(request: request)
        
        searchUserVM.success.bind { [weak self] (_) in
            guard let `self` = self else { return }
            if self.searchUserVM.success.value {
                self.shimmerView.hideSkeleton()
                self.shimmerView.isHidden = true
                self.searchTextfield.resignFirstResponder()
            }
        }
        
        searchUserVM.hasMore.bind { [weak self] (_) in
            guard let `self` = self else { return }
            self.hasMore = self.searchUserVM.hasMore.value
        }
        
        searchUserVM.userList.bind { [weak self](_) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.layoutIfNeeded()
                
            }
        }
        
        followUserVM.success.bind { [weak self] (_) in
            guard let `self` = self else { return }
            if self.followUserVM.success.value {
                self.searchUserVM.followUser(userId: self.followedUserPostId, followStatus: !self.searchUserVM.userList.value[self.followedUserIndex].isFollow)
            }
        }
    }
    
    @IBAction func btnInviteFriends(_ sender: UIButton) {
        self.requestAccess(completionHandler: { accessGranted in
            if accessGranted {
                DispatchQueue.main.async {
                    let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.InviteUsersVC.rawValue) as! InviteUsersVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        })
    }
    
    
    //MARK: - cancelBtnIsPressed
    @IBAction func cancelBtnIsPressed(_ sender: UIButton) {
        self.searchUserVM.userList.value.removeAll()
        self.searchTextfield.text = ""
        self.searchTextfield.resignFirstResponder()
        self.btnCancel.isHidden = true
        self.viewInviteContacts.isHidden = false
        page = 1
        hasMore = false
        self.searchedText = ""
        let request = SearchUserRequest(text: searchedText, page: page)
        searchUserVM.userSearch(request: request)
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            showSettingsAlert(completionHandler)
        case .restricted, .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert(completionHandler)
                    }
                }
            }
        @unknown default:
            showSettingsAlert(completionHandler)
        }
    }

    private func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        
        alertVM.displayAlert(vc: self, alertTitle: "",
                             message: "This app requires access to Contacts to proceed. Go to Settings to grant access.",
                             okBtnTitle: "Open Settings",
                             cancelBtnTitle: "Cancel")
        
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        if
            let settings = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settings) {
                alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
                    completionHandler(false)
                    UIApplication.shared.open(settings)
                })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        })
        present(alert, animated: true)
    }
    
}

//MARK: - UITextFieldDelegate
extension SearchPostVC: UITextFieldDelegate {
    // shouldChangeCharactersIn
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if updatedText != DocumentDefaultValues.Empty.string {
                workItemReferance?.cancel()
                let workItem = DispatchWorkItem {
                    self.shimmerView.isHidden = false
                    self.shimmerView.isSkeletonable = true
                    self.shimmerView.showAnimatedGradientSkeleton()
                    self.searchUserVM.userList.value.removeAll()
                    self.searchedText = updatedText
                    self.page = 1
                    let request = SearchUserRequest(text: self.searchedText, page: self.page)
                    self.searchUserVM.userSearch(request: request)
                }
                workItemReferance = workItem
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1),execute: workItem)
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            DispatchQueue.main.async {
                self.searchUserVM.userList.value.removeAll()
                self.tableView.reloadData()
                self.viewInviteContacts.isHidden = true
                
            }
        }
        self.btnCancel.isHidden = false
        
    }
    
   
}

//MARK: - TableView DataSource and Delegate Methods
extension SearchPostVC: UITableViewDataSource, UITableViewDelegate {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchUserVM.userList.value.count == 0 {
            tableView.sainiSetEmptyMessage("")
        } else {
            tableView.restore()
            tableView.separatorStyle = .none
        }
        return searchUserVM.userList.value.count
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
        cell.otherUserProfileBtn.isHidden = true
        cell.nameLbl.text = "\(searchUserVM.userList.value[indexPath.row].firstName)" //" \(searchUserVM.userList.value[indexPath.row].lastName)"
        cell.profileImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: AppImageUrl.small + searchUserVM.userList.value[indexPath.row].image)
        if searchUserVM.userList.value[indexPath.row].bio == DocumentDefaultValues.Empty.string {
            cell.bioLbl.isHidden = true
            cell.bioView.isHidden = true
        }
        else {
            cell.bioLbl.isHidden = false
            cell.bioView.isHidden = false
            cell.bioLbl.text = searchUserVM.userList.value[indexPath.row].bio
        }
        
        cell.userNameLbl.isHidden = true
        
        if searchUserVM.userList.value[indexPath.row].dummyUser {
            cell.followBtn.isHidden = true
        }
        else {
            cell.followBtn.isHidden = false
            if searchUserVM.userList.value[indexPath.row].isFollow {
                cell.followBtn.setTitle(STATIC_LABELS.followingBtnTitle.rawValue, for: .normal)
                cell.followBtn.backgroundColor = AppColors.paleGrey
            }
            else {
                cell.followBtn.setTitle(STATIC_LABELS.followBtnTitle.rawValue, for: .normal)
                cell.followBtn.backgroundColor = AppColors.turqoiseGreen
            }
        }
        
        cell.followBtn.tag = indexPath.row
        cell.followBtn.addTarget(self, action: #selector(followUserBtnIsPressed), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchUserVM.userList.value.isEmpty == true || self.searchedText.isEmpty == false ? 0 : 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Suggested users
        let view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 108, height: 23)
        view.backgroundColor = .white

        view.textColor = UIColor(red: 0.243, green: 0.294, blue: 0.302, alpha: 1)
        view.font = UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 14)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.37
        view.attributedText = NSMutableAttributedString(string: "Suggested users",
                                                        attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        let parent = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        parent.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        view.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: 18).isActive = true
        view.widthAnchor.constraint(equalToConstant: 108).isActive = true
        view.heightAnchor.constraint(equalToConstant: 23).isActive = true
        return parent
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.OtherUserProfileVC.rawValue) as! OtherUserProfileVC
        vc.userId = searchUserVM.userList.value[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //willDisplay
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Pagination
        if self.searchedText.isEmpty == false {
            if indexPath.row == searchUserVM.userList.value.count - 2 && hasMore {
                page = page + 1
                let request = SearchUserRequest(text: searchedText, page: page)
                searchUserVM.userSearch(request: request)
            }
        }
        self.viewWillLayoutSubviews()
    }
    
    //MARK: - followUserBtnIsPressed
    @objc func followUserBtnIsPressed(sender: UIButton) {
        followedUserIndex = sender.tag
        followedUserPostId = searchUserVM.userList.value[sender.tag].id
        let request = FollowUserRequest(followingRef: followedUserPostId, follow: !searchUserVM.userList.value[sender.tag].isFollow)
        followUserVM.followUser(request: request)
    }
}

extension SearchPostVC: AlertDelegate {
    
    func didClickOkBtn() {
        if let settings = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(settings) {
            UIApplication.shared.open(settings)
        }
    }
    
    func didClickCancelBtn() {
        
    }
    
    
}
