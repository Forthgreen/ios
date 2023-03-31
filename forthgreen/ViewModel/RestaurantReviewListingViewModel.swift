//
//  RestaurantReviewListingViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 09/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol RestaurantReviewListDelegate {
    func didRecieveRestaurantReviewListingResponse(response: RestaurantReviewListingResponse)
}

struct RestaurantReviewListingViewModel {
    var delegate: RestaurantReviewListDelegate?
    
    func fetchReviewListing(request: RestaurantReviewListingRequest) {
        GCD.RATE_AND_REVIEW.list.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.RATE_AND_REVIEW.list, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(RestaurantReviewListingResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveRestaurantReviewListingResponse(response: success.self)
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
