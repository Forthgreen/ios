//
//  ForgotPasswordVC.swift
//  forthgreen
//
//  Created by MACBOOK on 03/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotPasswordVC: UIViewController {
    
    private var forgotPwdVM: ForgotPasswordViewModel = ForgotPasswordViewModel()

    @IBOutlet var bottomConstraintOfPasswordBtn: NSLayoutConstraint!
    @IBOutlet weak var emailTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var requestNewPwdBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        self.navigationController?.navigationBar.barTintColor = .white
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
          tabBar.setTabBarHidden(tabBarHidden: true)
        }
    }

    //MARK: - ConfigUI
    private func ConfigUI() {
        emailTextfield.sainiSetRightPadding(12)
        emailTextfield.sainiSetLeftPadding(12)
        emailTextfield.titleFormatter = { $0 }
        emailTextfield.titleFont = UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!
        requestNewPwdBtn.layer.cornerRadius = 3
        forgotPwdVM.delegate = self
//        emailTextfield.becomeFirstResponder()
        
        updateForgotButton()
    }

    // MARK: - handleKeyboardShowNotification
    @objc private func handleKeyboardShowNotification(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            print(keyboardRectangle.height)
            bottomConstraintOfPasswordBtn.constant = keyboardRectangle.height + 16
        }
    }
    
    //MARK: - hideKeyboard
    @objc func hideKeyboard(notification: Notification) {
        self.bottomConstraintOfPasswordBtn.constant = 16
    }

    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - requestNewPasswordBtnIsPRessed
    @IBAction func requestNewPasswordBtnIsPressed(_ sender: UIButton) {
        guard let email = emailTextfield.text else {
            self.view.sainiShowToast(message: "email cannot be empty")
            return
        }
        if email == DocumentDefaultValues.Empty.string {
            self.view.sainiShowToast(message: "Kindly enter your email")
        }
        else {
            let request = ForgotPasswordRequest(email: email, requestType: 2)
            emailTextfield.resignFirstResponder()
            forgotPwdVM.forgotPassword(forgotPwdRequest: request)
        }
    }

}

//MARK: - ForgotPasswordDelegate
extension ForgotPasswordVC: ForgotPasswordDelegate {
    func didRecieveFPResponse(forgotPasswordResponse: SuccessModel) {
        self.emailTextfield.text = ""
        AppDelegate().sharedDelegate().showErrorToast(message: "A link to reset password has been sent to you registered email.", true)
        delay(2.0) {
            self.navigationController?.popViewController(animated: true)
        }
//        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ResetPwdPopUp") as! ResetPwdPopUp
//        vc.delegate = self
//        vc.modalPresentationStyle = .overFullScreen
//        self.present(vc, animated: false, completion: nil)
    }
}

extension ForgotPasswordVC:ResetPasswordDelegate{
    func didDismissedPopUp() {
        if let destinationVC =  self.navigationController?.viewControllers.filter({$0 is LoginVC}).first {
            self.navigationController?.popToViewController(destinationVC, animated: false)
        }
    }
}

extension ForgotPasswordVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateForgotButton()
    }
    
    func updateForgotButton() {
        if emailTextfield.text?.trimmed != "" {
            requestNewPwdBtn.backgroundColor = GreenColor
            requestNewPwdBtn.setTitleColor(BlackColor, for: .normal)
            requestNewPwdBtn.isUserInteractionEnabled = true
        }else{
            requestNewPwdBtn.backgroundColor = PaleGrayColor
            requestNewPwdBtn.setTitleColor(GrayColor, for: .normal)
            requestNewPwdBtn.isUserInteractionEnabled = false
        }
    }
}
