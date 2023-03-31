//
//  AddReviewResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 18/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - Empty
struct AddReviewResponse: Codable {
    let code: Int
    let message: String
    let data: ReviewData?
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(ReviewData.self, forKey: .data) ?? nil
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - ReviewData
struct ReviewData: Codable {
    let id, userRef, productRef: String
    let rating: Int
    let title, review, createdOn, updatedOn: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userRef, productRef, rating, title, review, createdOn, updatedOn
        case v = "__v"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        userRef = try values.decodeIfPresent(String.self, forKey: .userRef) ?? DocumentDefaultValues.Empty.string
        productRef = try values.decodeIfPresent(String.self, forKey: .productRef) ?? DocumentDefaultValues.Empty.string
        rating = try values.decodeIfPresent(Int.self, forKey: .rating) ?? DocumentDefaultValues.Empty.int
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? DocumentDefaultValues.Empty.string
        review = try values.decodeIfPresent(String.self, forKey: .review) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? DocumentDefaultValues.Empty.int
    }
}
