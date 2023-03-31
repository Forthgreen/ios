//
//  FollowingProductListingViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 17/01/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation
import UIKit

protocol FollowingProductListingDelegate {
    func didRecieveFollowingProductListingResponse(response: FollowingProductListResponse)
}

struct FollowingProductListingViewModel {
    var delegate: FollowingProductListingDelegate?
    
    func fetchProductListing(page: Int) {
        GCD.FOLLOW_PRODUCT.list.async {
            APIManager.sharedInstance.I_AM_COOL(params: ["page" : page], api: API.FOLLOW_PRODUCT.list, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(FollowingProductListResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveFollowingProductListingResponse(response: success)
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
