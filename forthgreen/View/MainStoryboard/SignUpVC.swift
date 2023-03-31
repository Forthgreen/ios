//
//  SignUpVC.swift
//  forthgreen
//
//  Created by MACBOOK on 03/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift

class SignUpVC: UIViewController {
    
    @IBOutlet weak var termsConditionLbl: UILabel!
    var genderArray = ["Male", "Female", "Other"]
    private var signUpVM: SignUpVM = SignUpVM()
    var dob: String = String()
    var gender: Int = Int()

    @IBOutlet var bottomConstraintOfSignupBtn: NSLayoutConstraint!
    @IBOutlet weak var hideShowPwdBtn: UIButton!
    @IBOutlet weak var usernameTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var firstNameTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var dobLbl: UILabel!
    @IBOutlet weak var dobView: UIView!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = .white
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
          tabBar.setTabBarHidden(tabBarHidden: true)
        }
        
//        IQKeyboardManager.shared.enableAutoToolbar = false
//        IQKeyboardManager.shared.enable = false
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
//        IQKeyboardManager.shared.enableAutoToolbar = true
//        IQKeyboardManager.shared.enable = true
    }

    //MARK: - ConfigUI
    private func ConfigUI() {
        
        usernameTextfield.sainiSetRightPadding(12)
        usernameTextfield.sainiSetLeftPadding(12)
        passwordTextfield.sainiSetRightPadding(50)
        passwordTextfield.sainiSetLeftPadding(12)
        emailTextfield.sainiSetRightPadding(12)
        emailTextfield.sainiSetLeftPadding(12)
        firstNameTextfield.sainiSetRightPadding(12)
        firstNameTextfield.sainiSetLeftPadding(12)
        
        termsConditionLbl.text = "By signing up you agree our\nTerms & Conditions and Private Policy"
        termsConditionLbl.textColor = colorFromHex(hex: "3E4B4D")
        termsConditionLbl.attributedText = attributedStringWithColor(termsConditionLbl.text!, ["Terms & Conditions", "Private Policy"], color: termsConditionLbl.textColor, font: termsConditionLbl.font, lineSpacing: 5, underline: true, alignment: .center)
        
        firstNameTextfield.titleFormatter = { $0 }
        emailTextfield.titleFormatter = { $0 }
        passwordTextfield.titleFormatter = { $0 }
        firstNameTextfield.titleFont =  UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!
        emailTextfield.titleFont = UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!
        passwordTextfield.titleFont =  UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!
        usernameTextfield.titleFont =  UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!
        signUpBtn.layer.cornerRadius = 3
        signUpVM.delegate = self
        DobGesture()
        GenderGesture()
        termsGesture()
        updateSignupButton()
        
//        hideKeyboardWhenTappedAround()
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowNotification(keyboardShowNotification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - termsGesture
    private func termsGesture(){
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        termsConditionLbl.isUserInteractionEnabled = true
        termsConditionLbl.addGestureRecognizer(tapAction)
    }
    
    // MARK: - handleKeyboardShowNotification
    @objc private func handleKeyboardShowNotification(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            print(keyboardRectangle.height)
            bottomConstraintOfSignupBtn.constant = keyboardRectangle.height + 16
        }
    }
    
    //MARK: - hideKeyboard
    @objc func hideKeyboard(notification: Notification) {
        self.bottomConstraintOfSignupBtn.constant = 16
    }
    
    // MARK: - tapLabel
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
         let text = (termsConditionLbl.text)!
        let termsRange = (text as NSString).range(of: STATIC_LABELS.termsLbl.rawValue)
        let privacyRange = (text as NSString).range(of: STATIC_LABELS.privacyPolicy.rawValue)

         if gesture.didTapAttributedTextInLabel(label: termsConditionLbl, inRange: termsRange) {
            sainiOpenUrlInSafari(strUrl: STATIC_URLS.termsAndConditions.rawValue)
           
         } else if gesture.didTapAttributedTextInLabel(label: termsConditionLbl, inRange: privacyRange) {
            sainiOpenUrlInSafari(strUrl: STATIC_URLS.privacyPolicy.rawValue)
            
         } else {
            log.info(STATIC_LABELS.tappedNone.rawValue)/
         }
     }
    
    
    //MARK: - DobGesture
    private func DobGesture() {
        dobView.sainiAddTapGesture {
            RPicker.selectDate(title: STATIC_LABELS.selectDate.rawValue, hideCancel: false,  minDate: nil, maxDate: Date(), didSelectDate: { (date) in
                self.dob = date.dateString(DATE_STRINGS.dob.rawValue)
                self.dobLbl.text = date.dateString(DATE_STRINGS.dobLbl.rawValue)
            })
        }
    }
    
    //MARK: - GenderGesture
    private func GenderGesture() {
        genderView.sainiAddTapGesture {
            RPicker.selectOption(dataArray: self.genderArray) { (gender, index) in
                self.genderLbl.text = gender
                self.gender = index + 1
            }
        }
    }

    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: - hideShowPasswordBtnIsPressed
    @IBAction func hideShowPasswordBtnIsPressed(_ sender: UIButton) {
        
        if hideShowPwdBtn.currentImage == UIImage(named: PASSWORD_EYE_IMAGES.hide.rawValue) {
            hideShowPwdBtn.setImage(UIImage(named: PASSWORD_EYE_IMAGES.show.rawValue), for: UIControl.State.normal)
            passwordTextfield.isSecureTextEntry = false
        }
        else {
            hideShowPwdBtn.setImage(UIImage(named: PASSWORD_EYE_IMAGES.hide.rawValue), for: UIControl.State.normal)
            passwordTextfield.isSecureTextEntry = true
        }
    }
    //MARK: - signUpBtnIsPRessed
    @IBAction func signUpBtnIsPressed(_ sender: UIButton) {
        guard let firstName = firstNameTextfield.text else {
            firstNameTextfield.resignFirstResponder()
            self.view.sainiShowToast(message: STATIC_LABELS.nameToast.rawValue)
            return
        }
        guard let email = emailTextfield.text else {
            firstNameTextfield.resignFirstResponder()
            emailTextfield.resignFirstResponder()
            self.view.sainiShowToast(message: STATIC_LABELS.emailToast.rawValue)
            return
        }
        guard let username = usernameTextfield.text else {
            firstNameTextfield.resignFirstResponder()
            emailTextfield.resignFirstResponder()
            usernameTextfield.resignFirstResponder()
  //          self.view.sainiShowToast(message: STATIC_LABELS.usernameToast.rawValue)
            return
        }
        guard let password = passwordTextfield.text else {
            firstNameTextfield.resignFirstResponder()
            emailTextfield.resignFirstResponder()
            passwordTextfield.resignFirstResponder()
            self.view.sainiShowToast(message: STATIC_LABELS.passwordToast.rawValue)
            return
        }
        if firstName == DocumentDefaultValues.Empty.string {
            self.view.sainiShowToast(message: STATIC_LABELS.nameToast.rawValue)
        }
        else if email == DocumentDefaultValues.Empty.string {
            self.view.sainiShowToast(message: STATIC_LABELS.emailToast.rawValue)
        }
        else if !email.isValidEmail{
            self.view.sainiShowToast(message: STATIC_LABELS.validEmailToast.rawValue)
        }
//        else if username == DocumentDefaultValues.Empty.string {
//            self.view.sainiShowToast(message: STATIC_LABELS.usernameToast.rawValue)
//        }
        else if password == DocumentDefaultValues.Empty.string {
            self.view.sainiShowToast(message: STATIC_LABELS.passwordToast.rawValue)
        }
//        else if gender == DocumentDefaultValues.Empty.int {
//            self.view.sainiShowToast(message: "Kindly select your gender")
//        }
//        else if dobLbl.text == "select date" {
//            self.view.sainiShowToast(message: "Kindly select your Date of birth")
//        }
        else {
            firstNameTextfield.resignFirstResponder()
            emailTextfield.resignFirstResponder()
            passwordTextfield.resignFirstResponder()
            
            let request = SignUpRequest(firstName: firstNameTextfield.text, email: emailTextfield.text, username: username, password: passwordTextfield.text)
            signUpVM.API_OfSignInUser(signUpRequest: request)
        }
    }
    
    //MARK: - SubmitAlert
    private func SubmitAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: STATIC_LABELS.okLbl.rawValue, style: UIAlertAction.Style.default , handler: { (action) in
            let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: false)
        }))
        alert.view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - SignUpViewModelDelegate
extension SignUpVC: SignUpViewModelDelegate {
    func DidRecieveSignUpResponse(loginResponse: SuccessModel?) {
        log.success(loginResponse?.message ?? DocumentDefaultValues.Empty.string)/
        SubmitAlert(title: STATIC_LABELS.verification.rawValue, message: STATIC_LABELS.verificationMsg.rawValue)
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATIONS.LoginSignupTabRedirection.rawValue), object: ["tab" : TAB.LOGIN])
    }
    
}

extension SignUpVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSignupButton()
    }
    
    func updateSignupButton() {
        if firstNameTextfield.text?.trimmed != "" && emailTextfield.text?.trimmed != "" && passwordTextfield.text?.trimmed != "" {
            signUpBtn.backgroundColor = GreenColor
            signUpBtn.setTitleColor(BlackColor, for: .normal)
            signUpBtn.isUserInteractionEnabled = true
        }else{
            signUpBtn.backgroundColor = PaleGrayColor
            signUpBtn.setTitleColor(colorFromHex(hex: "#C1CBCF"), for: .normal)
            signUpBtn.isUserInteractionEnabled = false
        }
    }
}
