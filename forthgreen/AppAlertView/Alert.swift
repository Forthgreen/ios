//
//  Alert.swift
//  forthgreen
//
//  Created by Rohit Saini on 18/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation
import UIKit


protocol AlertDelegate {
    func didClickOkBtn()
    func didClickCancelBtn()
}

struct Alert {
    var delegate: AlertDelegate?
    func displayAlert(vc: UIViewController,alertTitle: String = "",message: String = "",okBtnTitle:String = "Ok",cancelBtnTitle: String = "Cancel"){
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        //ok action
        let okbtn = UIAlertAction(title: okBtnTitle, style: .default, handler: { action in
            self.delegate?.didClickOkBtn()
        })
        alert.addAction(okbtn)
        //cancel action
        alert.addAction(UIAlertAction(title: cancelBtnTitle, style: .cancel, handler: { action in
            self.delegate?.didClickCancelBtn()
        }))
        alert.preferredAction = okbtn
        alert.view.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)

        vc.present(alert, animated: true)
    }
}
