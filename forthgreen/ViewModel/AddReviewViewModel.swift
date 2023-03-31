//
//  AddReviewViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 18/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol AddReviewDelegate {
    func didRecieveReviewResponse(response: AddReviewResponse)
}

struct AddReviewViewModel {
    var delegate: AddReviewDelegate?
    
    func addReview(reviewRequest: AddReviewRequest) {
        let params: [String: Any] = ["productRef": reviewRequest.productRef,
                                     "rating": reviewRequest.rating,
                                     "title": reviewRequest.title,
                                     "review": reviewRequest.review]
        GCD.RATE_AND_REVIEW.add.async {
            APIManager.sharedInstance.I_AM_COOL(params: params, api: API.RATE_AND_REVIEW.add, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(AddReviewResponse.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveReviewResponse(response: success)
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
