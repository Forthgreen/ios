//
//  BrandDetailResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 15/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - BrandDetailResponse
struct BrandDetailResponse: Codable {
    let format: String
    let data: BrandDetail?
    let code: Int
    let message: String
    let timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(BrandDetail.self, forKey: .data) ?? nil
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - BrandDetail
struct BrandDetail: Codable {
    let products: [Product]
    var isFollowing, isBookmark: Bool
    let id, about: String
    let length, followers, limit: Int
    let brandName, logo: String
    let website,coverImage: String
    let page: Int

    enum CodingKeys: String, CodingKey {
        case products, isFollowing
        case id = "_id"
        case followers, brandName, logo, about, website, length, limit, page, coverImage, isBookmark
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        products = try values.decodeIfPresent([Product].self, forKey: .products) ?? []
        isFollowing = try values.decodeIfPresent(Bool.self, forKey: .isFollowing) ?? DocumentDefaultValues.Empty.bool
        isBookmark = try values.decodeIfPresent(Bool.self, forKey: .isBookmark) ?? DocumentDefaultValues.Empty.bool
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        followers = try values.decodeIfPresent(Int.self, forKey: .followers) ?? DocumentDefaultValues.Empty.int
        brandName = try values.decodeIfPresent(String.self, forKey: .brandName) ?? DocumentDefaultValues.Empty.string
        logo = try values.decodeIfPresent(String.self, forKey: .logo) ?? DocumentDefaultValues.Empty.string
        about = try values.decodeIfPresent(String.self, forKey: .about) ?? DocumentDefaultValues.Empty.string
        website = try values.decodeIfPresent(String.self, forKey: .website) ?? DocumentDefaultValues.Empty.string
        length = try values.decodeIfPresent(Int.self, forKey: .length) ?? DocumentDefaultValues.Empty.int
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        coverImage = try values.decodeIfPresent(String.self, forKey: .coverImage) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - Product
struct Product: Codable {
    let category: Int
    let createdOn, updatedOn, link, id: String
    let price: String
    var deleted, isBookmark: Bool
    let images: [String]
    let v: Int
    let info, brandRef, name: String
    let currency: String

    enum CodingKeys: String, CodingKey {
        case category, createdOn, updatedOn, link
        case id = "_id"
        case price, deleted, images
        case v = "__v"
        case info, brandRef, name, currency, isBookmark
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        category = try values.decodeIfPresent(Int.self, forKey: .category) ?? DocumentDefaultValues.Empty.int
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
        link = try values.decodeIfPresent(String.self, forKey: .link) ?? DocumentDefaultValues.Empty.string
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        price = try values.decodeIfPresent(String.self, forKey: .price) ?? DocumentDefaultValues.Empty.string
        deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted) ?? DocumentDefaultValues.Empty.bool
        isBookmark = try values.decodeIfPresent(Bool.self, forKey: .isBookmark) ?? DocumentDefaultValues.Empty.bool
        images = try values.decodeIfPresent([String].self, forKey: .images) ?? []
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? DocumentDefaultValues.Empty.int
        info = try values.decodeIfPresent(String.self, forKey: .info) ?? DocumentDefaultValues.Empty.string
        brandRef = try values.decodeIfPresent(String.self, forKey: .brandRef) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        currency = try values.decodeIfPresent(String.self, forKey: .currency) ?? STATIC_LABELS.currencySymbol.rawValue
    }
}
