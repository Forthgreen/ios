//
//  SearchRequest.swift
//  forthgreen
//
//  Created by MACBOOK on 17/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

struct SearchRequest {
    var text: String
    var paginationToken: Bool
    var page: Int
    var limit: Int
}
