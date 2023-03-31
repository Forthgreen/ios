//
//  LikePostResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 18/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - LikePostResponse
struct LikePostResponse: Codable {
    let code: Int
    let message: String
    let data: LikePostInfo
    let timestamp, format: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(LikePostInfo.self, forKey: .data) ?? LikePostInfo()
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - LikePostInfo
struct LikePostInfo: Codable {
    let status: Bool
    let id, ref: String
    let v: Int
    let updatedOn, createdOn, userRef: String
    let type: Int

    enum CodingKeys: String, CodingKey {
        case status
        case id = "_id"
        case ref
        case v = "__v"
        case updatedOn, createdOn, userRef, type
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status) ?? DocumentDefaultValues.Empty.bool
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        ref = try values.decodeIfPresent(String.self, forKey: .ref) ?? DocumentDefaultValues.Empty.string
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? DocumentDefaultValues.Empty.int
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        userRef = try values.decodeIfPresent(String.self, forKey: .userRef) ?? DocumentDefaultValues.Empty.string
        type = try values.decodeIfPresent(Int.self, forKey: .type) ?? DocumentDefaultValues.Empty.int
    }
    
    internal init() {
        self.status = DocumentDefaultValues.Empty.bool
        self.id = DocumentDefaultValues.Empty.string
        self.ref = DocumentDefaultValues.Empty.string
        self.v = DocumentDefaultValues.Empty.int
        self.updatedOn = DocumentDefaultValues.Empty.string
        self.createdOn = DocumentDefaultValues.Empty.string
        self.userRef = DocumentDefaultValues.Empty.string
        self.type = DocumentDefaultValues.Empty.int
    }
}
