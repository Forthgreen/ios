//
//  FollowRestaurantViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 09/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol FollowRestaurantDelegate {
    func didRecieveFollowUpdateResponse(response: SuccessModel)
}
struct FollowRestaurantViewModel {
    var delegate: FollowRestaurantDelegate?
    
    func updateFollowStatus(request: FollowRestaurantRequest) {
        GCD.FOLLOW_RESTAURANT.update.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.FOLLOW_RESTAURANT.update, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveFollowUpdateResponse(response: success.self)
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
