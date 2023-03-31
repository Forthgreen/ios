//
//  RestaurantDetailViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 08/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol RestaurantDetailDelegate {
    func didRecieveDetailResponse(response: RestaurantDetailResponse)
}

struct RestaurantDetailViewModel {
    var delegate: RestaurantDetailDelegate?
    
    func fetchRestaurantDetail(request: RestaurantDetailRequest) {
        let api:String
        if AppModel.shared.isGuestUser {
            api = API.RESTAURANT.detailForGuest
        }
        else {
            api = API.RESTAURANT.restaurantDetails
        }
        GCD.RESTAURANT.restaurantDetails.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: api, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(RestaurantDetailResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveDetailResponse(response: success.self)
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
