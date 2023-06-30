//
//  NotificationDetailResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 29/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - NotificationDetailResponse
struct NotificationDetailResponse: Codable {
    let code: Int
    let message: String
    let data: [NotificationDetail]
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([NotificationDetail].self, forKey: .data) ?? []
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - NotificationDetail
struct NotificationDetail: Codable {
    let id: String
    let refType: Int
    var posts: Posts
    let follower: Follower

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case refType, posts, follower
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        refType = try values.decodeIfPresent(Int.self, forKey: .refType) ?? DocumentDefaultValues.Empty.int
        posts = try values.decodeIfPresent(Posts.self, forKey: .posts) ?? Posts()
        follower = try values.decodeIfPresent(Follower.self, forKey: .follower) ?? Follower()
    }
}

// MARK: - NotificationDetailResponse
struct PostDetailResponse: Codable {
    let code: Int
    let message: String
    let data: [PostDetail]
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([PostDetail].self, forKey: .data) ?? []
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - NotificationDetail
struct PostDetail: Codable {
    var id: String
    var posts: Posts

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case posts
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        posts = try values.decodeIfPresent(Posts.self, forKey: .posts) ?? Posts()
    }
    
    internal init() {
        self.id = DocumentDefaultValues.Empty.string
        self.posts = Posts()
    }
}

// MARK: - Posts
struct Posts: Codable {
    let id, text: String
    let type: Int
    let image: [String]
    var status, isLike: Bool
    var likes, comments: Int
    var comment: Comment
    let addedBy: AddedBy
    let createdOn: String
    var postTextLineCount: Int
    var isTextExpanded: Bool
    var thumbnail, video: String
    let tags: [TagModel]
    var videoWidth, videoHeight: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case text, type, image, status, isLike, likes, comments, comment, addedBy, createdOn
        case isTextExpanded, postTextLineCount, thumbnail, video, tags, videoWidth, videoHeight
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        text = try values.decodeIfPresent(String.self, forKey: .text) ?? DocumentDefaultValues.Empty.string
        type = try values.decodeIfPresent(Int.self, forKey: .type) ?? DocumentDefaultValues.Empty.int
        image = try values.decodeIfPresent([String].self, forKey: .image) ?? []
        status = try values.decodeIfPresent(Bool.self, forKey: .status) ?? DocumentDefaultValues.Empty.bool
        isLike = try values.decodeIfPresent(Bool.self, forKey: .isLike) ?? DocumentDefaultValues.Empty.bool
        likes = try values.decodeIfPresent(Int.self, forKey: .likes) ?? DocumentDefaultValues.Empty.int
        comments = try values.decodeIfPresent(Int.self, forKey: .comments) ?? DocumentDefaultValues.Empty.int
        comment = try values.decodeIfPresent(Comment.self, forKey: .comment) ?? Comment()
        addedBy = try values.decodeIfPresent(AddedBy.self, forKey: .addedBy) ?? AddedBy()
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        isTextExpanded = try values.decodeIfPresent(Bool.self, forKey: .isTextExpanded) ?? DocumentDefaultValues.Empty.bool
        postTextLineCount = try values.decodeIfPresent(Int.self, forKey: .postTextLineCount) ?? DocumentDefaultValues.Empty.int
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail) ?? DocumentDefaultValues.Empty.string
        video = try values.decodeIfPresent(String.self, forKey: .video) ?? DocumentDefaultValues.Empty.string
        tags = try values.decodeIfPresent([TagModel].self, forKey: .tags) ?? [TagModel]()
        videoWidth = try values.decodeIfPresent(Double.self, forKey: .videoWidth) ?? DocumentDefaultValues.Empty.double
        videoHeight = try values.decodeIfPresent(Double.self, forKey: .videoHeight) ?? DocumentDefaultValues.Empty.double
    }
    
    internal init() {
        self.id = DocumentDefaultValues.Empty.string
        self.text = DocumentDefaultValues.Empty.string
        self.type = DocumentDefaultValues.Empty.int
        self.image = []
        self.status = DocumentDefaultValues.Empty.bool
        self.isLike = DocumentDefaultValues.Empty.bool
        self.likes = DocumentDefaultValues.Empty.int
        self.comments = DocumentDefaultValues.Empty.int
        self.comment = Comment()
        self.addedBy = AddedBy()
        self.createdOn = DocumentDefaultValues.Empty.string
        self.isTextExpanded = DocumentDefaultValues.Empty.bool
        self.postTextLineCount = DocumentDefaultValues.Empty.int
        self.thumbnail = DocumentDefaultValues.Empty.string
        self.video = DocumentDefaultValues.Empty.string
        self.tags = [TagModel]()
        self.videoWidth = DocumentDefaultValues.Empty.double
        self.videoHeight = DocumentDefaultValues.Empty.double
    }
}

