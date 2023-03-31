//
//  FollowBrandViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 16/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol FollowBrandDelegate {
    func didRecieveFollowBrandResponse(response: SuccessModel)
}

struct FollowBrandViewModel {
    var delegate: FollowBrandDelegate?
    
    func FollowBrand(followRequest: FollowBrandRequest) {
        let params: [String: Any] = ["status": followRequest.status,
                                     "brandRef": followRequest.brandRef]
        GCD.FOLLOW_BRAND.update.async {
            APIManager.sharedInstance.I_AM_COOL(params: params, api: API.FOLLOW_BRAND.update, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveFollowBrandResponse(response: success)
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
