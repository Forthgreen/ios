//
//  FollowUserRequest.swift
//  forthgreen
//
//  Created by MACBOOK on 20/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

struct FollowUserRequest: Encodable {
    var followingRef: String
    var follow: Bool
}
