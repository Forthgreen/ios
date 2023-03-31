//
//  ForgotPasswordViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 11/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol ForgotPasswordDelegate {
    func didRecieveFPResponse(forgotPasswordResponse: SuccessModel)
}
struct ForgotPasswordViewModel {
    var delegate: ForgotPasswordDelegate?
    
    func forgotPassword(forgotPwdRequest: ForgotPasswordRequest) {
        let params:[String: Any] = [
            "email": forgotPwdRequest.email,
            "requestType": forgotPwdRequest.requestType
        ]
        GCD.USER.resendVerification.async {
            APIManager.sharedInstance.I_AM_COOL(params: params, api: API.USER.resendVerification, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveFPResponse(forgotPasswordResponse: success)
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
