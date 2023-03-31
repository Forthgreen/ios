//
//  SearchUserViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 25/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol SearchUserDelegate {
    var success: Box<Bool> { get set }
    var hasMore: Box<Bool> { get set }
    var userList: Box<[SearchedUserList]> { get set }
    func userSearch(request: SearchUserRequest)
}

struct SearchUserViewModel: SearchUserDelegate {
    var success: Box<Bool> = Box(Bool())
    var hasMore: Box<Bool> = Box(Bool())
    var userList: Box<[SearchedUserList]> = Box([])
    
    func userSearch(request: SearchUserRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.USER.search, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SearchUserResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.userList.value += success.data
                            self.hasMore.value = success.hasMore
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
    
    func followUser(userId: String, followStatus: Bool) {
        for index in 0..<userList.value.count where userList.value[index].id == userId {
            userList.value[index].isFollow = followStatus
        }
    }
}
