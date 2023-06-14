//
//  ShopCategoryVC.swift
//  forthgreen
//
//  Created by ARIS Pvt Ltd on 31/05/23.
//  Copyright © 2023 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils

class ShopCategoryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var ProductHomeVM: ProductHomeViewModel = ProductHomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "SearchCategoryTVC", bundle: nil), forCellReuseIdentifier: "SearchCategoryTVC")
       
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: false)
            self.tableView.reloadData()
        }
    }

    
    @IBAction func showShopVCAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: UITableViewDelegate

extension ShopCategoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PRODUCT_CATEGORIES.allCases.count
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCategoryTVC", for: indexPath) as? SearchCategoryTVC
        let object = PRODUCT_CATEGORIES.allCases[indexPath.row]
        cell?.categoryImage.image = UIImage(named: object.getImage())
        cell?.categoryLbl.text = object.getString()
        cell?.containerView.sainiCornerRadius(radius: 4)
        cell?.containerView.backgroundColor = colorFromHex(hex: "F4F6F6")
        return cell ?? UITableViewCell()
    }
    
    // estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112 //UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        100
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? SearchCategoryTVC {
            cell.containerView.backgroundColor = colorFromHex(hex: "ECEDED")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ProductVC") as! ProductVC
            vc.categoryRef = PRODUCT_CATEGORIES.allCases[indexPath.row].rawValue
            vc.categoryName = PRODUCT_CATEGORIES.allCases[indexPath.row].getString()
            vc.ProductHomeVM = self.ProductHomeVM
            vc.isBackDisplay = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
