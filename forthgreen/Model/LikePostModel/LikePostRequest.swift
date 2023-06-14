//
//  LikePostRequest.swift
//  forthgreen
//
//  Created by MACBOOK on 18/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

struct LikePostRequest: Encodable {
    var postRef: String
    var like: Bool
}


struct LikeListRequest: Encodable {
    var ref: String?
    var likeType: Int?
    var page: Int?
    
    init(ref: String? = nil, likeType: Int? = nil, page: Int?) {
        self.ref = ref
        self.likeType = likeType
        self.page = page
    }
}


struct BookmarkAddRequest: Encodable {
    var ref: String?
    var refType: Int?
    var status: Bool?
    
    init(ref: String? = nil, refType: Int? = nil, status: Bool?) {
        self.ref = ref
        self.refType = refType
        self.status = status
    }
}

struct BookmarkListRequest: Encodable {
    var page: Int?
    var refType: Int?
    var longitude, latitude: Double?
    
    init(longitude: Double? = nil, latitude: Double? = nil, page: Int? = nil, refType: Int? = nil) {
        self.page = page
        self.refType = refType
        self.longitude = longitude
        self.latitude = latitude
    }
}

struct TagListRequest: Encodable {
    var text: String?
    var page: Int?
    var limit: Int?
    
    init(text: String? = nil, page: Int?, limit: Int?) {
        self.text = text
        self.page = page
        self.limit = limit
    }
}

struct ShopPageRequest: Encodable {
    var page: Int?
    
    init(page: Int?) {
        self.page = page
    }
}
