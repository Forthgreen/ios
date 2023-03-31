//
//  RateReviewViewModel.swift
//  forthgreen
//
//  Created by Rohit Saini on 16/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol RateReviewDelegate {
    func didReceiveRateReviewResponse(response:RatingReviewResponse)
}

struct RateReviewViewModel {
    var delegate:RateReviewDelegate?
    func rateReviewList(page:Int){
        let params: [String: Any] = ["page":page]
        APIManager.sharedInstance.I_AM_COOL(params: params, api: API.RATE_AND_REVIEW.myList, Loader: false, isMultipart: false) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(RatingReviewResponse.self, from: response!) // decode the response into success model
                    switch success.code{
                    case 100:
                        self.delegate?.didReceiveRateReviewResponse(response: success)
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
