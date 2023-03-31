//
//  BrandDetailViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 15/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol BrandDetailDelegate {
    func didRecieveBrandDetailResponse(detailResponse: BrandDetailResponse)
}

struct BrandDetailViewModel {
    var delegate: BrandDetailDelegate?
    
    func brandDetail(detailRequest: BrandDetailRequest) {
        let params: [String: Any] = ["brandRef": detailRequest.brandRef]
        let api:String
        if AppModel.shared.isGuestUser {
            api = API.BRAND.detailForGuest
        }
        else {
            api = API.BRAND.detailForUser
        }
        GCD.BRAND.detailForUser.async {
            APIManager.sharedInstance.I_AM_COOL(params: params, api: api, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(BrandDetailResponse.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveBrandDetailResponse(detailResponse: success)
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
