//
//  NotificationResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 26/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - NotificationResponse
struct NotificationResponse: Codable {
    let code: Int
    let message: String
    let data: [NotificationList]
    let page, limit, size: Int
    let hasMore: Bool
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([NotificationList].self, forKey: .data) ?? []
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - NotificationList
struct NotificationList: Codable {
    let id, message: String
    var seen: Bool
    let ref: String
    let refType: Int
    let createdOn, username, name, image: String
    let userid: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case message, seen, ref, refType, createdOn, username, name, image
        case userid
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        seen = try values.decodeIfPresent(Bool.self, forKey: .seen) ?? DocumentDefaultValues.Empty.bool
        ref = try values.decodeIfPresent(String.self, forKey: .ref) ?? DocumentDefaultValues.Empty.string
        refType = try values.decodeIfPresent(Int.self, forKey: .refType) ?? DocumentDefaultValues.Empty.int
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        username = try values.decodeIfPresent(String.self, forKey: .username) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? DocumentDefaultValues.Empty.string
        userid = try values.decodeIfPresent(String.self, forKey: .userid) ?? DocumentDefaultValues.Empty.string
    }
}
