//
//  NotificationDetailViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 29/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol NotificationDetailDelegate {
    var failure: Box<Bool> { get set}
    var success: Box<Bool> { get set }
    var postDetail: Box<[PostDetail]> { get set }
    func fetchPostNotiDetail(request: PostDetailRequest)
    func fetchNotiDetail(request: NotificationDetailRequest)
}

struct NotificationDetailViewModel: NotificationDetailDelegate {
    
    var failure: Box<Bool> = Box(Bool())
    var success: Box<Bool> = Box(Bool())
    var postDetail: Box<[PostDetail]> = Box([PostDetail]())
    
    func fetchNotiDetail(request: NotificationDetailRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.NOTIFICATION.details, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(NotificationDetailResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            let data = success.data.first?.posts ?? Posts()
                            var postDetail = PostDetail()
                            postDetail.id = data.id
                            postDetail.posts = data
                            self.postDetail.value = [postDetail]
                            self.success.value = true
                            break
                        case 302:
                            self.failure.value = true
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
    
    func fetchPostNotiDetail(request: PostDetailRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.POST.postDetail, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(PostDetailResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.postDetail.value = success.data
                            self.success.value = true
                            break
                        case 302:
                            self.failure.value = true
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
    
    func deletePostLocally(id: String) {
        if postDetail.value.first?.posts.id == id {
            postDetail.value.removeAll()
        }
    }
}
