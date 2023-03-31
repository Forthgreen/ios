//
//  PostListListViewModel.swift
//  forthgreen
//
//  Created by iMac on 7/26/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol PostListListDelegate {
    var success: Box<Bool> { get set }
    var hasMore: Box<Bool> { get set }
    var likeList: Box<[UserLikeInfo]> { get set }
    func likePost(request: LikeListRequest)
}

struct PostListListViewModel: PostListListDelegate {
    var likeList: Box<[UserLikeInfo]> = Box([UserLikeInfo]())
    var hasMore: Box<Bool> = Box(Bool())
    var success: Box<Bool> = Box(Bool())
    
    func likePost(request: LikeListRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.POST.likeList, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(LikeListResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.success.value = true
                            self.hasMore.value = success.hasMore
                            self.likeList.value += success.data
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
    
    func followUser(userId: String, followStatus: Bool) {
        for index in 0..<likeList.value.count where likeList.value[index].id == userId {
            likeList.value[index].isFollowing = followStatus
        }
    }
}
