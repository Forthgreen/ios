//
//  ProfileInfoResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 23/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - ProfileInfoResponse
struct ProfileInfoResponse: Codable {
    let hasMore: Bool
    let format: String
    let data: ProfileInfo
    let code: Int
    let message: String
    let limit, page: Int
    let timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(ProfileInfo.self, forKey: .data) ?? ProfileInfo()
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - ProfileInfo
struct ProfileInfo: Codable {
    let lastName, firstName, createdOn: String
    var posts: [SocialFeed]
    let id: String
    var followings: Int
    let bio, image, username: String
    var followers: Int
    let email: String
    let gender: Int
    var isFollow, dummyUser: Bool
    var isBlock: Bool
    var isSenderBlock: [IsSenderBlock]

    enum CodingKeys: String, CodingKey {
        case lastName, firstName, createdOn, posts
        case id = "_id"
        case followings, bio, image, username, followers, email, gender, isFollow, dummyUser
        case isBlock
        case isSenderBlock
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? DocumentDefaultValues.Empty.string
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        posts = try values.decodeIfPresent([SocialFeed].self, forKey: .posts) ?? []
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        followings = try values.decodeIfPresent(Int.self, forKey: .followings) ?? DocumentDefaultValues.Empty.int
        bio = try values.decodeIfPresent(String.self, forKey: .bio) ?? DocumentDefaultValues.Empty.string
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? DocumentDefaultValues.Empty.string
        username = try values.decodeIfPresent(String.self, forKey: .username) ?? DocumentDefaultValues.Empty.string
        followers = try values.decodeIfPresent(Int.self, forKey: .followers) ?? DocumentDefaultValues.Empty.int
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? DocumentDefaultValues.Empty.string
        gender = try values.decodeIfPresent(Int.self, forKey: .gender) ?? DocumentDefaultValues.Empty.int
        isFollow = try values.decodeIfPresent(Bool.self, forKey: .isFollow) ?? DocumentDefaultValues.Empty.bool
        dummyUser = try values.decodeIfPresent(Bool.self, forKey: .dummyUser) ?? DocumentDefaultValues.Empty.bool
        isBlock = try values.decodeIfPresent(Bool.self, forKey: .isBlock) ?? DocumentDefaultValues.Empty.bool
        isSenderBlock = try values.decodeIfPresent([IsSenderBlock].self, forKey: .isSenderBlock) ?? []
    }
    
    internal init() {
        self.lastName = DocumentDefaultValues.Empty.string
        self.firstName = DocumentDefaultValues.Empty.string
        self.createdOn = DocumentDefaultValues.Empty.string
        self.posts = []
        self.id = DocumentDefaultValues.Empty.string
        self.followings = DocumentDefaultValues.Empty.int
        self.bio = DocumentDefaultValues.Empty.string
        self.image = DocumentDefaultValues.Empty.string
        self.username = DocumentDefaultValues.Empty.string
        self.followers = DocumentDefaultValues.Empty.int
        self.email = DocumentDefaultValues.Empty.string
        self.gender = DocumentDefaultValues.Empty.int
        self.isFollow = DocumentDefaultValues.Empty.bool
        self.dummyUser = DocumentDefaultValues.Empty.bool
        self.isBlock = DocumentDefaultValues.Empty.bool
        self.isSenderBlock = []
    }
}

// MARK: - IsSenderBlock
struct IsSenderBlock: Codable {
    var blockingRef, createdOn, id, userRef: String
    var v: Int
    var updatedOn: String

    enum CodingKeys: String, CodingKey {
        case blockingRef, createdOn
        case id = "_id"
        case userRef
        case v = "__v"
        case updatedOn
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        blockingRef = try values.decodeIfPresent(String.self, forKey: .blockingRef) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        userRef = try values.decodeIfPresent(String.self, forKey: .userRef) ?? DocumentDefaultValues.Empty.string
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? DocumentDefaultValues.Empty.int
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
    }
    
    internal init() {
        self.id = DocumentDefaultValues.Empty.string
        self.blockingRef = DocumentDefaultValues.Empty.string
        self.createdOn = DocumentDefaultValues.Empty.string
        self.v = DocumentDefaultValues.Empty.int
        self.userRef = DocumentDefaultValues.Empty.string
        self.updatedOn = DocumentDefaultValues.Empty.string
    }
}

// MARK: - Post
struct Post: Codable {
    let id: String
    var status, isLike: Bool
    var comments: Int
    let image: [String]
    let text, createdOn: String
    var type, likes: Int
    let updatedOn: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status, comments, image, text, createdOn, type, likes, updatedOn, isLike
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        status = try values.decodeIfPresent(Bool.self, forKey: .status) ?? DocumentDefaultValues.Empty.bool
        isLike = try values.decodeIfPresent(Bool.self, forKey: .isLike) ?? DocumentDefaultValues.Empty.bool
        comments = try values.decodeIfPresent(Int.self, forKey: .comments) ?? DocumentDefaultValues.Empty.int
        image = try values.decodeIfPresent([String].self, forKey: .image) ?? []
        text = try values.decodeIfPresent(String.self, forKey: .text) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        type = try values.decodeIfPresent(Int.self, forKey: .type) ?? DocumentDefaultValues.Empty.int
        likes = try values.decodeIfPresent(Int.self, forKey: .likes) ?? DocumentDefaultValues.Empty.int
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
    }
}


// MARK: - LOCContactsModel
struct LOCBlockResultModel: Codable {
    var code: Int?
    var message, format, timestamp: String?
}
