//
//  LoginResponse.swift
//  forthgreen
//
//  Created by MACBOOK on 11/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    let code: Int
    let message: String
    let data: LoginData?
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(LoginData.self, forKey: .data) ?? nil
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - LoginData
struct LoginData: Codable {
    let accessToken: String
    let user: User?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken) ?? DocumentDefaultValues.Empty.string
        user = try values.decodeIfPresent(User.self, forKey: .user) ?? nil
    }
}

// MARK: - User
struct User: Codable {
    let userType: Int
    let id, firstName, lastName, email: String
    let mobileNumber, picture,image: String
    let v, gender: Int
    let bio, username: String
    var isSocialUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case userType
        case id = "_id"
        case firstName, lastName, email, mobileNumber, picture, image
        case v = "__v"
        case bio, username, gender, isSocialUser
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userType = try values.decodeIfPresent(Int.self, forKey: .userType) ?? DocumentDefaultValues.Empty.int
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? DocumentDefaultValues.Empty.string
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? DocumentDefaultValues.Empty.string
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? DocumentDefaultValues.Empty.string
        mobileNumber = try values.decodeIfPresent(String.self, forKey: .mobileNumber) ?? DocumentDefaultValues.Empty.string
        picture = try values.decodeIfPresent(String.self, forKey: .picture) ?? DocumentDefaultValues.Empty.string
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? DocumentDefaultValues.Empty.string
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? DocumentDefaultValues.Empty.int
        gender = try values.decodeIfPresent(Int.self, forKey: .gender) ?? DocumentDefaultValues.Empty.int
        bio = try values.decodeIfPresent(String.self, forKey: .bio) ?? DocumentDefaultValues.Empty.string
        username = try values.decodeIfPresent(String.self, forKey: .username) ?? DocumentDefaultValues.Empty.string
        isSocialUser = try values.decodeIfPresent(Bool.self, forKey: .isSocialUser) ?? DocumentDefaultValues.Empty.bool
    }
}
