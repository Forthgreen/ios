//
//  LikeListResponse.swift
//  forthgreen
//
//  Created by iMac on 7/26/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct LikeListResponse: Codable {
    let hasMore: Bool
    let format: String
    let data: [UserLikeInfo]
    let code: Int
    let message: String
    let limit, size, page: Int
    let timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([UserLikeInfo].self, forKey: .data) ?? []
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
    }
}

// MARK: - Datum
struct UserLikeInfo: Codable {
    let firstName, lastName, id, image: String
    var isFollowing, dummyUser: Bool

    enum CodingKeys: String, CodingKey {
        case firstName, lastName
        case id = "_id"
        case image, isFollowing, dummyUser
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? DocumentDefaultValues.Empty.string
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? DocumentDefaultValues.Empty.string
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? DocumentDefaultValues.Empty.string
        isFollowing = try values.decodeIfPresent(Bool.self, forKey: .isFollowing) ?? DocumentDefaultValues.Empty.bool
        dummyUser = try values.decodeIfPresent(Bool.self, forKey: .dummyUser) ?? DocumentDefaultValues.Empty.bool
    }
    
    init() {
        id = DocumentDefaultValues.Empty.string
        image = DocumentDefaultValues.Empty.string
        firstName = DocumentDefaultValues.Empty.string
        lastName = DocumentDefaultValues.Empty.string
        isFollowing = DocumentDefaultValues.Empty.bool
        dummyUser = DocumentDefaultValues.Empty.bool
    }
    
}
