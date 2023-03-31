//
//  FollowingRestaurantListingResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 09/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - FollowingRestaurantListingResponse
struct FollowingRestaurantListingResponse: Codable {
    let hasMore: Bool
    let format: String
    let data: [FollowingRestaurantList]
    let code: Int
    let message: String
    let limit, size, page: Int
    let timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([FollowingRestaurantList].self, forKey: .data) ?? []
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - FollowingRestaurantList
struct FollowingRestaurantList: Codable {
    let id, restaurantRef: String
    let v: Int
    let updatedOn, userRef, createdOn: String
    let restaurant: RestaurantListing?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case restaurantRef
        case v = "__v"
        case updatedOn, userRef, createdOn, restaurant
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        restaurantRef = try values.decodeIfPresent(String.self, forKey: .restaurantRef) ?? DocumentDefaultValues.Empty.string
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? DocumentDefaultValues.Empty.int
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
        userRef = try values.decodeIfPresent(String.self, forKey: .userRef) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        restaurant = try values.decodeIfPresent(RestaurantListing.self, forKey: .restaurant) ?? nil
    }
}

// MARK: - Restaurant
//struct Restaurant: Codable {
//    let categories: [Int]
//    let createdOn: String
//    let blocked: Bool
//    let typeOfFood, updatedOn, about, portCode: String
//    let id, phoneCode: String
//    let ratings: Ratings
//    let price: String
//    let location: Location
//    let deleted: Bool
//    let images: [String]
//    let thumbnail: String
//    let v: Int
//    let name, phoneNumber: String
//
//    enum CodingKeys: String, CodingKey {
//        case categories, createdOn, blocked, typeOfFood, updatedOn, about, portCode
//        case id = "_id"
//        case phoneCode, ratings, price, location, deleted, images, thumbnail
//        case v = "__v"
//        case name, phoneNumber
//    }
//}
//
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
