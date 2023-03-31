//
//  RestaurantReviewListingResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 09/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

//struct RestaurantReviewListingResponse: Codable {
//    let code: Int
//    let message: String
//}

// MARK: - RestaurantReviewListingResponse
struct RestaurantReviewListingResponse: Codable {
    let hasMore: Bool
    let format: String
    let data: [RestaurantReviewListing]
    let code: Int
    let message: String
    let limit, size, page: Int
    let timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([RestaurantReviewListing].self, forKey: .data) ?? []
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - RestaurantReviewListing
struct RestaurantReviewListing: Codable {
    let id: String
    let rating: Double
    let deleted: Bool
    let restaurantRef, review, title, updatedOn: String
    let userRef, createdOn: String
    let v: Int
    let userDetails: UserDetails?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case rating, deleted, restaurantRef, review, title, updatedOn, userRef, createdOn
        case v = "__v"
        case userDetails
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        rating = try values.decodeIfPresent(Double.self, forKey: .rating) ?? DocumentDefaultValues.Empty.double
        deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted) ?? DocumentDefaultValues.Empty.bool
        restaurantRef = try values.decodeIfPresent(String.self, forKey: .restaurantRef) ?? DocumentDefaultValues.Empty.string
        review = try values.decodeIfPresent(String.self, forKey: .review) ?? DocumentDefaultValues.Empty.string
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? DocumentDefaultValues.Empty.string
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
        userRef = try values.decodeIfPresent(String.self, forKey: .userRef) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? DocumentDefaultValues.Empty.int
        userDetails = try values.decodeIfPresent(UserDetails.self, forKey: .userDetails) ?? nil
    }
}

// MARK: - UserDetails
struct UserDetails: Codable {
    let firstName, lastName, id, image: String

    enum CodingKeys: String, CodingKey {
        case firstName, lastName
        case id = "_id"
        case image
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? DocumentDefaultValues.Empty.string
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? DocumentDefaultValues.Empty.string
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? DocumentDefaultValues.Empty.string
    }
}
