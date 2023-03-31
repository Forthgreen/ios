//
//  ReportSentVC.swift
//  forthgreen
//
//  Created by MACBOOK on 07/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class ReportSentVC: UIViewController {
    
    var isReviewReported: Bool = Bool()
    var reportType: REVIEW_TYPE = .product
    
    @IBOutlet weak var thankyouLbl: UILabel!
    @IBOutlet weak var backToProductBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfigUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        tabBar.setTabBarHidden(tabBarHidden: true)
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        backToProductBtn.layer.cornerRadius = 5
        
        if reportType == .product {
            if isReviewReported {
                thankyouLbl.text = STATIC_LABELS.thanksLblForProduct.rawValue
                backToProductBtn.setTitle("BACK TO PRODUCT", for: .normal)
            }
            else {
                thankyouLbl.text = STATIC_LABELS.thanksLblForProduct.rawValue
                backToProductBtn.setTitle("BACK TO BRAND", for: .normal)
            }
        } else if reportType == .restaurant {
            thankyouLbl.text = STATIC_LABELS.thanksLblForProduct.rawValue
            backToProductBtn.setTitle("BACK TO RESTAURANT", for: .normal)
        }
        else if reportType == .user {
            thankyouLbl.text = STATIC_LABELS.thanksLblForUser.rawValue
            backToProductBtn.setTitle("BACK", for: .normal)
        }
        else if reportType == .comment {
            thankyouLbl.text = STATIC_LABELS.thanksLblForUser.rawValue
            backToProductBtn.setTitle("BACK", for: .normal)
        }
        else if reportType == .post {
            thankyouLbl.text = STATIC_LABELS.thanksLblForUser.rawValue
            backToProductBtn.setTitle("BACK", for: .normal)
        }
    }
    
    //MARK: - backToProductBtnIsPressed
    @IBAction func backToProductBtnIsPressed(_ sender: UIButton) {
        if reportType == .product {
            if isReviewReported{
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: ProductDetailVC.self) {
                        self.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
            else {
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: BrandDetailVC.self) {
                        self.navigationController?.popToViewController(controller, animated: false)
                        break
                    }
                }
            }
        } else if reportType == .restaurant {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: RestaurantDetailVC.self) {
                    self.navigationController?.popToViewController(controller, animated: false)
                    break
                }
            }
        }else if reportType == .user {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: OtherUserProfileVC.self) {
                    self.navigationController?.popToViewController(controller, animated: false)
                    break
                }
            }
        }else if reportType == .comment {
            self.navigationController?.popViewController(animated: false)
        }else if reportType == .post {
            self.navigationController?.popViewController(animated: false)
        }
    }
}
