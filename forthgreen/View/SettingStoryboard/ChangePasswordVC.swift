//
//  ChangePasswordVC.swift
//  forthgreen
//
//  Created by MACBOOK on 07/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift

class ChangePasswordVC: UIViewController {
    
    private var passVM: ChangePasswordViewModel = ChangePasswordViewModel()

    @IBOutlet var bottomConstraintOfChangeBtn: NSLayoutConstraint!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var confirmPassTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var newPassTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var currentPassTxt: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        if let tabBar : CustomTabBarController = self.tabBarController as? CustomTabBarController{
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
        
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
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        currentPassTxt.titleFormatter = { $0 }
        newPassTxt.titleFormatter = { $0 }
        confirmPassTxt.titleFormatter = { $0 }
        currentPassTxt.titleFont = UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!
        newPassTxt.titleFont = UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!
        confirmPassTxt.titleFont =  UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!
        passVM.delegate = self
        changeBtn.layer.cornerRadius = 5
        updateLoginButton()
//        hideKeyboardWhenTappedAround()
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowNotification(keyboardShowNotification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - handleKeyboardShowNotification
    @objc private func handleKeyboardShowNotification(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            print(keyboardRectangle.height)
            bottomConstraintOfChangeBtn.constant = keyboardRectangle.height + 16
        }
    }
    
    //MARK: - hideKeyboard
    @objc func hideKeyboard(notification: Notification) {
        self.bottomConstraintOfChangeBtn.constant = 16
    }

    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func clickToShowPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.tag == 1 {
            currentPassTxt.isSecureTextEntry = !currentPassTxt.isSecureTextEntry
        }
        else if sender.tag == 2 {
            newPassTxt.isSecureTextEntry = !newPassTxt.isSecureTextEntry
        }
        else if sender.tag == 3 {
            confirmPassTxt.isSecureTextEntry = !confirmPassTxt.isSecureTextEntry
        }
    }
    
    //MARK: - changeBTnIsPRessed
    @IBAction func changeBtnIsPRessed(_ sender: UIButton) {
        guard let currentPass = currentPassTxt.text,let newPass = newPassTxt.text,let confirmPass = confirmPassTxt.text else{return}
        if currentPass == ""{
            currentPassTxt.resignFirstResponder()
            self.view.sainiShowToast(message: "Please enter your current password")
        }
        else if newPass == ""{
            currentPassTxt.resignFirstResponder()
            newPassTxt.resignFirstResponder()
             self.view.sainiShowToast(message: "Please enter your new password")
        }
        else if confirmPass == ""{
            currentPassTxt.resignFirstResponder()
            newPassTxt.resignFirstResponder()
            confirmPassTxt.resignFirstResponder()
            self.view.sainiShowToast(message: "Please enter confirm password")
        }
        else if newPass != confirmPass{
            currentPassTxt.resignFirstResponder()
            newPassTxt.resignFirstResponder()
            confirmPassTxt.resignFirstResponder()
            self.view.sainiShowToast(message: "Password doesn't match")
        }
        else{
            currentPassTxt.resignFirstResponder()
            newPassTxt.resignFirstResponder()
            confirmPassTxt.resignFirstResponder()
            let request = UpdateProfileRequest(oldPassword: currentPass, newPassword: newPass, firstName: "", lastName: "")
            passVM.chnagePassword(request: request)
        }
    }


}

//MARK:- SettingDelegate
extension ChangePasswordVC:SettingDelegate
{
    func deleteAccount(isAccountDeleted: Bool) {
        
    }
    
    func didReceivedSettingResponse(response: UpdateProfileResponse) {
        AppDelegate().sharedDelegate().showErrorToast(message: "Password Changed Successfully", true)
        self.navigationController?.popViewController(animated: false)
    }
}

extension ChangePasswordVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateLoginButton()
    }
    
    func updateLoginButton() {
        if currentPassTxt.text?.trimmed != "" && newPassTxt.text?.trimmed != "" && confirmPassTxt.text?.trimmed != "" {
            changeBtn.backgroundColor = GreenColor
            changeBtn.setTitleColor(BlackColor, for: .normal)
            changeBtn.isUserInteractionEnabled = true
        }else{
            changeBtn.backgroundColor = PaleGrayColor
            changeBtn.setTitleColor(colorFromHex(hex: "C1CBCF"), for: .normal)
            changeBtn.isUserInteractionEnabled = false
        }
    }
}
