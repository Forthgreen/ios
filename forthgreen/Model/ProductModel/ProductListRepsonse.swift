//
//  ProductListRepsonse.swift
//  forthgreen
//
//  Created by MACBOOK on 14/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

struct ProductListResponse: Codable {
    let hasMore: Bool
    let format: String
    let data: [ProductList]
    let code: Int
    let message: String
    let limit, size, page: Int
    let timestamp: String
    
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

// MARK: - ProductList
struct ProductList: Codable {
    let id, name, brandRef: String
    let images: [String]
    let brandName: String
    let category: Int
    let price, createdOn : String
    let currency: String
    var isBookmark: Bool
//    let priceDecimal: PriceDecimal

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case images, category, price, createdOn, brandName, name, currency, isBookmark, brandRef //, priceDecimal
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        images = try values.decodeIfPresent([String].self, forKey: .images) ?? []
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        brandName = try values.decodeIfPresent(String.self, forKey: .brandName) ?? DocumentDefaultValues.Empty.string
        price = try values.decodeIfPresent(String.self, forKey: .price) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        category = try values.decodeIfPresent(Int.self, forKey: .category) ?? DocumentDefaultValues.Empty.int
        currency = try values.decodeIfPresent(String.self, forKey: .currency) ?? STATIC_LABELS.currencySymbol.rawValue
        isBookmark = try values.decodeIfPresent(Bool.self, forKey: .isBookmark) ?? DocumentDefaultValues.Empty.bool
        
        brandRef = try values.decodeIfPresent(String.self, forKey: .brandRef) ?? DocumentDefaultValues.Empty.string
    }
}


// MARK: - Welcome
struct ProductHomeResponse: Codable {
    let code: Int
    let message: String
    var data: [ProductCategoryList]
    let timestamp, format: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([ProductCategoryList].self, forKey: .data) ?? []
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - Datum
struct ProductCategoryList: Codable {
    var id: Int
    var products: [ProductList]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case products
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? DocumentDefaultValues.Empty.int
        products = try values.decodeIfPresent([ProductList].self, forKey: .products) ?? []
    }
    
    init() {
        id = DocumentDefaultValues.Empty.int
        products = []
    }
    
}
