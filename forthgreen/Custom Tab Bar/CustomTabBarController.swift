//
//  CustomTabBarController.swift
//  UrbanKiddie
//
//  Created by Rohit Saini on 10/08/18.
//  Copyright © 2018 Appknit. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController,CustomTabBarViewDelegate{
    
    var tabBarView : CustomTabBarView = CustomTabBarView()// Custom Tabbar View Object
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        tabBarView = Bundle.main.loadNibNamed("CustomTabBarView", owner: nil, options: nil)?.last as! CustomTabBarView // Loading the Custom Tabbar View
        
        tabBarView.delegate = self
        
        addTabBarView() //Adding Tabbar view Dynamically
//        tabBarView.bedgeCountView.layer.cornerRadius =  tabBarView.bedgeCountView.frame.size.height / 2
//        tabBarView.bedgeCountView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        tabBarView.bedgeCountView.layer.borderWidth = 1
//        tabBarView.bedgeCountView.layer.masksToBounds = true
        
        
        setup() // Setting up the tabbar StoryBoard Controller
        // Do any additional setup after loading the view.
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(UpdateBadgeCount(noti:)), name: NOTIFICATIONS.UpdateBadge, object: nil)
//        guard let show = UserDefaults.standard.value(forKey: USER_DEFAULT_KEYS.badgeCount.rawValue) as? Bool else{
//            return
//        }
//        if show{
//            tabBarView.bedgeCountView.isHidden = false
//        }
//        else{
//            tabBarView.bedgeCountView.isHidden = true
//        }
    }
    
    @objc func SwitchTabEventReceived(noti : Notification)
    {
        
        let dict : [String : Any] = noti.object as! [String : Any]
        if let lastIndex : Int = dict["tab"] as? Int
        {
            resetTabbarBtn()
            if lastIndex == 1{
                self.tabBarView.Btn3.isSelected = true;
                self.tabBarView.Btn3_View.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
                self.tabSelectedAtIndex(index: lastIndex)
            }
            else if lastIndex == 2{
                self.tabBarView.Btn4.isSelected = true;
                self.tabBarView.Btn4_View.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
                self.tabSelectedAtIndex(index: lastIndex)
            }
        }
    }
    
    @objc func UpdateBadgeCount(noti : Notification)
    {
        BrandBadgeStatusUpdated()
    }
    
    
    //MARK:- resetTabbarBtn
    func resetTabbarBtn()
    {
        self.tabBarView.Btn1.isSelected = false;
        self.tabBarView.Btn1_View.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.tabBarView.Btn2.isSelected = false;
        self.tabBarView.Btn2_View.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.tabBarView.Btn3.isSelected = false;
        self.tabBarView.Btn3_View.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.tabBarView.Btn4.isSelected = false;
        self.tabBarView.Btn4_View.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.tabBarView.Btn5.isSelected = false;
        self.tabBarView.Btn5_View.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
    //MARK:- Setup
    func setup()
    {
        
        var viewControllers = [UINavigationController]()
        
        let navController : UINavigationController = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: "SocialFeedNavigation" ) as! UINavigationController
        viewControllers.append(navController)
        
        let navController1 : UINavigationController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeNavigation" ) as! UINavigationController
        viewControllers.append(navController1)
        
        //        let navController2 : UINavigationController = STORYBOARD.BRAND_LIST.instantiateViewController(withIdentifier: "BrandListNavigation") as! UINavigationController
        //        viewControllers.append(navController2)
        
        let navController3 : UINavigationController = STORYBOARD.RESTAURANT.instantiateViewController(withIdentifier: "RestaurantNavigation") as! UINavigationController
        viewControllers.append(navController3)
        
        let navController4 : UINavigationController = STORYBOARD.MY_BRAND.instantiateViewController(withIdentifier: "MyBrandNavigation") as! UINavigationController
        viewControllers.append(navController4)
        
        let navController5 : UINavigationController = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "SettingNavigation") as! UINavigationController
        viewControllers.append(navController5)
        
        self.viewControllers = viewControllers;
        
        self.tabBarView.Btn1.isSelected = true;
        self.tabBarView.Btn1_View.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
        self.tabSelectedAtIndex(index: 0)
        
    }
    
    func tabSelectedAtIndex(index: Int) {
        setSelectedViewController(selectedViewController: self.viewControllers![index], tabIndex: index)
    }
    
    func selectedTabView(index: Int = 0) {
        self.selectedIndex = index
        self.selectedViewController = self.viewControllers![index]
    }
    
    func setSelectedViewController(selectedViewController:UIViewController, tabIndex:Int)
    {
        
        // pop to root if tapped the same controller twice
        if self.selectedViewController == selectedViewController {
            (self.selectedViewController as! UINavigationController).popToRootViewController(animated: false)
        }
        super.selectedViewController = selectedViewController
    }
    
    //MARK:- addTabBarView
    func addTabBarView()
    {
        self.tabBarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tabBarView)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: ((UIScreen.main.bounds.height >= 812) ? 76 : 56)))
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: ((UIScreen.main.bounds.height == 812) ? 0 : 0)))
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
        self.view.layoutIfNeeded()
    }
    
    //MARK:- Hiding Tabbar
    func tabBarHidden() -> Bool
    {
        return self.tabBarView.isHidden && self.tabBar.isHidden
    }
    
    //MARK:- setTabBarHidden
    func setTabBarHidden(tabBarHidden:Bool)
    {
        self.tabBarView.isHidden = tabBarHidden
        self.tabBar.isHidden = true
    }
    
    //MARK: - setTabBarHidden
    func BrandBadgeStatusUpdated() {
        self.tabBarView.UpdateBrandBadge()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
