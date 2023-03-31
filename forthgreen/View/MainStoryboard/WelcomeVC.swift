//
//  WelcomeVC.swift
//  forthgreen
//
//  Created by MACBOOK on 01/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils
import AuthenticationServices
import GoogleSignIn

class WelcomeVC: UIViewController {
    
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var signUpWithAppleView: UIView!
    @IBOutlet weak var fbView: UIView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var termsConditionsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfigUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        subtitleLbl.increaseLineSpacing(text: subtitleLbl.text!)
        termsConditionsLbl.text = "By signing up you agree our\nTerms & Conditions and Private Policy"
        termsConditionsLbl.textColor = colorFromHex(hex: "3E4B4D")
        termsConditionsLbl.attributedText = attributedStringWithColor(termsConditionsLbl.text!, ["Terms & Conditions", "Private Policy"], color: termsConditionsLbl.textColor, font: termsConditionsLbl.font, lineSpacing: 5, underline: true, alignment: .center)
//        termsConditionsLbl.attributedText = attributedStringForTermsWithColor(color: colorFromHex(hex: "#3E4B4D")) //attributedStringForTerms()
        termsGesture()
        setupDesign(signUpWithAppleView)
        setupDesign(fbView)
        setupDesign(googleView)
        setupDesign(emailView)
    }
    
    func setupDesign(_ view : UIView) {
        view.layer.cornerRadius = 5
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1
    }
    
    //MARK: - termsGesture
    private func termsGesture(){
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        termsConditionsLbl.isUserInteractionEnabled = true
        termsConditionsLbl.addGestureRecognizer(tapAction)
    }
    
    //MARK: - tapLabel
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (termsConditionsLbl.text)!
        let termsRange = (text as NSString).range(of: "Terms & Conditions")
        let privacyRange = (text as NSString).range(of: "Private Policy")
        
        if gesture.didTapAttributedTextInLabel(label: termsConditionsLbl, inRange: termsRange) {
            sainiOpenUrlInSafari(strUrl: STATIC_URLS.termsAndConditions.rawValue)
            
        } else if gesture.didTapAttributedTextInLabel(label: termsConditionsLbl, inRange: privacyRange) {
            sainiOpenUrlInSafari(strUrl: STATIC_URLS.privacyPolicy.rawValue)
            
        } else {
            print("Tapped none")
        }
    }
    
    //MARK: - signUpWithFacebookBtnIsPressed
    @IBAction func signUpWithFacebookBtnIsPressed(_ sender: UIButton) {
   //     AppModel.shared.isGuestUser = false
        AppModel.shared.isSocialLogin = true
        AppDelegate().sharedDelegate().loginWithFacebook()
    }
    
    //MARK: - signUpWithGoogleBtnIsPressed
    @IBAction func signUpWithGoogleBtnIsPressed(_ sender: UIButton) {
  //      AppModel.shared.isGuestUser = false
        AppModel.shared.isSocialLogin = true
        AppDelegate().sharedDelegate().signUpWithGoogle(vc: self)
    }
    
    //MARK: - signUpWithEmailBtnIsPressed
    @IBAction func signUpWithEmailBtnIsPressed(_ sender: UIButton) {
   //     AppModel.shared.isGuestUser = false
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ContinueWithEmailVC") as! ContinueWithEmailVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - continueAsGuestBtnIsPressed
    @IBAction func continueAsAppleBtnIsPressed(_ sender: UIButton) {
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
    
    //MARK: - continueAsGuestBtnIsPressed
    @IBAction func continueAsGuestBtnIsPressed(_ sender: UIButton) {
        AppModel.shared.isGuestUser = true
        AppDelegate().sharedDelegate().navigateToDashboard()
    }
}

//MARK:- ===========Apple Sign in Delegate Methods===============
extension WelcomeVC: ASAuthorizationControllerDelegate{
    
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
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension WelcomeVC: ASAuthorizationControllerPresentationContextProviding{
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (view?.window ?? nil)!
    }
}
