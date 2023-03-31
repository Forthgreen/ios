//
//  LoginVC.swift
//  forthgreen
//
//  Created by MACBOOK on 02/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SainiUtils

protocol LoginVCDelegate {
    func redirectToForgotPassword()
}

class LoginVC: UIViewController {
    
    private var loginVM: LoginViewModel = LoginViewModel()
    
    @IBOutlet var bottomConstraintOfLoginBtn: NSLayoutConstraint!
    @IBOutlet weak var hideShowPwdBtn: UIButton!
    @IBOutlet weak var emailTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var delegate: LoginVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ConfigUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = .white
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
    }
    
    // MARK: - handleKeyboardShowNotification
    @objc private func handleKeyboardShowNotification(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            print(keyboardRectangle.height)
            bottomConstraintOfLoginBtn.constant = keyboardRectangle.height + 16
        }
    }
    
    //MARK: - hideKeyboard
    @objc func hideKeyboard(notification: Notification) {
        self.bottomConstraintOfLoginBtn.constant = 16
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        emailTextfield.sainiSetRightPadding(12)
        emailTextfield.sainiSetLeftPadding(12)
        passwordTextfield.sainiSetRightPadding(50)
        passwordTextfield.sainiSetLeftPadding(12)
        loginBtn.layer.cornerRadius = 3
        loginVM.delegate = self
        emailTextfield.titleFormatter = { $0 }
        passwordTextfield.titleFormatter = { $0 }
        emailTextfield.titleFont = UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!
        passwordTextfield.titleFont =  UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!
        
        updateLoginButton()
//        hideKeyboardWhenTappedAround()
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowNotification(keyboardShowNotification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - hideShowPasswordBtnIsPressed
    @IBAction func hideShowPasswordBtnIsPressed(_ sender: UIButton) {
        
        if hideShowPwdBtn.currentImage == UIImage(named: "ic_hide") {
            hideShowPwdBtn.setImage(UIImage.init(named: "ic_show"), for: UIControl.State.normal)
            passwordTextfield.isSecureTextEntry = false
        }
        else {
            hideShowPwdBtn.setImage(UIImage.init(named: "ic_hide"), for: UIControl.State.normal)
            passwordTextfield.isSecureTextEntry = true
        }
    }
    
    //MARK: - loginBtnIsPressed
    @IBAction func loginBtnIsPressed(_ sender: UIButton) {
        guard let email = emailTextfield.text else {
            emailTextfield.resignFirstResponder()
            self.view.sainiShowToast(message: "Email cannot be empty")
            return
        }
        guard let password = passwordTextfield.text else {
            emailTextfield.resignFirstResponder()
            passwordTextfield.resignFirstResponder()
            self.view.sainiShowToast(message: "Password cannot be empty")
            return
        }
        if email == DocumentDefaultValues.Empty.string {
            self.view.sainiShowToast(message: "Kindly enter your email")
        }
        else if !email.isValidEmail{
            self.view.sainiShowToast(message: "Please enter valid email")
        }
        else if password == DocumentDefaultValues.Empty.string {
            self.view.sainiShowToast(message: "Kindly enter your password")
        }
        else {
            let request = LoginRequest(email: email, password: password)
            emailTextfield.resignFirstResponder()
            passwordTextfield.resignFirstResponder()
            loginVM.API_OfLoginUser(loginRequest: request)
        }
    }
    
    //MARK: - forgotPasswordBtnIsPressed
    @IBAction func forgotPasswordBtnIsPressed(_ sender: UIButton) {
        delegate?.redirectToForgotPassword()
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    
}

//MARK: - LoginViewModelDelegate
extension LoginVC: LoginViewModelDelegate {
    func DidRecieveLoginResponse(loginResponse: LoginResponse?) {
        AppModel.shared.currentUser = loginResponse?.data?.user
        AppModel.shared.currentUser?.isSocialUser = false
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(AppModel.shared.currentUser) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "currentUser")
        }
        UserDefaults.standard.set(loginResponse?.data?.accessToken, forKey: "token")
        AppModel.shared.token = loginResponse?.data!.accessToken ?? ""
        AppModel.shared.isGuestUser = false
        AppModel.shared.showNabBarView = .Yes
        switch AppModel.shared.guestUserType{
        case .BrandListing:
            NotificationCenter.default.post(name: NOTIFICATIONS.Refresh, object: nil)
            self.navigationController?.popToRootViewController(animated: true)
            break
        case .BrandDetailFollow:
            NotificationCenter.default.post(name: NOTIFICATIONS.Refresh, object: nil)
            self.navigationController?.dismiss(animated: true, completion: nil)
            break
        case .ProductDetailReview:
            NotificationCenter.default.post(name: NOTIFICATIONS.Refresh, object: nil)
            self.navigationController?.dismiss(animated: true, completion: nil)
            break
        case .Setting:
            NotificationCenter.default.post(name: NOTIFICATIONS.Refresh, object: nil)
            self.navigationController?.dismiss(animated: true, completion: nil)
            break
        default:
            AppDelegate().sharedDelegate().navigateToDashboard()
            break
        }
    }
}

extension LoginVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateLoginButton()
    }
    
    func updateLoginButton() {
        if emailTextfield.text?.trimmed != "" && passwordTextfield.text?.trimmed != "" {
            loginBtn.backgroundColor = GreenColor
            loginBtn.setTitleColor(BlackColor, for: .normal)
            loginBtn.isUserInteractionEnabled = true
        }else{
            loginBtn.backgroundColor = PaleGrayColor
            loginBtn.setTitleColor(colorFromHex(hex: "#C1CBCF"), for: .normal)
            loginBtn.isUserInteractionEnabled = false
        }
    }
}
