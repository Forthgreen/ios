//
//  FollowerListViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 20/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol FollowListDelegate {
    var success: Box<Bool> { get set }
    var hasMoreOfFollower: Box<Bool> { get set }
    var hasMoreOfFollowing: Box<Bool> { get set }
    var followerList: Box<[FollowList]> { get set }
    var followingList: Box<[FollowList]> { get set }
    func fetchList(request: FollowUserListRequest)
}

struct FollowerListViewModel: FollowListDelegate {
    var hasMoreOfFollower: Box<Bool> = Box(Bool())
    var hasMoreOfFollowing: Box<Bool> = Box(Bool())
    var success: Box<Bool> = Box(Bool())
    var followerList: Box<[FollowList]> = Box([])
    var followingList: Box<[FollowList]> = Box([])
    
    func fetchList(request: FollowUserListRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.FOLLOW_USER.list, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(FollowListResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            switch request.listType {
                            case .follower:
                                self.followerList.value += success.data
                                self.hasMoreOfFollower.value = success.hasMore
                            case .following:
                                self.followingList.value += success.data
                                self.hasMoreOfFollowing.value = success.hasMore
                            }
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
    
    func followUser(userId: String, followStatus: Bool, listType: FOLLOW_LIST_TYPE) {
        switch listType {
        case .follower:
            for index in 0..<followerList.value.count where followerList.value[index].id == userId {
                followerList.value[index].isFollow = followStatus
            }
        case .following:
            for index in 0..<followingList.value.count where followingList.value[index].id == userId {
                followingList.value[index].isFollow = followStatus
            }
        }
    }
}
