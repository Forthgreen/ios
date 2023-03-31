//
//  BookmarkResponse.swift
//  forthgreen
//
//  Created by iMac on 10/23/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct BookmarkResponse: Codable {
    let code: Int
    let message: String
    let data: BookmarkModel?
    let timestamp, format: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(BookmarkModel.self, forKey: .data) ?? nil
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - DataClass
struct BookmarkModel: Codable {
    let status: Bool
    let id, ref: String
    let refType, v: Int
    let updatedOn, userRef, createdOn: String

    enum CodingKeys: String, CodingKey {
        case status
        case id = "_id"
        case ref, refType
        case v = "__v"
        case updatedOn, userRef, createdOn
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        ref = try values.decodeIfPresent(String.self, forKey: .ref) ?? DocumentDefaultValues.Empty.string
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
        userRef = try values.decodeIfPresent(String.self, forKey: .userRef) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        refType = try values.decodeIfPresent(Int.self, forKey: .refType) ?? DocumentDefaultValues.Empty.int
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? DocumentDefaultValues.Empty.int
        status = try values.decodeIfPresent(Bool.self, forKey: .status) ?? DocumentDefaultValues.Empty.bool
    }
    
    init() {
        id = DocumentDefaultValues.Empty.string
        ref = DocumentDefaultValues.Empty.string
        updatedOn = DocumentDefaultValues.Empty.string
        userRef = DocumentDefaultValues.Empty.string
        createdOn = DocumentDefaultValues.Empty.string
        refType = DocumentDefaultValues.Empty.int
        v = DocumentDefaultValues.Empty.int
        status = DocumentDefaultValues.Empty.bool
    }
    
}
