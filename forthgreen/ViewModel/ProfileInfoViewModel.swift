//
//  ProfileInfoViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 23/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol ProfileInfoDelegate {
    var success: Box<Bool> { get set }
    var userInfo: Box<ProfileInfo> { get set }
    var postList: Box<[SocialFeed]> { get set }
    func fetchInfo(request: ProfileInfoRequest)
}

struct ProfileInfoViewModel: ProfileInfoDelegate {
    var success: Box<Bool> = Box(Bool())
    var successBlock: Box<Bool> = Box(Bool())
    var userInfo: Box<ProfileInfo> = Box(ProfileInfo())
    var postList: Box<[SocialFeed]> = Box([SocialFeed]())
    
    func fetchInfo(request: ProfileInfoRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.USER.profile, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(ProfileInfoResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.userInfo.value = ProfileInfo()
                            self.userInfo.value = success.data
                            self.success.value = true
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
    
    func blockUser(request: ProfileBlockRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.USER.blockUser, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(LOCBlockResultModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.successBlock.value = true
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
    
    func likePost(postRef: String, status: Bool) {
        for index in 0..<userInfo.value.posts.count where userInfo.value.posts[index].id == postRef {
            userInfo.value.posts[index].isLike = status
            if status {
                userInfo.value.posts[index].likes += 1
            }
            else {
                userInfo.value.posts[index].likes -= 1
            }
        }
    }
    
    func deletePostLocally(id: String) {
        self.userInfo.value.posts = userInfo.value.posts.filter({ $0.id != id })
    }
}
