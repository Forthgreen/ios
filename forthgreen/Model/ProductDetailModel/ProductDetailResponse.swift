//
//  ProductDetailResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 16/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - ProductDetailResponse
struct ProductDetailResponse: Codable {
    let code: Int
    let message: String
    let data: ProductDetail?
    let page, limit, size: Int
    let hasMore: Bool
    let format, timestamp: String
    
    init(from deocder: Decoder) throws {
        let values = try deocder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(ProductDetail.self, forKey: .data) ?? nil
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - ProductDetail
struct ProductDetail: Codable {
    let id, name, price: String
    let images: [String]
    let link, info, brandName: String
    let coverImage,logo: String
    let totalReviews: Int
    let averageRating: Double
    let ratingAndReview: [RatingAndReview]
    let brandRef: String
    var isFollowed, isBookmark: Bool
    var similarProducts: [SimilarProduct]
    let currency: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, price, images, link, info, averageRating, totalReviews, ratingAndReview, brandName, coverImage,logo, brandRef, isFollowed, similarProducts, currency, isBookmark
    }
    init(){
        self.id = DocumentDefaultValues.Empty.string
        self.name = DocumentDefaultValues.Empty.string
        self.price = DocumentDefaultValues.Empty.string
        self.images = []
        self.link = DocumentDefaultValues.Empty.string
        self.info = DocumentDefaultValues.Empty.string
        self.brandName = DocumentDefaultValues.Empty.string
        self.averageRating = DocumentDefaultValues.Empty.double
        self.totalReviews = DocumentDefaultValues.Empty.int
        self.ratingAndReview = []
        self.coverImage = DocumentDefaultValues.Empty.string
        self.logo = DocumentDefaultValues.Empty.string
        self.brandRef = DocumentDefaultValues.Empty.string
        self.isFollowed = DocumentDefaultValues.Empty.bool
        self.similarProducts = []
        self.currency = DocumentDefaultValues.Empty.string
        self.isBookmark = DocumentDefaultValues.Empty.bool
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        price = try values.decodeIfPresent(String.self, forKey: .price) ?? DocumentDefaultValues.Empty.string
        images = try values.decodeIfPresent([String].self, forKey: .images) ?? []
        link = try values.decodeIfPresent(String.self, forKey: .link) ?? DocumentDefaultValues.Empty.string
        info = try values.decodeIfPresent(String.self, forKey: .info) ?? DocumentDefaultValues.Empty.string
        averageRating = try values.decodeIfPresent(Double.self, forKey: .averageRating) ?? DocumentDefaultValues.Empty.double
        totalReviews = try values.decodeIfPresent(Int.self, forKey: .totalReviews) ?? DocumentDefaultValues.Empty.int
        ratingAndReview = try values.decodeIfPresent([RatingAndReview].self, forKey: .ratingAndReview) ?? []
        brandName = try values.decodeIfPresent(String.self, forKey: .brandName) ?? DocumentDefaultValues.Empty.string
        coverImage = try values.decodeIfPresent(String.self, forKey: .coverImage) ?? DocumentDefaultValues.Empty.string
        logo = try values.decodeIfPresent(String.self, forKey: .logo) ?? DocumentDefaultValues.Empty.string
        brandRef = try values.decodeIfPresent(String.self, forKey: .brandRef) ?? DocumentDefaultValues.Empty.string
        isFollowed = try values.decodeIfPresent(Bool.self, forKey: .isFollowed) ?? DocumentDefaultValues.Empty.bool
        similarProducts = try values.decodeIfPresent([SimilarProduct].self, forKey: .similarProducts) ?? []
        currency = try values.decodeIfPresent(String.self, forKey: .currency) ?? STATIC_LABELS.currencySymbol.rawValue
        isBookmark = try values.decodeIfPresent(Bool.self, forKey: .isBookmark) ?? DocumentDefaultValues.Empty.bool
    }
}

// MARK: - RatingAndReview
struct RatingAndReview: Codable {
    let id: String
    let rating: Int
    let title, review: String
    let fullName,name: String
    let image, userRef: String
    let images: [String]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case rating, title, review, fullName, name, userRef, image, images
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        rating = try values.decodeIfPresent(Int.self, forKey: .rating) ?? DocumentDefaultValues.Empty.int
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? DocumentDefaultValues.Empty.string
        review = try values.decodeIfPresent(String.self, forKey: .review) ?? DocumentDefaultValues.Empty.string
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? DocumentDefaultValues.Empty.string
        userRef = try values.decodeIfPresent(String.self, forKey: .userRef) ?? DocumentDefaultValues.Empty.string
        images = try values.decodeIfPresent([String].self, forKey: .images) ?? []
    }
}

// MARK: - SimilarProduct
struct SimilarProduct: Codable {
    let id: String
    let images: [String]
    let price, brandRef: String
    let link: String
    let brandName, name, info: String
    let currency: String
    var isBookmark: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case images, price, brandRef, link, brandName, name, info, currency, isBookmark
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        price = try values.decodeIfPresent(String.self, forKey: .price) ?? DocumentDefaultValues.Empty.string
        link = try values.decodeIfPresent(String.self, forKey: .link) ?? DocumentDefaultValues.Empty.string
        brandName = try values.decodeIfPresent(String.self, forKey: .brandName) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        brandRef = try values.decodeIfPresent(String.self, forKey: .brandRef) ?? DocumentDefaultValues.Empty.string
        info = try values.decodeIfPresent(String.self, forKey: .info) ?? DocumentDefaultValues.Empty.string
        images = try values.decodeIfPresent([String].self, forKey: .images) ?? []
        currency = try values.decodeIfPresent(String.self, forKey: .currency) ?? STATIC_LABELS.currencySymbol.rawValue
        isBookmark = try values.decodeIfPresent(Bool.self, forKey: .isBookmark) ?? DocumentDefaultValues.Empty.bool
    }
}
