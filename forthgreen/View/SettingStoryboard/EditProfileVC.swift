//
//  EditProfileVC.swift
//  forthgreen
//
//  Created by MACBOOK on 07/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift

protocol UpdateEditProfileDelegate {
    func didReceivedUpdatedEditProfileData()
}

class EditProfileVC: UploadImageVC {
    
    private var editProfileVM: EditProfileViewModel = EditProfileViewModel()
    private var userDetailVM: UserDetailViewModel = UserDetailViewModel()
    var delegate: UpdateEditProfileDelegate?
    private var heightOfTextView = CGFloat()
    private var imageData: Data = Data()
    private var settingVM: SettingViewModel = SettingViewModel()
    
    // OUTLETS
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet var bottomConstraintOfUpdateBtn: NSLayoutConstraint!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var heightConstraintOfBioView: NSLayoutConstraint!
    @IBOutlet weak var topConstraintOfBioLbl: NSLayoutConstraint!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var bioLineView: UIView!
    @IBOutlet weak var emailTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var userNameTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var firstNameTxt: SkyFloatingLabelTextField!
    
    private var alertVM: Alert = Alert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        alertVM.delegate = self
        settingVM.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
//        self.navigationController?.navigationBar.titleTextAttributes =
//            [NSAttributedString.Key.foregroundColor: AppColors.charcol,
//             NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBold.rawValue, size: 18)!]
        if let tabBar : CustomTabBarController = self.tabBarController as? CustomTabBarController{
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
        
//        self.navigationController?.navigationBar.isTranslucent = false
//        IQKeyboardManager.shared.enableAutoToolbar = false
//        IQKeyboardManager.shared.enable = false
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.isHidden = true
        
//        IQKeyboardManager.shared.enableAutoToolbar = true
//        IQKeyboardManager.shared.enable = true
    }
    
    // MARK: - handleKeyboardShowNotification
    @objc private func handleKeyboardShowNotification(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            print(keyboardRectangle.height)
            bottomConstraintOfUpdateBtn.constant = keyboardRectangle.height + 16
        }
    }
    
    //MARK: - hideKeyboard
    @objc func hideKeyboard(notification: Notification) {
        self.bottomConstraintOfUpdateBtn.constant = 16
    }

    //MARK: - configUI
    private func configUI() {
        profileImage.sainiCornerRadius(radius: profileImage.frame.height / 2)
        firstNameTxt.titleFormatter = { $0 }
        userNameTxt.titleFormatter = { $0 }
        //        bioTxt.titleFormatter = { $0 }
        emailTxt.titleFormatter = { $0 }
        firstNameTxt.titleFont = UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!
        userNameTxt.titleFont =  UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!
        //        bioTxt.titleFont =  UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!
        emailTxt.titleFont =  UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!
        bioTextView.delegate = self
        editProfileVM.delegate = self
        userDetailVM.delegate = self
        updateBtn.layer.cornerRadius = 5
        renderProfileData()
        
        if let isSocialUser = AppModel.shared.currentUser?.isSocialUser {
            passwordView.isHidden = isSocialUser
        }
    }
    
    //MARK: - renderProfileData
    private func renderProfileData(){
        if let currentUser = AppModel.shared.currentUser {
            profileImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: AppImageUrl.average + currentUser.image)
            firstNameTxt.text = currentUser.firstName
            userNameTxt.text = currentUser.username
            emailTxt.text = currentUser.email
            bioTextView.text = currentUser.bio
        }
        heightOfTextView = (bioTextView.text.height(withConstrainedWidth: bioTextView.frame.width, font: UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 14)!))
        heightConstraintOfBioView.constant = 39 +  CGFloat(heightOfTextView)
        
        updateBtn.backgroundColor = PaleGrayColor
        updateBtn.setTitleColor(colorFromHex(hex: "#C1CBCF"), for: .normal)
        updateBtn.isUserInteractionEnabled = false
    }
    
    //MARK: - backBTnIsPREssed
    @IBAction func backBtnIsPRessed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: - updateImageBtnIsPressed
    @IBAction func updateImageBtnIsPressed(_ sender: UIButton) {
        self.uploadImage()
    }
    
    //MARK: - selectedImage
    override func selectedImage(choosenImage: UIImage) {
        profileImage.image = choosenImage
        imageData = compressImage(image: choosenImage)
    }
    
    //MARK: - changeBtnISPressed
    @IBAction func changeBtnIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func deleteAccountPressed(_ sender: UIButton) {
        alertVM.displayAlert(vc: self, alertTitle: "", message: "Do you want to delete your account permanently?", okBtnTitle: "Yes, delete", cancelBtnTitle: "Cancel")
    }
    
    
    //MARK: - updateBtnIsPressed
    @IBAction func updateBtnIsPRessed(_ sender: UIButton) {
        guard let firstName = firstNameTxt.text?.trimmed else{return}
        guard let username = userNameTxt.text?.trimmed else { return }
        guard let bio = bioTextView.text?.trimmed else { return }
        
//        if profileImage.image == UIImage(named: GLOBAL_IMAGES.placeholderForProfile.rawValue) {
//            self.view.sainiShowToast(message: STATIC_LABELS.imageToast.rawValue)
//        }
        if firstName == DocumentDefaultValues.Empty.string{
            firstNameTxt.resignFirstResponder()
            self.view.sainiShowToast(message: STATIC_LABELS.nameToast.rawValue)
        }
        else if username == DocumentDefaultValues.Empty.string{
            firstNameTxt.resignFirstResponder()
            userNameTxt.resignFirstResponder()
            self.view.sainiShowToast(message: STATIC_LABELS.usernameToast.rawValue)
        }
//        else if bio == DocumentDefaultValues.Empty.string {
//            firstNameTxt.resignFirstResponder()
//            userNameTxt.resignFirstResponder()
//            bioTextView.resignFirstResponder()
//            self.view.sainiShowToast(message: STATIC_LABELS.bioToast.rawValue)
//        }
        else{
            firstNameTxt.resignFirstResponder()
            userNameTxt.resignFirstResponder()
            bioTextView.resignFirstResponder()
            let request = UpdateProfileRequest(oldPassword: "", newPassword: "", firstName: firstName,bio: bio, username: username)
            editProfileVM.updateProfile(request: request, imageData: imageData)
        }
        
    }
    
}

