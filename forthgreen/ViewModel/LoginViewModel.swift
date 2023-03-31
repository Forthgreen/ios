//
//  LoginVM.swift
//  forthgreen
//
//  Created by MACBOOK on 11/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol LoginViewModelDelegate {
    func DidRecieveLoginResponse(loginResponse: LoginResponse?)
}

struct LoginViewModel {
    var delegate: LoginViewModelDelegate?
    
    func API_OfLoginUser(loginRequest: LoginRequest) {
        let params: [String: Any] = [
            "email": loginRequest.email ?? "",
            "password": loginRequest.password ?? "",
            "fcmToken": AppModel.shared.fcmToken,
            "device": "iOS"
        ]
        GCD.USER.login.async {
            APIManager.sharedInstance.I_AM_COOL(params: params, api: API.USER.login, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(LoginResponse.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.DidRecieveLoginResponse(loginResponse: success)
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
