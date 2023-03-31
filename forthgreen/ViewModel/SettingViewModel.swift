//
//  SettingViewModel.swift
//  forthgreen
//
//  Created by Rohit Saini on 16/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol SettingDelegate {
    func didReceivedSettingResponse(response:UpdateProfileResponse)
    func deleteAccount(isAccountDeleted: Bool)
}


struct SettingViewModel {
    var delegate:SettingDelegate?
    func updateProfile(imageData:Data){
        let params: [String: Any] = [String: Any]()
        GCD.USER.update.async {
            APIManager.sharedInstance.MULTIPART_IS_COOL(imageData, param: params, api: API.USER.update, login: true) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(UpdateProfileResponse.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didReceivedSettingResponse(response: success)
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
    
    func deleteProfile() {
        let params: [String: Any] = [String: Any]()
        GCD.USER.deleteAccount.async {
            APIManager.sharedInstance.I_AM_COOL(params: params, api: API.USER.deleteAccount, Loader: true, isMultipart: false) { response in
                
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.deleteAccount(isAccountDeleted: true)
                            break
                        default:
                            log.error("\(Log.stats()) \(success.message)")/
                            self.delegate?.deleteAccount(isAccountDeleted: false)
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
