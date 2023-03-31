//
//  FollowingProductListResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 17/01/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - FollowingProductListResponse
struct FollowingProductListResponse: Codable {
    let code: Int
    let message: String
    let data: [ProductList]
    let page, limit, size: Int
    let hasMore: Bool
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([ProductList].self, forKey: .data) ?? []
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - FollowingProductList
struct FollowingProductList: Codable {
    let id, productRef, userRef, createdOn: String
    let updatedOn: String
    let v: Int
    let product: FollowingProductInfo?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case productRef, userRef, createdOn, updatedOn
        case v = "__v"
        case product
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        productRef = try values.decodeIfPresent(String.self, forKey: .productRef) ?? DocumentDefaultValues.Empty.string
        userRef = try values.decodeIfPresent(String.self, forKey: .userRef) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? DocumentDefaultValues.Empty.int
        product = try values.decodeIfPresent(FollowingProductInfo.self, forKey: .product) ?? nil
    }
}

// MARK: - FollowingProductInfo
struct FollowingProductInfo: Codable {
    let id: String
    let images, keywords: [String]
    let uploadedToProfile, deleted, blocked: Bool
    let brandRef, name, info: String
    let category: Int
    let price, link, createdOn, updatedOn: String
    let v: Int
    let brandDetails: BrandDetails?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case images, keywords, uploadedToProfile, deleted, blocked, brandRef, name, info, category, price, link, createdOn, updatedOn
        case v = "__v"
        case brandDetails
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        images = try values.decodeIfPresent([String].self, forKey: .images) ?? []
        keywords = try values.decodeIfPresent([String].self, forKey: .keywords) ?? []
        uploadedToProfile = try values.decodeIfPresent(Bool.self, forKey: .uploadedToProfile) ?? DocumentDefaultValues.Empty.bool
        deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted) ?? DocumentDefaultValues.Empty.bool
        blocked = try values.decodeIfPresent(Bool.self, forKey: .blocked) ?? DocumentDefaultValues.Empty.bool
        brandRef = try values.decodeIfPresent(String.self, forKey: .brandRef) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        info = try values.decodeIfPresent(String.self, forKey: .info) ?? DocumentDefaultValues.Empty.string
        category = try values.decodeIfPresent(Int.self, forKey: .category) ?? DocumentDefaultValues.Empty.int
        price = try values.decodeIfPresent(String.self, forKey: .price) ?? DocumentDefaultValues.Empty.string
        link = try values.decodeIfPresent(String.self, forKey: .link) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? DocumentDefaultValues.Empty.int
        brandDetails = try values.decodeIfPresent(BrandDetails.self, forKey: .brandDetails) ?? nil
    }
}

// MARK: - BrandDetails
struct BrandDetails: Codable {
    let id, name, email, mobileCode: String
    let mobileNumber, companyName, coverImage, logo: String
    let about, website: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, email, mobileCode, mobileNumber, companyName, coverImage, logo, about, website
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? DocumentDefaultValues.Empty.string
        mobileCode = try values.decodeIfPresent(String.self, forKey: .mobileCode) ?? DocumentDefaultValues.Empty.string
        mobileNumber = try values.decodeIfPresent(String.self, forKey: .mobileNumber) ?? DocumentDefaultValues.Empty.string
        companyName = try values.decodeIfPresent(String.self, forKey: .companyName) ?? DocumentDefaultValues.Empty.string
        coverImage = try values.decodeIfPresent(String.self, forKey: .coverImage) ?? DocumentDefaultValues.Empty.string
        logo = try values.decodeIfPresent(String.self, forKey: .logo) ?? DocumentDefaultValues.Empty.string
        about = try values.decodeIfPresent(String.self, forKey: .about) ?? DocumentDefaultValues.Empty.string
        website = try values.decodeIfPresent(String.self, forKey: .website) ?? DocumentDefaultValues.Empty.string
    }
}
