//
//  ShareAppViewModel.swift
//  forthgreen
//
//  Created by Rohit Saini on 19/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation
import UIKit

struct ShareAppActivityViewModel {
    func share(title: String,message: String){
        let objectsToShare = [title,message] as [Any]
        let activityController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityController.setValue(title, forKey: "Subject")
        if let visibleViewController = visibleViewController(){
            activityController.popoverPresentationController?.sourceView = visibleViewController.view
            visibleViewController.present(activityController, animated: true, completion: nil)
        }
    }
}
