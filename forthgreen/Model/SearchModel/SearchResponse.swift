//
//  SearchResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 17/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - SearchResponse
struct SearchResponse: Codable {
    let code: Int
    let message: String
    let data: SearchData?
    let page, limit: Int
    let hasMore: Bool
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(SearchData.self, forKey: .data) ?? nil
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - SearchData
struct SearchData: Codable {
    var list: [List]
    let nextPageToken: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([List].self, forKey: .list) ?? []
        nextPageToken = try values.decodeIfPresent(String.self, forKey: .nextPageToken) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - List
struct List: Codable {
    let id: String
    let ownerName: String?
    let name: String
    let logo: String?
    let about: String?
    let website: String?
    let brand: BrandInfo?
    let info: String?
    let category: Int?
    let price, link: String?
    var images: [String]?
    let isProduct: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case ownerName, name, logo, about, website, brand, info, category, price, link, images, isProduct
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        ownerName = try values.decodeIfPresent(String.self, forKey: .ownerName) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        logo = try values.decodeIfPresent(String.self, forKey: .logo) ?? DocumentDefaultValues.Empty.string
        about = try values.decodeIfPresent(String.self, forKey: .about) ?? DocumentDefaultValues.Empty.string
        website = try values.decodeIfPresent(String.self, forKey: .website) ?? DocumentDefaultValues.Empty.string
        brand = try values.decodeIfPresent(BrandInfo.self, forKey: .brand) ?? nil
        info = try values.decodeIfPresent(String.self, forKey: .info) ?? DocumentDefaultValues.Empty.string
        category = try values.decodeIfPresent(Int.self, forKey: .category) ?? DocumentDefaultValues.Empty.int
        price = try values.decodeIfPresent(String.self, forKey: .price) ?? DocumentDefaultValues.Empty.string
        link = try values.decodeIfPresent(String.self, forKey: .link) ?? DocumentDefaultValues.Empty.string
        images = try values.decodeIfPresent([String].self, forKey: .images) ?? []
        isProduct = try values.decodeIfPresent(Bool.self, forKey: .isProduct) ?? DocumentDefaultValues.Empty.bool
    }
}

// MARK: - BrandInfo
struct BrandInfo: Codable {
    let id, ownerName, name: String
    let logo: String?
    let about: String?
    let website: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case ownerName, name, logo, about, website
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        ownerName = try values.decodeIfPresent(String.self, forKey: .ownerName) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        logo = try values.decodeIfPresent(String.self, forKey: .logo) ?? DocumentDefaultValues.Empty.string
        about = try values.decodeIfPresent(String.self, forKey: .about) ?? DocumentDefaultValues.Empty.string
        website = try values.decodeIfPresent(String.self, forKey: .website) ?? DocumentDefaultValues.Empty.string
    }
}
