//
//  GuestUserView.swift
//  forthgreen
//
//  Created by MACBOOK on 25/08/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils
import AuthenticationServices
import GoogleSignIn

class GuestUserView: UIView {
    
    let nibName = "GuestUserView"
    
    // OUTLETS
    
    @IBOutlet weak var termsAndConditionsLbl: UILabel!
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var signUpWithAppleView: UIView!
    @IBOutlet weak var fbView: UIView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var emailView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        configUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        configUI()
    }
    
//    class func instanceFromNib() -> UIView {
//        return Bundle.main.loadNibNamed("GuestUserView", owner: self, options: nil)![0] as! UIView
//    }
    
    //MARK: - commonInit
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    //MARK: - loadViewFromNib
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
        
    //MARK: - configUI
    private func configUI() {
        if termsAndConditionsLbl != nil {
            termsAndConditionsLbl.attributedText = attributedStringForTerms()
            
            // gestureCall
            termsGesture()
            
            setupDesign(signUpWithAppleView)
            setupDesign(fbView)
            setupDesign(googleView)
            setupDesign(emailView)
        }
        
    }
    
    func setupDesign(_ view : UIView) {
        view.layer.cornerRadius = 5
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1
    }
    
    //MARK: - termsGesture
    private func termsGesture(){
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        termsAndConditionsLbl.isUserInteractionEnabled = true
        termsAndConditionsLbl.addGestureRecognizer(tapAction)
    }
    
    //MARK: - tapLabel
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (termsAndConditionsLbl.text)!
        let termsRange = (text as NSString).range(of: "Terms & Conditions")
        let privacyRange = (text as NSString).range(of: "Private Policy")
        
        if gesture.didTapAttributedTextInLabel(label: termsAndConditionsLbl, inRange: termsRange) {
            sainiOpenUrlInSafari(strUrl: STATIC_URLS.termsAndConditions.rawValue)
            
        } else if gesture.didTapAttributedTextInLabel(label: termsAndConditionsLbl, inRange: privacyRange) {
            sainiOpenUrlInSafari(strUrl: STATIC_URLS.privacyPolicy.rawValue)
            
        } else {
            print("Tapped none")
        }
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.endEditing(true)
        self.removeFromSuperview()
    }
    
    @IBAction func clickToAppleLogin(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let authorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
            let authorizationRequest = authorizationAppleIDProvider.createRequest()
            authorizationRequest.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [authorizationRequest])
            authorizationController.presentationContextProvider = self
            authorizationController.delegate = self
            authorizationController.performRequests()
        } else {
            displayToast(message: "Kindly update your OS")
        }
    }
    
    // MARK: - signUpWithFacebookBtnIsPressed
    @IBAction func signUpWithFacebookBtnIsPressed(_ sender: UIButton) {
//        AppModel.shared.isGuestUser = false
        AppModel.shared.isSocialLogin = true
        AppDelegate().sharedDelegate().loginWithFacebook()
    }
    
    //MARK: - signUpWithGoogleBtnIsPressed
    @IBAction func signUpWithGoogleBtnIsPressed(_ sender: UIButton) {
        if let visibleViewController = visibleViewController(){
//            AppModel.shared.isGuestUser = false
            AppModel.shared.isSocialLogin = true
            AppDelegate().sharedDelegate().signUpWithGoogle(vc: visibleViewController)
        }
    }
    
    //MARK: - signUpWithEmailBtnIsPressed
    @IBAction func signUpWithEmailBtnIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ContinueWithEmailVC") as! ContinueWithEmailVC
        if let visibleViewController = visibleViewController(){
            self.endEditing(true)
            self.removeFromSuperview()
            visibleViewController.navigationController?.pushViewController(vc, animated: false)
        }
    }
}


//MARK:- ===========Apple Sign in Delegate Methods===============
extension GuestUserView: ASAuthorizationControllerDelegate{
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential{
        case let credentials as ASAuthorizationAppleIDCredential:
            var appleUser = AppleUser()
            appleUser = AppleUser(credentials: credentials)
            if appleUser.email != ""{
                KeychainWrapper.standard.set(appleUser.toJSONData(), forKey: KEY_CHAIN.apple.rawValue)
            }
            else{
                if let storedAppleCred = KeychainWrapper.standard.data(forKey: KEY_CHAIN.apple.rawValue){
                    if let apple = try? JSONDecoder().decode(AppleUser.self, from: storedAppleCred){
                        appleUser = apple
                    }
                }
            }
            appleUser.id = credentials.user
            log.success("Apple User: \(appleUser)")/
            self.saveUserInKeychain(appleUser.id)
            let socialToken = String(decoding: credentials.identityToken ?? Data(), as: UTF8.self)
            AppDelegate().sharedDelegate().LoginWithApple(appleUser: appleUser, socialToken: socialToken)
            
        case let passwordCredential as ASPasswordCredential:
            
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            //  show the password credential as an alert.
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
        
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.app.forthgreenApp", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
         if let visibleViewController = visibleViewController(){
            visibleViewController.present(alertController, animated: true, completion: nil)
        }
        
    }
    
}

extension GuestUserView: ASAuthorizationControllerPresentationContextProviding{
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (visibleViewController()?.view?.window ?? nil)!
    }
}
