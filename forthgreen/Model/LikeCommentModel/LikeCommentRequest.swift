//
//  LikeCommentRequest.swift
//  forthgreen
//
//  Created by MACBOOK on 20/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

struct LikeCommentRequest: Encodable {
    var commentRef: String
    var like: Bool
}
