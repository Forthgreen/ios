//
//  RestaurantDetailResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 08/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - RestaurantDetailResponse
struct RestaurantDetailResponse: Codable {
    let code: Int
    let message: String
    let data: RestaurantDetail?
    let timestamp, format: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(RestaurantDetail.self, forKey: .data) ?? nil
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - RestaurantDetail
struct RestaurantDetail: Codable {
    let categories: [Int]
    let createdOn, typeOfFood, about, portCode: String
    let id, phoneCode, website: String
    let ratings: Ratings?
    let price: String
    let location: Location?
    var isFollowed, showPhoneNumber: Bool
    let images: [String]
    let selfRating: SelfRating?
    let thumbnail, name, phoneNumber: String
    var isBookmark: Bool
    let distance: Double

    enum CodingKeys: String, CodingKey {
        case categories, createdOn, typeOfFood, about, portCode, isBookmark, distance
        case id = "_id"
        case phoneCode, ratings, price, location, isFollowed, images, thumbnail, name, phoneNumber, selfRating, website, showPhoneNumber
    }
    
    init() {
        self.categories = []
        self.createdOn = DocumentDefaultValues.Empty.string
        self.typeOfFood = DocumentDefaultValues.Empty.string
        self.about = DocumentDefaultValues.Empty.string
        self.portCode = DocumentDefaultValues.Empty.string
        self.id = DocumentDefaultValues.Empty.string
        self.phoneCode = DocumentDefaultValues.Empty.string
        self.ratings = nil
        self.price = DocumentDefaultValues.Empty.string
        self.location = nil
        self.isFollowed = DocumentDefaultValues.Empty.bool
        self.showPhoneNumber = DocumentDefaultValues.Empty.bool
        self.images = []
        self.thumbnail = DocumentDefaultValues.Empty.string
        self.name = DocumentDefaultValues.Empty.string
        self.phoneNumber = DocumentDefaultValues.Empty.string
        self.website = DocumentDefaultValues.Empty.string
        self.isBookmark = DocumentDefaultValues.Empty.bool
        self.selfRating = nil
        self.distance = DocumentDefaultValues.Empty.double
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categories = try values.decodeIfPresent([Int].self, forKey: .categories) ?? []
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        typeOfFood = try values.decodeIfPresent(String.self, forKey: .typeOfFood) ?? DocumentDefaultValues.Empty.string
        about = try values.decodeIfPresent(String.self, forKey: .about) ?? DocumentDefaultValues.Empty.string
        portCode = try values.decodeIfPresent(String.self, forKey: .portCode) ?? DocumentDefaultValues.Empty.string
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        phoneCode = try values.decodeIfPresent(String.self, forKey: .phoneCode) ?? DocumentDefaultValues.Empty.string
        ratings = try values.decodeIfPresent(Ratings.self, forKey: .ratings) ?? nil
        price = try values.decodeIfPresent(String.self, forKey: .price) ?? DocumentDefaultValues.Empty.string
        location = try values.decodeIfPresent(Location.self, forKey: .location) ?? nil
        isFollowed = try values.decodeIfPresent(Bool.self, forKey: .isFollowed) ?? DocumentDefaultValues.Empty.bool
        showPhoneNumber = try values.decodeIfPresent(Bool.self, forKey: .showPhoneNumber) ?? DocumentDefaultValues.Empty.bool
        images = try values.decodeIfPresent([String].self, forKey: .images) ?? []
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber) ?? DocumentDefaultValues.Empty.string
        website = try values.decodeIfPresent(String.self, forKey: .website) ?? DocumentDefaultValues.Empty.string
        selfRating = try values.decodeIfPresent(SelfRating.self, forKey: .selfRating) ?? nil
        isBookmark = try values.decodeIfPresent(Bool.self, forKey: .isBookmark) ?? DocumentDefaultValues.Empty.bool
        distance = try values.decodeIfPresent(Double.self, forKey: .distance) ?? DocumentDefaultValues.Empty.double
    }
}

//// MARK: - Location
//struct Location: Codable {
//    let address, type: String
//    let coordinates: [Int]
//}
//
//// MARK: - Ratings
//struct Ratings: Codable {
//    let id: String
//    let count: Int
//    let averageRating: Double
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case count, averageRating
//    }
//}

// MARK: - SelfRating
struct SelfRating: Codable {
    let id: String
    let rating: Int
    let deleted: Bool
    let restaurantRef, review, title, updatedOn: String
    let userRef, createdOn: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case rating, deleted, restaurantRef, review, title, updatedOn, userRef, createdOn
        case v = "__v"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        rating = try values.decodeIfPresent(Int.self, forKey: .rating) ?? DocumentDefaultValues.Empty.int
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? DocumentDefaultValues.Empty.string
        review = try values.decodeIfPresent(String.self, forKey: .review) ?? DocumentDefaultValues.Empty.string
        restaurantRef = try values.decodeIfPresent(String.self, forKey: .restaurantRef) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
        userRef = try values.decodeIfPresent(String.self, forKey: .userRef) ?? DocumentDefaultValues.Empty.string
        deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted) ?? DocumentDefaultValues.Empty.bool
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? DocumentDefaultValues.Empty.int
    }
}

