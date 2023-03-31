//
//  RestaurantListingViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 07/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol RestaurantListingDelegate {
    func didRecieveRestaurantListResponse(response: RestaurantListingResponse)
}

struct RestaurantListingViewModel {
    var delegate: RestaurantListingDelegate?
    
    func fetchRestaurantListing(request: RestaurantListRequest) {
        var api : String = ""
        if AppModel.shared.isGuestUser {
            api = API.RESTAURANT.guestList
        }
        else {
            api = API.RESTAURANT.list
        }
        
        GCD.RESTAURANT.list.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: api, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(RestaurantListingResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveRestaurantListResponse(response: success.self)
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
