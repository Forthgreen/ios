//
//  NewPasswordVC.swift
//  forthgreen
//
//  Created by MACBOOK on 03/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class NewPasswordVC: UIViewController {

    @IBOutlet weak var saveBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        saveBtn.layer.cornerRadius = 5
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
