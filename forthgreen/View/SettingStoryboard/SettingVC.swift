//
//  SettingVC.swift
//  forthgreen
//
//  Created by MACBOOK on 07/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils
import MessageUI

class SettingVC: UIViewController {
    
    private var settingVM: SettingViewModel = SettingViewModel()
    private var userDetailVM: UserDetailViewModel = UserDetailViewModel()
    private var logoutVM: LogoutViewModel = LogoutViewModel()
    private var alertVM: Alert = Alert()
    
    //OUTLETS
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delay(0.3) {
            self.renderProfileData()
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
                tabBar.setTabBarHidden(tabBarHidden: true)
            }
        }
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: - configUI
    private func configUI() {
        settingVM.delegate = self
        userDetailVM.delegate = self
        alertVM.delegate = self
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        
        logoutVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.logoutVM.success.value {
                self.logoutUser()
            }
        }
    }
    
    func logoutUser() {
        KeychainItem.deleteUserIdentifierFromKeychain()
        UserDefaults.standard.set("", forKey: "token")
        UserDefaults.standard.removeObject(forKey: "currentUser")
        AppModel.shared.guestUserType = .none
        AppModel.shared.token = ""
        let loginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginNavigation") as! UINavigationController
        UIApplication.shared.windows.first?.rootViewController = loginVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    //MARK: - renderProfileData
    func renderProfileData(){
        if AppModel.shared.isGuestUser{
            usernameLbl.text = "Guest"
            profileImage.image = #imageLiteral(resourceName: "ic_placeholder")
//            accountLbl.text = "Login / Sign up"
        }
        else{
//            accountLbl.text = "Account"
            if AppModel.shared.currentUser != nil {
                profileImage.downloadCachedImage(placeholder: "ic_placeholder", urlString: AppImageUrl.small + (AppModel.shared.currentUser?.image ?? DocumentDefaultValues.Empty.string))
                usernameLbl.text = (AppModel.shared.currentUser?.firstName ?? DocumentDefaultValues.Empty.string) //+  " " + (AppModel.shared.currentUser?.lastName ?? DocumentDefaultValues.Empty.string)
            }
        }
    }
    
    //MARK: - exitSideMenuBtnIsPressed
    @IBAction func exitSideMenuBtnIsPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - closeSideMentBtnIsPressed
    @IBAction func closeSideMentBtnIsPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - editProfileBtnIsPressed
    @IBAction func editProfileBtnIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.SETTING.instantiateViewController(withIdentifier: SETTING_STORYBOARD.EditProfileVC.rawValue) as! EditProfileVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK: - myCollectionBtnIsPressed
    @IBAction func myCollectionBtnIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.MY_BRAND.instantiateViewController(withIdentifier: MY_BRAND_STORYBOARD.MyBrandListVC.rawValue) as! MyBrandListVC
        vc.isFromSetting = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - contactUsBtnIsPressed
    @IBAction func contactUsBtnIsPressed(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["info@forthgreen.com"])
            mail.setSubject("Forthgreen query/suggestions")
            mail.setMessageBody("<b>Name: \(AppModel.shared.currentUser?.firstName ?? DocumentDefaultValues.Empty.string)<br/>", isHTML: true)
            self.present(mail, animated: true, completion: nil)
        } else {
            print("Cannot send mail")
            // give feedback to the user
        }
    }
    
    //MARK: - aboutUsBtnIsPressed
    @IBAction func aboutUsBtnIsPressed(_ sender: UIButton) {
        sainiOpenUrlInSafari(strUrl: STATIC_URLS.aboutUs.rawValue)
    }
    
    //MARK: - aboutUsBtnIsPressed
    @IBAction func leaveFeedbackBtnIsPressed(_ sender: UIButton) {
        sainiOpenUrlInSafari(strUrl: STATIC_URLS.leaveReview.rawValue)
    }
    

    //MARK: - termsNdConditionsBtnIsPressed
    @IBAction func termsNdConditionsBtnIsPressed(_ sender: UIButton) {
        sainiOpenUrlInSafari(strUrl: STATIC_URLS.termsAndConditions.rawValue)
    }
    
    //MARK: - privacyPolicyBtnIsPressed
    @IBAction func privacyPolicyBtnIsPressed(_ sender: UIButton) {
        sainiOpenUrlInSafari(strUrl: STATIC_URLS.privacyPolicy.rawValue)
    }
    
    //MARK: - logoutBtnIsPressed
    @IBAction func logoutBtnIsPressed(_ sender: UIButton) {
        alertVM.displayAlert(vc: self, alertTitle: "Logout", message: "Are you sure?", okBtnTitle: "Yes", cancelBtnTitle: "Cancel")
    }
    
    deinit{
        log.success("SettingVC deallocated successfully!")/
    }
    
}

//MARK:- SettingDelegate
extension SettingVC:SettingDelegate {
    func deleteAccount(isAccountDeleted: Bool) {
        if isAccountDeleted {
            self.logoutUser()
        }
    }
    
    func didReceivedSettingResponse(response: UpdateProfileResponse) {
        userDetailVM.fetchUserDetails()
    }
}

//MARK:- UserDetailDelegate
extension SettingVC:UserDetailDelegate{
    func didReceivedUserDetailResponse(response: UpdateProfileResponse) {
        AppModel.shared.currentUser = response.data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.renderProfileData()
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(response.data) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "currentUser")
        }
        AppDelegate().sharedDelegate().showErrorToast(message: "Profile Picture Updated successfully", true)
    }
}
//MARK:- AlertDelegate
extension SettingVC: AlertDelegate{
    func didClickOkBtn() {
        logoutVM.userLogout()
    }
    
    func didClickCancelBtn() {
        
    }
}

//MARK: - UpdateEditProfileDelegate
extension SettingVC:UpdateEditProfileDelegate{
    func didReceivedUpdatedEditProfileData() {
        renderProfileData()
    }
}

//MARK: - MFMailComposeViewControllerDelegate
extension SettingVC:MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Saved")
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
            AppDelegate().sharedDelegate().showErrorToast(message: "Feedback sent to admin successfully", true)
        case MFMailComposeResult.failed.rawValue:
            print("Error: \(String(describing: error?.localizedDescription))")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
