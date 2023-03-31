//
//  MyBrandResponse.swift
//  forthgreen
//
//  Created by Rohit Saini on 16/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

struct MyBrandResponse: Codable{
    let code: Int
    let message: String
    let data: [Brand]
    let page, limit, size: Int
    let hasMore: Bool
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([Brand].self, forKey: .data) ?? []
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

struct Brand: Codable {
    let id, companyName,coverImage,logo,brandName, about: String
    let count: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case companyName, count,coverImage,logo,brandName, about
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        companyName = try values.decodeIfPresent(String.self, forKey: .companyName) ?? DocumentDefaultValues.Empty.string
        coverImage = try values.decodeIfPresent(String.self, forKey: .coverImage) ?? DocumentDefaultValues.Empty.string
        brandName = try values.decodeIfPresent(String.self, forKey: .brandName) ?? DocumentDefaultValues.Empty.string
        logo = try values.decodeIfPresent(String.self, forKey: .logo) ?? DocumentDefaultValues.Empty.string
        count = try values.decodeIfPresent(Int.self, forKey: .count) ?? DocumentDefaultValues.Empty.int
        about = try values.decodeIfPresent(String.self, forKey: .about) ?? DocumentDefaultValues.Empty.string
    }
}

