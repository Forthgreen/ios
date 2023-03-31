//
//  LogoutViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 21/08/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol LogoutDelegate {
    var success: Box<Bool> { get set }
    func userLogout()
}

struct LogoutViewModel: LogoutDelegate {
    var success: Box<Bool> = Box(Bool())
    
    func userLogout() {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: [String : Any](), api: API.USER.logout, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(NotificationResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.success.value = true
                            break
                        default:
                            log.error("\(Log.stats()) \(success.message)")/
                        }
                    }
                    catch let err {
                        log.error("ERROR OCCURED WHILE DECODING: \(Log.stats()) \(err)")/
                    }
                }
            }
        }
    }
}
