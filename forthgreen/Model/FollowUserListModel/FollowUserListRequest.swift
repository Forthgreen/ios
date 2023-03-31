//
//  FollowUserListRequest.swift
//  forthgreen
//
//  Created by MACBOOK on 20/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

struct FollowUserListRequest: Encodable {
    var userId: String
    var isFollowing: Bool
    var listType: FOLLOW_LIST_TYPE
    var page: Int
}
