//
//  ContinueWithEmailVC.swift
//  forthgreen
//
//  Created by iMac on 3/15/22.
//  Copyright © 2022 SukhmaniKaur. All rights reserved.
//

import UIKit

class ContinueWithEmailVC: UIViewController, LoginVCDelegate {

    @IBOutlet weak var signupBottomVIew: UIView!
    @IBOutlet weak var loginBottomView: UIView!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    let loginTab : LoginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.LoginVC.rawValue) as! LoginVC
    var signupTab : SignUpVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.SignUpVC.rawValue) as! SignUpVC
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(redirectToTab(_:)), name: NSNotification.Name.init(NOTIFICATIONS.LoginSignupTabRedirection.rawValue), object: nil)
        configUI()
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
    
    @objc func redirectToTab(_ noti : Notification) {
        if let tab = noti.object as? [String : Any] {
            if let temp = tab["tab"] as? String {
                if temp == TAB.LOGIN {
                    clickToTab(loginBtn)
                }
                else if temp == TAB.SIGNUP {
                    clickToTab(signupBtn)
                }
            }
        }
    }
    
    func configUI()  {
        loginTab.delegate = self
        clickToTab(signupBtn)
    }

    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToTab(_ sender: UIButton) {
        signupBottomVIew.backgroundColor = colorFromHex(hex: "#F2F3F4")
        loginBottomView.backgroundColor = colorFromHex(hex: "#F2F3F4")
        loginTab.view.removeFromSuperview()
        signupTab.view.removeFromSuperview()
        if sender.tag == 1 {
            signupBottomVIew.backgroundColor = AppColors.turqoiseGreen
            displaySubViewtoParentView(containerView, subview: signupTab.view)
        }
        else{
            loginBottomView.backgroundColor = AppColors.turqoiseGreen
            displaySubViewtoParentView(containerView, subview: loginTab.view)
        }
    }
    
    func redirectToForgotPassword() {
        let vc : ForgotPasswordVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.ForgotPasswordVC.rawValue) as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
