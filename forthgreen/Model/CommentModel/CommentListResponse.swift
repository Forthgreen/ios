//
//  CommentListResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 20/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - CommentListResponse
struct CommentListResponse: Codable {
    let code: Int
    let message: String
    let data: [CommentList]
    let page, limit, size: Int
    let hasMore: Bool
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([CommentList].self, forKey: .data) ?? []
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - CommentList
struct CommentList: Codable {
    let id, comment: String
    var reply, likes: Int
    var isLike: Bool
    let addedBy: AddedBy
    let createdOn: String
    let status: Bool
    let postRef: String
    let updatedOn, userRef, commentRef: String
    var postTextLineCount: Int
    var isTextExpanded: Bool
    let tags: [TagModel]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case comment, reply, likes, isLike, addedBy, createdOn, status, postRef
        case updatedOn, userRef, commentRef, postTextLineCount, isTextExpanded, tags
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        comment = try values.decodeIfPresent(String.self, forKey: .comment) ?? DocumentDefaultValues.Empty.string
        reply = try values.decodeIfPresent(Int.self, forKey: .reply) ?? DocumentDefaultValues.Empty.int
        likes = try values.decodeIfPresent(Int.self, forKey: .likes) ?? DocumentDefaultValues.Empty.int
        isLike = try values.decodeIfPresent(Bool.self, forKey: .isLike) ?? DocumentDefaultValues.Empty.bool
        addedBy = try values.decodeIfPresent(AddedBy.self, forKey: .addedBy) ?? AddedBy()
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
        userRef = try values.decodeIfPresent(String.self, forKey: .userRef) ?? DocumentDefaultValues.Empty.string
        commentRef = try values.decodeIfPresent(String.self, forKey: .commentRef) ?? DocumentDefaultValues.Empty.string
        status = try values.decodeIfPresent(Bool.self, forKey: .status) ?? DocumentDefaultValues.Empty.bool
        postRef = try values.decodeIfPresent(String.self, forKey: .postRef) ?? DocumentDefaultValues.Empty.string
        postTextLineCount = try values.decodeIfPresent(Int.self, forKey: .postTextLineCount) ?? DocumentDefaultValues.Empty.int
        isTextExpanded = try values.decodeIfPresent(Bool.self, forKey: .isTextExpanded) ?? DocumentDefaultValues.Empty.bool
        tags = try values.decodeIfPresent([TagModel].self, forKey: .tags) ?? []
    }
    
    init() {
        self.id = DocumentDefaultValues.Empty.string
        self.comment = DocumentDefaultValues.Empty.string
        self.reply = DocumentDefaultValues.Empty.int
        self.likes = DocumentDefaultValues.Empty.int
        self.isLike = DocumentDefaultValues.Empty.bool
        self.addedBy = AddedBy()
        self.createdOn = DocumentDefaultValues.Empty.string
        self.status = DocumentDefaultValues.Empty.bool
        self.postRef = DocumentDefaultValues.Empty.string
        self.updatedOn = DocumentDefaultValues.Empty.string
        self.userRef = DocumentDefaultValues.Empty.string
        self.commentRef = DocumentDefaultValues.Empty.string
        self.postTextLineCount = DocumentDefaultValues.Empty.int
        self.isTextExpanded = DocumentDefaultValues.Empty.bool
        self.tags = []
    }
}


// MARK: - Tag
struct TagModel: Codable {
    let id, name: String
    let type: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, type
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        type = try values.decodeIfPresent(Int.self, forKey: .type) ?? DocumentDefaultValues.Empty.int
    }
}
