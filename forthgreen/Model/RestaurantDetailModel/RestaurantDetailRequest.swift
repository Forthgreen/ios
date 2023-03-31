//
//  RestaurantDetailRequest.swift
//  forthgreen
//
//  Created by MACBOOK on 08/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

struct RestaurantDetailRequest: Encodable {
    var restaurantId: String?
    var longitude, latitude: Double?
    
    init(longitude: Double? = nil, latitude: Double? = nil, restaurantId: String? = nil) {
        self.longitude = longitude
        self.latitude = latitude
        self.restaurantId = restaurantId
    }
    
}
