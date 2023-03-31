//
//  FollowingRestaurantListViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 09/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol FollowingRestaurantListDelegate {
    func didRecieveFollowingRestaurantListResponse(response: FollowingRestaurantListingResponse)
}

struct FollowingRestaurantListViewModel {
    var delegate: FollowingRestaurantListDelegate?
    
    func fetchFollowingRestaurantList(page: Int) {
        let params: [String: Any] = [String: Any]()
        GCD.FOLLOW_RESTAURANT.list.async {
            APIManager.sharedInstance.I_AM_COOL(params: params, api: API.FOLLOW_RESTAURANT.list, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(FollowingRestaurantListingResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveFollowingRestaurantListResponse(response: success.self)
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
