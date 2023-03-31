//
//  AddRestaurantReviewViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 09/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol AddRestaurantReviewDelegate {
    func didRecieveRestaurantReviewResponse(response: AddReviewResponse)
}

struct AddRestaurantReviewViewModel {
    var delegate: AddRestaurantReviewDelegate?
    
    func addReview(reviewRequest: AddReviewRequest) {
        GCD.RATE_RESTAURANT.add.async {
            APIManager.sharedInstance.I_AM_COOL(params: reviewRequest.toJSON(), api: API.RATE_RESTAURANT.add, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(AddReviewResponse.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveRestaurantReviewResponse(response: success)
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

