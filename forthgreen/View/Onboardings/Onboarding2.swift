//
//  Onboarding2.swift
//  forthgreen
//
//  Created by MACBOOK on 07/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class Onboarding2: UIViewController {

    @IBOutlet weak var nextBtnView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        nextBtnView.layer.cornerRadius = nextBtnView.frame.height / 2
    }

    //MARK: - skipBtnClicked
    @IBAction func skipBtnClicked(_ sender: UIButton) {
             AppModel.shared.isGuestUser = true
               let loginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginNavigation") as! UINavigationController
               UIApplication.shared.windows.first?.rootViewController = loginVC
               UIApplication.shared.windows.first?.makeKeyAndVisible()
       
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
