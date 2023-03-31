//
//  CustomTabBarView.swift
//  UrbanKiddie
//
//  Created by Rohit Saini on 10/08/18.
//  Copyright © 2018 Appknit. All rights reserved.
//

import UIKit
//MARK:- Custom Delegate Method for Selecting Tab Bar Button
protocol CustomTabBarViewDelegate {
    func tabSelectedAtIndex(index:Int)
}

class CustomTabBarView: UIView {
    
//    @IBOutlet weak var bedgeCountView: UIView!
    @IBOutlet weak var Btn1: UIButton!
    @IBOutlet weak var Btn2: UIButton!
    @IBOutlet weak var Btn3: UIButton!
    @IBOutlet weak var Btn4: UIButton!
    @IBOutlet weak var Btn5: UIButton!
    @IBOutlet weak var Btn1_View: UIView!
    @IBOutlet weak var Btn2_View: UIView!
    @IBOutlet weak var Btn3_View: UIView!
    @IBOutlet weak var Btn4_View: UIView!
    @IBOutlet weak var Btn5_View: UIView!
    
    var lastIndex : NSInteger!
    var delegate:CustomTabBarViewDelegate? // delegate variable
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    convenience init(frame: CGRect, title: String) {
        self.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func initialize()
    {
        lastIndex = 0
    }
    
    @IBAction func tabBtnClicked(_ sender: Any)
    {
        
        let btn: UIButton? = (sender as? UIButton)
        lastIndex = (btn?.tag)!-1
        if let savedLastIndex = UserDefaults.standard.value(forKey: USER_DEFAULT_KEYS.lastIndex.rawValue) as? Int{
            if lastIndex == savedLastIndex{
                AppModel.shared.SameVC = .Yes
            }
            else{
                AppModel.shared.SameVC = .No
            }
            
        }
        UserDefaults.standard.setValue(lastIndex, forKey: USER_DEFAULT_KEYS.lastIndex.rawValue)
        resetAllButton()
        selectTabButton()
        
        if lastIndex == 3{
            UserDefaults.standard.set(false, forKey: USER_DEFAULT_KEYS.badgeCount.rawValue)
            UpdateBrandBadge()
            NotificationCenter.default.post(name: NOTIFICATIONS.BookmarkUpdateList, object: nil)
        }
        if AppModel.shared.SameVC == .Yes{
            UIViewController.top?.scrollToTop()
        }

    }
    
    func UpdateBrandBadge() {
        guard let show = UserDefaults.standard.value(forKey: USER_DEFAULT_KEYS.badgeCount.rawValue) as? Bool else{
            return
        }
        DispatchQueue.main.async {
//            if show{
//                self.bedgeCountView.isHidden = false
//            }
//            else{
//                self.bedgeCountView.isHidden = true
//            }
        }
    }
    
    //MARK:- Reset All Button
    func resetAllButton()
    {
        Btn1.isSelected = false
        Btn2.isSelected = false
        Btn3.isSelected = false
        Btn4.isSelected = false
        Btn5.isSelected = false
        
        Btn1_View.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        Btn2_View.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        Btn3_View.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        Btn4_View.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        Btn5_View.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    
    //MARK:- Select Tab Button
    func selectTabButton()
    {
        switch lastIndex {
        case 0:
            Btn1.isSelected = true
            Btn1_View.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
            
            break
        case 1:
            Btn2.isSelected = true
            Btn2_View.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)

            break
        case 2:
            Btn3.isSelected = true
            Btn3_View.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
            
            break
        case 3:
            Btn4.isSelected = true
            Btn4_View.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
            
            break
        case 4:
            Btn5.isSelected = true
            Btn5_View.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
            
            break
        default:
            break
            
        }
        delegate?.tabSelectedAtIndex(index: lastIndex)//Delegate Method
    }
    
    //MARK:- Select Tab Button
    func selectNotificatoinTabButton(index: Int)
    {
        switch index {
        case 0:
            Btn1.isSelected = true
            Btn1_View.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
            
            break
        case 1:
            Btn2.isSelected = true
            Btn2_View.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
            
            break
        case 2:
            Btn3.isSelected = true
            Btn3_View.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
            
            break
        case 3:
            Btn4.isSelected = true
            Btn4_View.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
            
            break
        case 4:
            Btn5.isSelected = true
            Btn5_View.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)
            
            break
        default:
            break
            
        }
        delegate?.tabSelectedAtIndex(index: index)//Delegate Method
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
