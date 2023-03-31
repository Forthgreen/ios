//
//  SocialLoginViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 12/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol SocialLoginDelegate {
    func DidRecieveSocialResponse(loginResponse: LoginResponse?)
}

struct SocialLoginViewModel {
    var delegate: SocialLoginDelegate?
    
    func SocialLogin(params: [String: Any]) {
        let imageData = Data()
        GCD.USER.socialLogin.async {
            APIManager.sharedInstance.MULTIPART_IS_COOL(imageData, param: params, api: API.USER.socialLogin, login: true) { (response) in
                if response != nil{                         //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(LoginResponse.self, from: response!) // decode the response into UserDetailModel
                        switch success.code{
                        case 100:
                         self.delegate?.DidRecieveSocialResponse(loginResponse: success)
                            
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
