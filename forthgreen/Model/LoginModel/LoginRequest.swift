//
//  LoginRequest.swift
//  forthgreen
//
//  Created by MACBOOK on 11/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

struct LoginRequest: Encodable {
    var email, password: String?
}
