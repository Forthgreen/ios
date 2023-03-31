//
//  SearchUserResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 25/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - SearchUserResponse
struct SearchUserResponse: Codable {
    let code: Int
    let message: String
    let data: [SearchedUserList]
    let page, limit, size: Int
    let hasMore: Bool
    let timestamp, format: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([SearchedUserList].self, forKey: .data) ?? []
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
    }
}

// MARK: - SearchedUserList
struct SearchedUserList: Codable {
    let email, firstName, id, lastName: String
    let image: String
    var isFollow, dummyUser: Bool
    let username, bio: String

    enum CodingKeys: String, CodingKey {
        case email, firstName, bio
        case id = "_id"
        case lastName, image, isFollow, username, dummyUser
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isFollow = try values.decodeIfPresent(Bool.self, forKey: .isFollow) ?? DocumentDefaultValues.Empty.bool
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? DocumentDefaultValues.Empty.string
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? DocumentDefaultValues.Empty.string
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? DocumentDefaultValues.Empty.string
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? DocumentDefaultValues.Empty.string
        bio = try values.decodeIfPresent(String.self, forKey: .bio) ?? DocumentDefaultValues.Empty.string
        username = try values.decodeIfPresent(String.self, forKey: .username) ?? DocumentDefaultValues.Empty.string
        dummyUser = try values.decodeIfPresent(Bool.self, forKey: .dummyUser) ?? DocumentDefaultValues.Empty.bool
    }
}
