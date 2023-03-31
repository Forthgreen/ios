//
//  LikeCommentViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 20/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol LikeCommentDelegate {
    var likeSuccess: Box<Bool> { get set }
    var likeCommentInfo: Box<LikePostInfo> { get set }
    func likeComment(request: LikeCommentRequest)
}

struct likeCommentViewModel: LikeCommentDelegate {
    var likeSuccess: Box<Bool> = Box(Bool())
    var likeCommentInfo: Box<LikePostInfo> = Box(LikePostInfo())
    
    func likeComment(request: LikeCommentRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.COMMENTS.like, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(LikePostResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.likeCommentInfo.value = success.data
                            self.likeSuccess.value = true
                            break
                        default:
                            log.error("\(Log.stats()) \(success.message)")/
                        }
                    }
                    catch let err {
                        log.error("ERROR OCCURED WHILE DECODING: \(Log.stats()) \(err)")/
                    }
                }
            }
        }
    }
}
