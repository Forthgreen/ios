//
//  ReviewSentVC.swift
//  forthgreen
//
//  Created by MACBOOK on 06/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class ReviewSentVC: UIViewController {
    
    var backBtnType: REVIEW_TYPE = .product

    @IBOutlet weak var backToProductBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigUI()
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        backToProductBtn.layer.cornerRadius = 3
        if backBtnType == .product {
            backToProductBtn.setTitle("BACK TO PRODUCT", for: .normal)
        }
        else if backBtnType == .restaurant {
            backToProductBtn.setTitle("BACK TO RESTAURANT", for: .normal)
        }
    }

    //MARK: - backToProductBtnIsPressed
    @IBAction func backToProductBtnIsPressed(_ sender: UIButton) {
        if backBtnType == .product {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: ProductDetailVC.self) {
                    NotificationCenter.default.post(name: NOTIFICATIONS.RefreshProductReviews, object: nil)
                    self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        else if backBtnType == .restaurant {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: RestaurantDetailVC.self) {
                    NotificationCenter.default.post(name: NOTIFICATIONS.RefreshRestaurantReviews, object: nil)
                    self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
}
