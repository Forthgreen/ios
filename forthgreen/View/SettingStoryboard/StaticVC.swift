//
//  StaticVC.swift
//  forthgreen
//
//  Created by Rohit Saini on 20/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils
import MarkdownView

class StaticVC: UIViewController {
    
    var dataType:STATIC_DATA = .about
    
    //OUTLET
    @IBOutlet weak var webView: MarkdownView!
    @IBOutlet weak var moveToTopBtn: UIButton!
    @IBOutlet weak var staticText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        
        // Do any additional setup after loading the view.
    }
    //MARK: - viewWillAppear
      override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
         
        if let tabBar : CustomTabBarController = self.tabBarController as? CustomTabBarController{
          tabBar.setTabBarHidden(tabBarHidden: true)
        }
      }
       
      //MARK: - viewWillDisappear
      override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
      }
    
    //MARK: - configUI
    private func configUI(){
        
        if dataType == .privacy{
            self.title = "Privacy Policy"
            if let privacy = AppModel.shared.staticData?.privacyPolicy{
                //    staticText.text = privacy
                
                
                staticText.attributedText = privacy.convertToAttributedString()
                //                self.webView.load(markdown: privacy)
            }
        }
        else if dataType == .terms{
            self.title = "Terms & Conditions"
            if let terms =  AppModel.shared.staticData?.termsAndCondition{
                //staticText.text = terms
                staticText.attributedText = terms.convertToAttributedString()
                
                //                self.webView.load(markdown: terms)
            }
            
        }
    }
    
    @IBAction func clickBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func clickMoveToTopBtn(_ sender: UIButton) {
        self.scrollToTop()
    }
    
}
