//
//  RestaurantListRequest.swift
//  forthgreen
//
//  Created by MACBOOK on 07/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

struct RestaurantListRequest: Encodable {
    var longitude, latitude: Double?
    var categories: [Int]?
    var text: String?
    var limit, page: Int?
    
    init(longitude: Double? = nil, latitude: Double? = nil, categories: [Int]? = nil, text: String? = nil, limit: Int? = nil, page: Int? = nil) {
        self.longitude = longitude
        self.latitude = latitude
        self.categories = categories
        self.text = text
        self.limit = limit
        self.page = page
    }
}

struct RestaurantMapListRequest: Encodable {
    var longitude, latitude: Double?
    var existId: [String]?
    var distance, page, limit: Int?
    var text: String?
    
    init(longitude: Double? = nil, latitude: Double? = nil, existId: [String]? = nil, distance: Int? = nil, page: Int? = nil, limit: Int? = nil, text: String? = nil) {
        self.longitude = longitude
        self.latitude = latitude
        self.distance = distance
        self.page = page
        self.existId = existId
        self.text = text
        self.limit = limit
    }
}
