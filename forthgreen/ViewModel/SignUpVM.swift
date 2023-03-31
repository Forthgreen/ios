//
//  SignUpVM.swift
//  forthgreen
//
//  Created by MACBOOK on 09/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol SignUpViewModelDelegate {
    func DidRecieveSignUpResponse(loginResponse: SuccessModel?)
}

struct SignUpVM {
    var delegate: SignUpViewModelDelegate?
    
    func API_OfSignInUser(signUpRequest: SignUpRequest?) {
        
        var params = [String : Any]()
        params["firstName"] = signUpRequest?.firstName
        params["email"] = signUpRequest?.email
        params["password"] = signUpRequest?.password
        if signUpRequest?.username != nil && signUpRequest?.username != "" {
            params["username"] = signUpRequest?.username
        }
        
        params["device"] = "iOS"
        params["fcmToken"] = AppModel.shared.fcmToken
    
        GCD.USER.signup.async {
            APIManager.sharedInstance.I_AM_COOL(params: params, api: API.USER.signup, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.DidRecieveSignUpResponse(loginResponse: success.self)
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


