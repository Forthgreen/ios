//
//  ChangePasswordViewModel.swift
//  forthgreen
//
//  Created by Rohit Saini on 16/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation



struct ChangePasswordViewModel {
    var delegate:SettingDelegate?
       func chnagePassword(request:UpdateProfileRequest){
           let params: [String: Any] = ["oldPassword":request.oldPassword ?? "","newPassword":request.newPassword ?? ""]
           GCD.USER.update.async {
               APIManager.sharedInstance.MULTIPART_IS_COOL(Data(), param: params, api: API.USER.update, login: true) { (response) in
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
