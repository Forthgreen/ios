//
//  BrandViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 14/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol BrandDelegate {
    func DidRecieveBrandResponse(brandResponse: BrandResponse)
}

struct BrandViewModel {
    var delegate: BrandDelegate?

    func BrandList(brandRequest: BrandRequest,page:Int) {
        let params: [String: Any] = ["getFollowers": brandRequest.getFollowers, "category": brandRequest.category, "page":page]
        
        var api : String = ""
        if AppModel.shared.isGuestUser {
            api = API.BRAND.guestList
        }
        else {
            api = API.BRAND.list
        }
        
        GCD.BRAND.list.async {
            APIManager.sharedInstance.I_AM_COOL(params: params, api: api, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(BrandResponse.self, from: response!) // decode the response into brand model
                        switch success.code{
                        case 100:
                            self.delegate?.DidRecieveBrandResponse(brandResponse: success)
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
