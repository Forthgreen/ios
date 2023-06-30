//
//  SocialFeedResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 13/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - SocialFeedResponse
struct SocialFeedResponse: Codable {
    let hasMore: Bool
    let format: String
    let data: [SocialFeed]
    let code: Int
    let message: String
    let limit, page, size: Int
    let timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([SocialFeed].self, forKey: .data) ?? []
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - SocialFeed
struct SocialFeed: Codable {
    let id, username: String
    let comments: Int
    var isLike, isFollow: Bool
    let image: [String]
    let text: String
    let createdOn: String
    var likes: Int
    let addedBy: AddedBy
    let type: Int?
    let bio, email, name: String
    var postTextLineCount: Int
    var isTextExpanded: Bool
    let status: Bool
    var tags: [TagModel]
    let whoLiked: [AddedBy]
    var thumbnail, video: String
    var videoWidth, videoHeight: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case comments, isLike, image, text, createdOn, likes, addedBy, type, bio, email, name, postTextLineCount, isTextExpanded, isFollow, username, status, tags, whoLiked, thumbnail, video, videoWidth, videoHeight
    }
    
     init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        comments = try values.decodeIfPresent(Int.self, forKey: .comments) ?? DocumentDefaultValues.Empty.int
        isLike = try values.decodeIfPresent(Bool.self, forKey: .isLike) ?? DocumentDefaultValues.Empty.bool
        image = try values.decodeIfPresent([String].self, forKey: .image) ?? []
        text = try values.decodeIfPresent(String.self, forKey: .text) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        likes = try values.decodeIfPresent(Int.self, forKey: .likes) ?? DocumentDefaultValues.Empty.int
        addedBy = try values.decodeIfPresent(AddedBy.self, forKey: .addedBy) ?? AddedBy()
        type = try values.decodeIfPresent(Int.self, forKey: .type) ?? DocumentDefaultValues.Empty.int
        bio = try values.decodeIfPresent(String.self, forKey: .bio) ?? DocumentDefaultValues.Empty.string
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        postTextLineCount = try values.decodeIfPresent(Int.self, forKey: .postTextLineCount) ?? DocumentDefaultValues.Empty.int
        isTextExpanded = try values.decodeIfPresent(Bool.self, forKey: .isTextExpanded) ?? DocumentDefaultValues.Empty.bool
        isFollow = try values.decodeIfPresent(Bool.self, forKey: .isFollow) ?? DocumentDefaultValues.Empty.bool
        username = try values.decodeIfPresent(String.self, forKey: .username) ?? DocumentDefaultValues.Empty.string
        status = try values.decodeIfPresent(Bool.self, forKey: .status) ?? DocumentDefaultValues.Empty.bool
        tags = try values.decodeIfPresent([TagModel].self, forKey: .tags) ?? []
        
        whoLiked = try values.decodeIfPresent([AddedBy].self, forKey: .whoLiked) ?? []
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail) ?? DocumentDefaultValues.Empty.string
        video = try values.decodeIfPresent(String.self, forKey: .video) ?? DocumentDefaultValues.Empty.string
        videoWidth = try values.decodeIfPresent(Double.self, forKey: .videoWidth) ?? DocumentDefaultValues.Empty.double
        videoHeight = try values.decodeIfPresent(Double.self, forKey: .videoHeight) ?? DocumentDefaultValues.Empty.double
    }
    
    internal init() {
        self.id = DocumentDefaultValues.Empty.string
        self.username = DocumentDefaultValues.Empty.string
        self.comments = DocumentDefaultValues.Empty.int
        self.isLike = DocumentDefaultValues.Empty.bool
        self.isFollow = DocumentDefaultValues.Empty.bool
        self.image = []
        self.text = DocumentDefaultValues.Empty.string
        self.createdOn = DocumentDefaultValues.Empty.string
        self.likes = DocumentDefaultValues.Empty.int
        self.addedBy = AddedBy()
        self.type = DocumentDefaultValues.Empty.int
        self.bio = DocumentDefaultValues.Empty.string
        self.email = DocumentDefaultValues.Empty.string
        self.name = DocumentDefaultValues.Empty.string
        self.postTextLineCount = DocumentDefaultValues.Empty.int
        self.isTextExpanded = DocumentDefaultValues.Empty.bool
        self.status = DocumentDefaultValues.Empty.bool
        self.tags = []
        self.whoLiked = []
        self.thumbnail = DocumentDefaultValues.Empty.string
        self.video = DocumentDefaultValues.Empty.string
        videoWidth = DocumentDefaultValues.Empty.double
        videoHeight = DocumentDefaultValues.Empty.double
    }
}

// MARK: - AddedBy
struct AddedBy: Codable {
    let firstName, lastName, id, image, username: String
    let dummyUser: Bool

    enum CodingKeys: String, CodingKey {
        case firstName, lastName
        case id = "_id"
        case image, username, dummyUser
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? DocumentDefaultValues.Empty.string
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? DocumentDefaultValues.Empty.string
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? DocumentDefaultValues.Empty.string
        username = try values.decodeIfPresent(String.self, forKey: .username) ?? DocumentDefaultValues.Empty.string
        dummyUser = try values.decodeIfPresent(Bool.self, forKey: .dummyUser) ?? DocumentDefaultValues.Empty.bool
    }
    
    internal init() {
        self.firstName = DocumentDefaultValues.Empty.string
        self.lastName = DocumentDefaultValues.Empty.string
        self.id = DocumentDefaultValues.Empty.string
        self.image = DocumentDefaultValues.Empty.string
        self.username = DocumentDefaultValues.Empty.string
        self.dummyUser = DocumentDefaultValues.Empty.bool
    }
}
