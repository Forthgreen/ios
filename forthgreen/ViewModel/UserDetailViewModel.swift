//
//  UserDetailViewModel.swift
//  forthgreen
//
//  Created by Rohit Saini on 16/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation


protocol UserDetailDelegate {
    func didReceivedUserDetailResponse(response:UpdateProfileResponse)
}


struct UserDetailViewModel {
    var delegate:UserDetailDelegate?
    func fetchUserDetails(){
        let params: [String: Any] = [String: Any]()
        GCD.USER.details.async {
            APIManager.sharedInstance.I_AM_COOL(params: params, api: API.USER.details, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(UpdateProfileResponse.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didReceivedUserDetailResponse(response: success)
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