//MARK:- SettingDelegate
extension EditProfileVC: SettingDelegate{
    
    func deleteAccount(isAccountDeleted: Bool) {
        self.logoutUser()
    }
    
    func didReceivedSettingResponse(response: UpdateProfileResponse) {
        userDetailVM.fetchUserDetails()
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
}

//MARK:- UserDetailDelegate
extension EditProfileVC:UserDetailDelegate{
    func didReceivedUserDetailResponse(response: UpdateProfileResponse) {
        AppModel.shared.currentUser = response.data
        renderProfileData()
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(response.data) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: USER_DEFAULT_KEYS.currentUser.rawValue)
        }
        delegate?.didReceivedUpdatedEditProfileData()
        NotificationCenter.default.post(name: NOTIFICATIONS.ProfileRefresh, object: nil)
        AppDelegate().sharedDelegate().showErrorToast(message: STATIC_LABELS.profileUpdated.rawValue, true)
        self.navigationController?.popViewController(animated: false)
    }
}

//MARK: - UITextViewDelegate
extension EditProfileVC: UITextViewDelegate, UITextFieldDelegate {
    // textViewDidBeginEditing
    //    func textViewDidBeginEditing(_ textView: UITextView) {
    //        if textView.text.count > 0 {
    //            topConstraintOfBioLbl.constant = 0
    //        }
    //    }
    
    // shouldChangeTextIn
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count > 150 {
            bioTextView.resignFirstResponder()
            self.view.sainiShowToast(message: STATIC_LABELS.bioLimitToast.rawValue)
        }
        heightOfTextView = (bioTextView.text.height(withConstrainedWidth: textView.frame.width, font: UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 14)!))
        heightConstraintOfBioView.constant = 50 +  CGFloat(heightOfTextView)
        return newText.count <= 150
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        bioLineView.backgroundColor = GreenColor
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        bioLineView.backgroundColor = NavigationBorderColor
        updateUpdateButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateUpdateButton()
    }
    
    func updateUpdateButton() {
        if firstNameTxt.text?.trimmed != "" && userNameTxt.text?.trimmed != "" && bioTextView.text?.trimmed != "" {
            updateBtn.backgroundColor = GreenColor
            updateBtn.setTitleColor(BlackColor, for: .normal)
            updateBtn.isUserInteractionEnabled = true
        }else{
            updateBtn.backgroundColor = PaleGrayColor
            updateBtn.setTitleColor(colorFromHex(hex: "#C1CBCF"), for: .normal)
            updateBtn.isUserInteractionEnabled = false
        }
    }
}

//MARK:- AlertDelegate
extension EditProfileVC: AlertDelegate{
    func didClickOkBtn() {
        settingVM.deleteProfile()
    }
    
    func didClickCancelBtn() {
        
    }
}
