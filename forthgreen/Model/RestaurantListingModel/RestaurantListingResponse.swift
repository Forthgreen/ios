//
//  RestaurantListingResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 07/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - RestaurantListingResponse
struct RestaurantListingResponse: Codable {
    let hasMore: Bool
    let format: String
    let data: [RestaurantListing]
    let code: Int
    let message: String
    let limit, size, page: Int
    let timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([RestaurantListing].self, forKey: .data) ?? []
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - Datum
struct RestaurantListing: Codable,Equatable,Hashable {
    static func == (lhs: RestaurantListing, rhs: RestaurantListing) -> Bool {
        return lhs.id == rhs.id
    }
   
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    let categories: [Int]
    let createdOn: String
    let blocked: Bool
    let typeOfFood, updatedOn, about, portCode: String
    let id, phoneCode: String
    let ratings: Ratings?
    let price: String
    let location: Location?
    let deleted: Bool
    var isSelected: Bool
    let images: [String]
    let thumbnail: String
    let v: Int
    let distance: Double
    let name, phoneNumber: String

    enum CodingKeys: String, CodingKey {
        case categories, createdOn, blocked, typeOfFood, updatedOn, about, portCode
        case id = "_id"
        case phoneCode, ratings, price, location, deleted, images, thumbnail
        case v = "__v"
        case distance, name, phoneNumber, isSelected
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categories = try values.decodeIfPresent([Int].self, forKey: .categories) ?? []
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        blocked = try values.decodeIfPresent(Bool.self, forKey: .blocked) ?? DocumentDefaultValues.Empty.bool
        typeOfFood = try values.decodeIfPresent(String.self, forKey: .typeOfFood) ?? DocumentDefaultValues.Empty.string
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
        about = try values.decodeIfPresent(String.self, forKey: .about) ?? DocumentDefaultValues.Empty.string
        portCode = try values.decodeIfPresent(String.self, forKey: .portCode) ?? DocumentDefaultValues.Empty.string
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        phoneCode = try values.decodeIfPresent(String.self, forKey: .phoneNumber) ?? DocumentDefaultValues.Empty.string
        ratings = try values.decodeIfPresent(Ratings.self, forKey: .ratings) ?? nil
        price = try values.decodeIfPresent(String.self, forKey: .price) ?? DocumentDefaultValues.Empty.string
        location = try values.decodeIfPresent(Location.self, forKey: .location) ?? nil
        deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted) ?? DocumentDefaultValues.Empty.bool
        images = try values.decodeIfPresent([String].self, forKey: .images) ?? []
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail) ?? DocumentDefaultValues.Empty.string
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? DocumentDefaultValues.Empty.int
        distance = try values.decodeIfPresent(Double.self, forKey: .distance) ?? DocumentDefaultValues.Empty.double
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber) ?? DocumentDefaultValues.Empty.string
        isSelected = try values.decodeIfPresent(Bool.self, forKey: .isSelected) ?? DocumentDefaultValues.Empty.bool
    }
}

// MARK: - Location
struct Location: Codable {
    let address, type: String
    let coordinates: [Double]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address = try values.decodeIfPresent(String.self, forKey: .address) ?? DocumentDefaultValues.Empty.string
        type = try values.decodeIfPresent(String.self, forKey: .type) ?? DocumentDefaultValues.Empty.string
        coordinates = try values.decodeIfPresent([Double].self, forKey: .coordinates) ?? []
    }
}

// MARK: - Ratings
struct Ratings: Codable {
    let id: String
    let count: Int
    let averageRating: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case count, averageRating
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        count = try values.decodeIfPresent(Int.self, forKey: .count) ?? DocumentDefaultValues.Empty.int
        averageRating = try values.decodeIfPresent(Double.self, forKey: .averageRating) ?? DocumentDefaultValues.Empty.double
    }
}
