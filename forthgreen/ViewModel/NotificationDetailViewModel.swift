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
    var postDetail: Box<[NotificationDetail]> { get set }
    func fetchNotiDetail(request: NotificationDetailRequest)
}

struct NotificationDetailViewModel: NotificationDetailDelegate {
    var failure: Box<Bool> = Box(Bool())
    var success: Box<Bool> = Box(Bool())
    var postDetail: Box<[NotificationDetail]> = Box([NotificationDetail]())
    
    func fetchNotiDetail(request: NotificationDetailRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.NOTIFICATION.details, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(NotificationDetailResponse.self, from: response!) // decode the response into model
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
    
    func likePost(postRef: String, status: Bool) {
        if postDetail.value.first?.posts.id == postRef {
            postDetail.value[0].posts.isLike = status
            if status {
                postDetail.value[0].posts.likes += 1
            }
            else {
                postDetail.value[0].posts.likes -= 1
            }
        }
    }
    
    func deleteComment(commentRef: String) {
        if postDetail.value.first?.posts.comment.id == commentRef {
            postDetail.value[0].posts.comment = Comment()
        }
    }
    
    func deleteReply(replyRef: String) {
        if postDetail.value.first?.posts.comment.id == replyRef {
            postDetail.value[0].posts.comment.reply = Reply()
        }
    }
    
    func likeComment(commentRef: String, status: Bool) {
        if postDetail.value.first?.posts.comment.id == commentRef {
            postDetail.value[0].posts.comment.isLike = status
            if status {
                postDetail.value[0].posts.comment.likes += 1
            }
            else {
                postDetail.value[0].posts.comment.likes -= 1
            }
        }
    }
    
    func likeReply(replyRef: String, status: Bool) {
        if postDetail.value.first?.posts.comment.reply.id == replyRef {
            postDetail.value[0].posts.comment.reply.isLike = status
            if status {
                postDetail.value[0].posts.comment.reply.likes += 1
            }
            else {
                postDetail.value[0].posts.comment.reply.likes -= 1
            }
        }
    }
}
