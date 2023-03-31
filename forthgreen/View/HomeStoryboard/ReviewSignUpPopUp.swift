//
//  ReviewSignUpPopUp.swift
//  forthgreen
//
//  Created by MACBOOK on 07/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class ReviewSignUpPopUp: UIViewController {
    
    var displayType: DisplayPopUpType = .Follow
    
    @IBOutlet weak var popUpImage: UIImageView!
    @IBOutlet weak var popUpHeadingLbl: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        signUpBtn.layer.cornerRadius = 5
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        loginLbl.attributedText = getAttributedStringForLogin()
        loginLbl.sainiAddTapGesture {
            let vc: LoginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as!  LoginVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        if displayType == .Review {
            popUpHeadingLbl.text = "Sign up to review products"
            popUpImage.image = UIImage(named: "illustration5")
        }
        else if displayType == .Follow  {
            popUpHeadingLbl.text = "Sign up to follow brands"
            popUpImage.image = UIImage(named: "illustration2")
        }
        else if displayType == .Setting {
            popUpHeadingLbl.text = "Sign up to create your Profile"
            popUpImage.image = UIImage(named: "illustration1")
        }
    }
    
    //MARK: - clickSignUpBtn
    @IBAction func clickCloseBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - clickSignUpBtn
    @IBAction func clickSignUpBtn(_ sender: UIButton) {
        let vc: WelcomeVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "WelcomeVC") as!  WelcomeVC
        self.navigationController?.pushViewController(vc, animated: false)
    }

}
