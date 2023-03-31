//
//  RestaurantMapViewModel.swift
//  forthgreen
//
//  Created by iMac on 10/25/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol RestaurantMapListingDelegate {
    func didRecieveRestaurantMapListResponse(response: RestaurantListingResponse)
}


//protocol BarListDelegate {
//    var hasMore: Box<Bool> { get set }
//    var restaurantList: Box<[RestaurantListing]> { get set }
//
//    func getReataurantByMapList(request: RestaurantMapListRequest)
//}

struct RestaurantMapListViewModel { //}: BarListDelegate {
    var delegate: RestaurantMapListingDelegate?
//    var hasMore: Box<Bool> = Box(Bool())
//    var restaurantList: Box<[RestaurantListing]> = Box([])
            
    func getReataurantByMapList(request: RestaurantMapListRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.RESTAURANT.map, Loader: false, isMultipart: false) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(RestaurantListingResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.delegate?.didRecieveRestaurantMapListResponse(response: success.self)
//                        self.restaurantList.value += success.data
//                        self.hasMore.value = success.hasMore
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





