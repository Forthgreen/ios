//
//  EditProfileViewModel.swift
//  forthgreen
//
//  Created by Rohit Saini on 16/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

struct EditProfileViewModel {
    
    var delegate:SettingDelegate?
    func updateProfile(request:UpdateProfileRequest, imageData: Data){
        GCD.USER.update.async {
            APIManager.sharedInstance.MULTIPART_IS_COOL(imageData, param: request.toJSON(), api: API.USER.update, login: true) { (response) in
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
    
}
