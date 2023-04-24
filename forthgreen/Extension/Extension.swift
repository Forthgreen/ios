//
//  Extension.swift
//  forthgreen
//
//  Created by ARIS Pvt Ltd on 27/03/23.
//  Copyright © 2023 SukhmaniKaur. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    //MARK:- sainiShowToast
    public func sainiShowToastWithBackground(message: String,
                                             bgColor: UIColor = UIColor.black.withAlphaComponent(0.6),
                                             font: UIFont = UIFont.systemFont(ofSize: 18)) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let toastLbl = UILabel()
        toastLbl.text = message
        toastLbl.textAlignment = .center
        toastLbl.font = font
        toastLbl.textColor = UIColor.white
        toastLbl.backgroundColor = bgColor
        toastLbl.numberOfLines = 0
        
        
        let textSize = toastLbl.intrinsicContentSize
        let labelHeight = ( textSize.width / window.frame.width ) * 30
        let labelWidth = min(textSize.width, window.frame.width - 34)
        let adjustedHeight = max(labelHeight, textSize.height + 40)
        
        toastLbl.frame = CGRect(x: 17, y: (window.frame.height - 90 ) - adjustedHeight, width: labelWidth + 17, height: adjustedHeight)
        toastLbl.center.x = window.center.x
        toastLbl.layer.cornerRadius = 0
        toastLbl.layer.masksToBounds = true
        
        window.addSubview(toastLbl)
        
        UIView.animate(withDuration: 3.0, animations: {
            toastLbl.alpha = 0
        }) { (_) in
            toastLbl.removeFromSuperview()
        }
    }
}
