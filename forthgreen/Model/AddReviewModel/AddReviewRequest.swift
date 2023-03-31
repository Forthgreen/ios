//
//  AddReviewRequest.swift
//  forthgreen
//
//  Created by MACBOOK on 18/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

struct AddReviewRequest: Encodable {
    var productRef, restaurantRef: String?
    var rating: Int?
    var title, review: String?
    
    init(productRef: String? = nil, restaurantRef: String? = nil, rating: Int? = nil, title: String? = nil, review: String? = nil) {
        self.productRef = productRef
        self.restaurantRef = restaurantRef
        self.rating = rating
        self.title = title
        self.review = review
    }
}
