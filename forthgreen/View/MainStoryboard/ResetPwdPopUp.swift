//
//  ResetPwdPopUp.swift
//  forthgreen
//
//  Created by MACBOOK on 04/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

protocol ResetPasswordDelegate{
    func didDismissedPopUp()
}

class ResetPwdPopUp: UIViewController {
    var delegate:ResetPasswordDelegate?
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var popupBackView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfigUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        closeBtn.layer.cornerRadius = 5
        popupBackView.layer.cornerRadius = 5
    }
    
    //MARK: - closeBtnIsPRessed
    @IBAction func closeBtnIsPRessed(_ sender: UIButton) {
        self.dismiss(animated: false) {
            self.delegate?.didDismissedPopUp()
        }
    }
    
}
