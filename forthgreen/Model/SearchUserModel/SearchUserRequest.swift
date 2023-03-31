//
//  SearchUserRequest.swift
//  forthgreen
//
//  Created by MACBOOK on 25/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

struct SearchUserRequest: Encodable {
    var text: String
    var page: Int
}
