//
//  BrandResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 14/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - BrandResponse
struct BrandResponse: Codable {
    let code: Int
    let message: String
    let data: [BrandData]
    let page, limit, size: Int
    let hasMore: Bool
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([BrandData].self, forKey: .data) ?? []
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - BrandData
struct BrandData: Codable {
    let logo: String?
    let id: String
    let followers: Int
    let image: String?
    let brandName: String

    enum CodingKeys: String, CodingKey {
        case logo
        case id = "_id"
        case followers, image, brandName
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        logo = try values.decodeIfPresent(String.self, forKey: .logo) ?? DocumentDefaultValues.Empty.string
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        followers = try values.decodeIfPresent(Int.self, forKey: .followers) ?? DocumentDefaultValues.Empty.int
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? DocumentDefaultValues.Empty.string
        brandName = try values.decodeIfPresent(String.self, forKey: .brandName) ?? DocumentDefaultValues.Empty.string
    }
}


//struct BrandData: Codable {
//    let isVerified, firstLogin, blocked, deleted: Bool
//    let isPremium: Bool
//    let id: String
//    let firstName, lastName: String?
//    let email, companyName, name, mobileNumber: String
//    let password, createdOn, updatedOn: String
//    let v: Int
//    let device, fcmToken: String?
//    let image, logo: String?
//    let about: String?
//    let changeEmailToken, changeEmailTokenDate, secondaryEmail, website: String?
//    let mobileCode: String?
//    let emailToken: Int?
//    let emailTokenDate, coverImage: String?
//
//    enum CodingKeys: String, CodingKey {
//        case isVerified, firstLogin, blocked, deleted, isPremium
//        case id = "_id"
//        case firstName, lastName, email, companyName, name, mobileNumber, password, createdOn, updatedOn
//        case v = "__v"
//        case device, fcmToken, image, logo, about, changeEmailToken, changeEmailTokenDate, secondaryEmail, website, mobileCode, emailToken, emailTokenDate, coverImage
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        isVerified = try values.decodeIfPresent(Bool.self, forKey: .isVerified) ?? DocumentDefaultValues.Empty.bool
//        firstLogin = try values.decodeIfPresent(Bool.self, forKey: .firstLogin) ?? DocumentDefaultValues.Empty.bool
//        blocked = try values.decodeIfPresent(Bool.self, forKey: .blocked) ?? DocumentDefaultValues.Empty.bool
//        deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted) ?? DocumentDefaultValues.Empty.bool
//        isPremium = try values.decodeIfPresent(Bool.self, forKey: .isPremium) ?? DocumentDefaultValues.Empty.bool
//        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
//        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? DocumentDefaultValues.Empty.string
//        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? DocumentDefaultValues.Empty.string
//        email = try values.decodeIfPresent(String.self, forKey: .email) ?? DocumentDefaultValues.Empty.string
//        companyName = try values.decodeIfPresent(String.self, forKey: .companyName) ?? DocumentDefaultValues.Empty.string
//        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
//        mobileNumber = try values.decodeIfPresent(String.self, forKey: .mobileNumber) ?? DocumentDefaultValues.Empty.string
//        password = try values.decodeIfPresent(String.self, forKey: .password) ?? DocumentDefaultValues.Empty.string
//        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
//        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
//        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? DocumentDefaultValues.Empty.int
//        device = try values.decodeIfPresent(String.self, forKey: .device) ?? DocumentDefaultValues.Empty.string
//        fcmToken = try values.decodeIfPresent(String.self, forKey: .fcmToken) ?? DocumentDefaultValues.Empty.string
//        image = try values.decodeIfPresent(String.self, forKey: .image) ?? DocumentDefaultValues.Empty.string
//        logo = try values.decodeIfPresent(String.self, forKey: .logo) ?? DocumentDefaultValues.Empty.string
//        about = try values.decodeIfPresent(String.self, forKey: .about) ?? DocumentDefaultValues.Empty.string
//        changeEmailToken = try values.decodeIfPresent(String.self, forKey: .changeEmailToken) ?? DocumentDefaultValues.Empty.string
//        changeEmailTokenDate = try values.decodeIfPresent(String.self, forKey: .changeEmailTokenDate) ?? DocumentDefaultValues.Empty.string
//        secondaryEmail = try values.decodeIfPresent(String.self, forKey: .secondaryEmail) ?? DocumentDefaultValues.Empty.string
//        website = try values.decodeIfPresent(String.self, forKey: .website) ?? DocumentDefaultValues.Empty.string
//        mobileCode = try values.decodeIfPresent(String.self, forKey: .mobileCode) ?? DocumentDefaultValues.Empty.string
//        emailToken = try values.decodeIfPresent(Int.self, forKey: .emailToken) ?? DocumentDefaultValues.Empty.int
//        emailTokenDate = try values.decodeIfPresent(String.self, forKey: .emailTokenDate) ?? DocumentDefaultValues.Empty.string
//        coverImage = try values.decodeIfPresent(String.self, forKey: .coverImage) ?? DocumentDefaultValues.Empty.string
//    }
//}
