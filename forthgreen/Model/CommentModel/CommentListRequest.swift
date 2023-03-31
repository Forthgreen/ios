//
//  CommentListRequest.swift
//  forthgreen
//
//  Created by MACBOOK on 16/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

struct CommentListRequest: Encodable {
    internal init(postRef: String? = nil, commentRef: String? = nil, page: Int? = nil, commentType: COMMENT_TYPE? = nil) {
        self.postRef = postRef
        self.commentRef = commentRef
        self.page = page
        self.commentType = commentType
    }
    
    var postRef, commentRef: String?
    var page: Int?
    var commentType: COMMENT_TYPE?
}
