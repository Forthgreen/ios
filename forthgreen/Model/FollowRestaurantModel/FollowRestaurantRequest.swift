//
//  FollowRestaurantRequest.swift
//  forthgreen
//
//  Created by MACBOOK on 09/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

struct FollowRestaurantRequest: Encodable {
    var status: Bool
    var restaurantRef: String
}
