//
//  CommentListViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 16/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol CommentListDelegate {
    var commentSuccess: Box<Bool> { get set }
    var replySuccess: Box<Bool> { get set }
    var commentHasMore: Box<Bool> { get set }
    var replyHasMore: Box<Bool> { get set }
    var commentList: Box<[CommentList]> { get set }
    var replyList: Box<[CommentList]> { get set }
    func fetchCommentListing(request: CommentListRequest)
}

struct CommentListViewModel: CommentListDelegate {
    var commentHasMore: Box<Bool> = Box(Bool())
    var replyHasMore: Box<Bool> = Box(Bool())
    var commentSuccess: Box<Bool> = Box(Bool())
    var replySuccess: Box<Bool> = Box(Bool())
    var commentList: Box<[CommentList]> = Box([CommentList]())
    var replyList: Box<[CommentList]> = Box([CommentList]())
    
    func fetchCommentListing(request: CommentListRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.COMMENTS.list, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(CommentListResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            switch request.commentType {
                            case .comment:
                                self.commentList.value += success.data
                                self.commentList.value = self.commentList.value.filter({ $0.id != DocumentDefaultValues.Empty.string })
                                self.commentHasMore.value = success.hasMore
                                self.commentSuccess.value = true
                            case .reply:
                                self.replyList.value += success.data
                                self.replyList.value = self.replyList.value.filter({ $0.id != DocumentDefaultValues.Empty.string })
                                self.replyHasMore.value = success.hasMore
                                self.replySuccess.value = true
                            case .none:
                                break
                            }
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
    
    func deleteComment(commentRef: String) {
        
        let index = commentList.value.firstIndex { temp in
            temp.id == commentRef
        }
        if index != nil {
            commentList.value.remove(at: index!)
        }
//        commentList.value = commentList.value.filter({ $0.id != commentRef })
    }
    
    func deleteReply(replyRef: String, commentIndex: Int) {
        replyList.value = replyList.value.filter({ $0.id != replyRef })
        commentList.value[commentIndex].reply -= 1
    }
    
    func addNewComment(commentInfo: CommentList) {
//        commentList.value.insert(commentInfo, at: 0)
        commentList.value.append(commentInfo)
    }
    
    func addNewReply(replyInfo: CommentList, commentIndex: Int) {
        replyList.value.insert(replyInfo, at: 0)
        commentList.value[commentIndex].reply += 1
    }
    
    func likeComment(commentRef: String, status: Bool) {
        for index in 0..<commentList.value.count where commentList.value[index].id == commentRef {
            commentList.value[index].isLike = status
            if status {
                commentList.value[index].likes += 1
            }
            else {
                commentList.value[index].likes -= 1
            }
        }
    }
    
    func likeReply(replyRef: String, status: Bool) {
        for index in 0..<replyList.value.count where replyList.value[index].id == replyRef {
            replyList.value[index].isLike = status
            if status {
                replyList.value[index].likes += 1
            }
            else {
                replyList.value[index].likes -= 1
            }
        }
    }
}
