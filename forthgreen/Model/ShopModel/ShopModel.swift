//
//  ShopModel.swift
//  forthgreen
//
//  Created by ARIS Pvt Ltd on 31/05/23.
//  Copyright © 2023 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - ShopObject
struct ShopObject: Codable {
    let code: Int?
    let message: String?
    let data: [ShopData]?
    let page: Int?
    let limit, size: Int?
    let hasMore: Bool?
    let format, timestamp: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
        case data, page
        case limit, size
        case hasMore
        case format, timestamp
    }
    
    init()  {
        code =  DocumentDefaultValues.Empty.int
        data = []
        message = DocumentDefaultValues.Empty.string
        page = DocumentDefaultValues.Empty.int
        limit = DocumentDefaultValues.Empty.int
        size = DocumentDefaultValues.Empty.int
        hasMore = DocumentDefaultValues.Empty.bool
        format = DocumentDefaultValues.Empty.string
        timestamp = DocumentDefaultValues.Empty.string
    }
}

// MARK: - Datum
struct ShopData: Codable {
    let id, name, brandName: String?
    let brandId: String?
    let brandlogo, brandcoverImage: String?
    let images: [String]?
    let priceDecimal: Double?
    let currency, price: String?
    let gender, category, subCategory: Int?
    let createdOn: String?
    var isBookmark: Bool?
    let topDate, sortingDate: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case brandId = "brandRef"
        case name, brandName, images, priceDecimal, currency, price, gender, category, subCategory, createdOn, isBookmark, topDate, sortingDate
        case brandlogo = "logo"
        case brandcoverImage = "coverImage"
    }
    
    init()  {
        id = DocumentDefaultValues.Empty.string
        images =  []
        name = DocumentDefaultValues.Empty.string
        brandName =  DocumentDefaultValues.Empty.string
        priceDecimal =  DocumentDefaultValues.Empty.double
        currency =  DocumentDefaultValues.Empty.string
        price =  DocumentDefaultValues.Empty.string
        gender =  DocumentDefaultValues.Empty.int
        category =  DocumentDefaultValues.Empty.int
        subCategory =  DocumentDefaultValues.Empty.int
        createdOn = DocumentDefaultValues.Empty.string
        isBookmark =  DocumentDefaultValues.Empty.bool
        topDate =  DocumentDefaultValues.Empty.string
        sortingDate =  DocumentDefaultValues.Empty.string
        brandlogo =  DocumentDefaultValues.Empty.string
        brandcoverImage =  DocumentDefaultValues.Empty.string
        brandId = DocumentDefaultValues.Empty.string
    }
    
}
