//
//  NotificationDetailRequest.swift
//  forthgreen
//
//  Created by MACBOOK on 29/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

struct PostDetailRequest: Encodable {
    var postRef: String
}

struct NotificationDetailRequest: Encodable {
    var notificationId: String
}
