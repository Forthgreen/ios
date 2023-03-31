//
//  FollowProductRequest.swift
//  forthgreen
//
//  Created by MACBOOK on 17/01/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

struct FollowProductRequest: Encodable {
    var productRef: String
    var status: Bool
}
