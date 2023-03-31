//
//  LikePostViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 18/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol LikePostDelegate {
    var success: Box<Bool> { get set }
    var likePostInfo: Box<LikePostInfo> { get set }
    func likePost(request: LikePostRequest)
}

struct LikePostViewModel: LikePostDelegate {
    var likePostInfo: Box<LikePostInfo> = Box(LikePostInfo())
    var success: Box<Bool> = Box(Bool())
    
    func likePost(request: LikePostRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.POST.like, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(LikePostResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.success.value = true
                            self.likePostInfo.value = success.data
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