// MARK: - Comment
struct Comment: Codable {
    let id, comment: String
    var status, isLike: Bool
    var likes: Int
    var replies: Int
    let addedBy: AddedBy
    let createdOn: String
    var reply: Reply
    var postTextLineCount: Int
    var isTextExpanded: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case comment, status, isLike, likes, replies, addedBy, createdOn, reply
        case postTextLineCount, isTextExpanded
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        comment = try values.decodeIfPresent(String.self, forKey: .comment) ?? DocumentDefaultValues.Empty.string
        status = try values.decodeIfPresent(Bool.self, forKey: .status) ?? DocumentDefaultValues.Empty.bool
        isLike = try values.decodeIfPresent(Bool.self, forKey: .isLike) ?? DocumentDefaultValues.Empty.bool
        likes = try values.decodeIfPresent(Int.self, forKey: .likes) ?? DocumentDefaultValues.Empty.int
        replies = try values.decodeIfPresent(Int.self, forKey: .replies) ?? DocumentDefaultValues.Empty.int
        reply = try values.decodeIfPresent(Reply.self, forKey: .reply) ?? Reply()
        addedBy = try values.decodeIfPresent(AddedBy.self, forKey: .addedBy) ?? AddedBy()
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        postTextLineCount = try values.decodeIfPresent(Int.self, forKey: .postTextLineCount) ?? DocumentDefaultValues.Empty.int
        isTextExpanded = try values.decodeIfPresent(Bool.self, forKey: .isTextExpanded) ?? DocumentDefaultValues.Empty.bool
    }

    internal init() {
        self.id = DocumentDefaultValues.Empty.string
        self.comment = DocumentDefaultValues.Empty.string
        self.status = DocumentDefaultValues.Empty.bool
        self.isLike = DocumentDefaultValues.Empty.bool
        self.likes = DocumentDefaultValues.Empty.int
        self.replies = DocumentDefaultValues.Empty.int
        self.addedBy = AddedBy()
        self.createdOn = DocumentDefaultValues.Empty.string
        self.reply = Reply()
        self.postTextLineCount = DocumentDefaultValues.Empty.int
        self.isTextExpanded = DocumentDefaultValues.Empty.bool
    }
}

// MARK: - Reply
struct Reply: Codable {
    var id, comment: String
    var status, isLike: Bool
    var likes: Int
    let addedBy: AddedBy
    let createdOn: String
    var postTextLineCount: Int
    var isTextExpanded: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case comment, status, isLike, likes, addedBy, createdOn, postTextLineCount
        case isTextExpanded
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        comment = try values.decodeIfPresent(String.self, forKey: .comment) ?? DocumentDefaultValues.Empty.string
        status = try values.decodeIfPresent(Bool.self, forKey: .status) ?? DocumentDefaultValues.Empty.bool
        isLike = try values.decodeIfPresent(Bool.self, forKey: .isLike) ?? DocumentDefaultValues.Empty.bool
        likes = try values.decodeIfPresent(Int.self, forKey: .likes) ?? DocumentDefaultValues.Empty.int
        addedBy = try values.decodeIfPresent(AddedBy.self, forKey: .addedBy) ?? AddedBy()
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        postTextLineCount = try values.decodeIfPresent(Int.self, forKey: .postTextLineCount) ?? DocumentDefaultValues.Empty.int
        isTextExpanded = try values.decodeIfPresent(Bool.self, forKey: .isTextExpanded) ?? DocumentDefaultValues.Empty.bool
    }

    internal init() {
        self.id = DocumentDefaultValues.Empty.string
        self.comment = DocumentDefaultValues.Empty.string
        self.status = DocumentDefaultValues.Empty.bool
        self.isLike = DocumentDefaultValues.Empty.bool
        self.likes = DocumentDefaultValues.Empty.int
        self.addedBy = AddedBy()
        self.createdOn = DocumentDefaultValues.Empty.string
        self.postTextLineCount = DocumentDefaultValues.Empty.int
        self.isTextExpanded = DocumentDefaultValues.Empty.bool
    }
}

// MARK: - Follower
struct Follower: Codable {
    let id, firstName, lastName, image: String
    let isFollow: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName, lastName, image, isFollow
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? DocumentDefaultValues.Empty.string
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? DocumentDefaultValues.Empty.string
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? DocumentDefaultValues.Empty.string
        isFollow = try values.decodeIfPresent(Bool.self, forKey: .isFollow) ?? DocumentDefaultValues.Empty.bool
    }
    
    internal init() {
        self.id = DocumentDefaultValues.Empty.string
        self.firstName = DocumentDefaultValues.Empty.string
        self.lastName = DocumentDefaultValues.Empty.string
        self.image = DocumentDefaultValues.Empty.string
        self.isFollow = DocumentDefaultValues.Empty.bool
    }
}
