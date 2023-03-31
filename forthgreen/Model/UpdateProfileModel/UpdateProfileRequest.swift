//
//  UpdateProfileRequest.swift
//  forthgreen
//
//  Created by Rohit Saini on 16/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

struct UpdateProfileRequest: Encodable{
    var oldPassword,newPassword,firstName,lastName:String?
    var bio, username: String?
    
    internal init(oldPassword: String? = nil, newPassword: String? = nil, firstName: String? = nil, lastName: String? = nil, bio: String? = nil, username: String? = nil) {
        self.oldPassword = oldPassword
        self.newPassword = newPassword
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
        self.username = username
    }
}
