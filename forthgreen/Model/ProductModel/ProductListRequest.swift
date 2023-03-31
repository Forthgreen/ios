//
//  ProductModel.swift
//  forthgreen
//
//  Created by MACBOOK on 14/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

struct ProductListRequest: Encodable {
    var category: [Int]?
    var sort, page: Int?
    var text: String?
    var filter: [Int]?
    var gender: Int?
    
    init(category: [Int]? = nil, sort: Int? = nil, page: Int? = nil, text: String? = nil, filter: [Int]? = nil, gender: Int? = nil) {
        self.category = category
        self.sort = sort
        self.text = text
        self.filter = filter
        self.page = page
        self.gender = gender
    }
}
