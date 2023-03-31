//
//  AddPostRequest.swift
//  forthgreen
//
//  Created by MACBOOK on 13/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

struct AddPostRequest: Encodable {
    var text: String
    var tags: [tagsRequest]
    var postType: Int
    var videoWidth, videoHeight: Float
}

//
//struct LocalPostData: Encodable {
//    var text: String?
//    var tags: [tagsRequest]?
//    var imageData: [UploadImageInfo]?
//    var video : UploadImageInfo?
//    
//    init(text: String? = nil, tags: [tagsRequest]? = nil, imageData: [UploadImageInfo]? = nil, video: UploadImageInfo? = nil) {
//        self.text = text
//        self.tags = tags
//        self.imageData = imageData
//        self.video = video
//    }
//}
