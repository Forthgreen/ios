//
//  StaticResponse.swift
//  forthgreen
//
//  Created by Rohit Saini on 20/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - LoginResponse
struct StaticResponse: Codable {
    let code: Int
    let message: String
    let data: StaticData?
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(StaticData.self, forKey: .data) ?? nil
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - LoginData
struct StaticData: Codable {
    let aboutUs,termsAndCondition,privacyPolicy: String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        aboutUs = try values.decodeIfPresent(String.self, forKey: .aboutUs) ?? DocumentDefaultValues.Empty.string
         termsAndCondition = try values.decodeIfPresent(String.self, forKey: .termsAndCondition) ?? DocumentDefaultValues.Empty.string
         privacyPolicy = try values.decodeIfPresent(String.self, forKey: .privacyPolicy) ?? DocumentDefaultValues.Empty.string
    }
}





