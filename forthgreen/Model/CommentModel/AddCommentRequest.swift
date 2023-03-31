//
//  AddCommentRequest.swift
//  forthgreen
//
//  Created by MACBOOK on 16/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

struct AddCommentRequest: Encodable {
    var postRef, comment: String?
    var commentRef: String?
    var tags: [tagsRequest]?
    
    init(postRef: String? = nil, comment: String? = nil, commentRef: String? = nil, tags: [tagsRequest]? = nil) {
        self.postRef = postRef
        self.comment = comment
        self.commentRef = commentRef
        self.tags = tags
    }
}

struct tagsRequest: Encodable {
    let id, name: String
    let type: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, type
    }
}
