//
//  AddCommentViewMode.swift
//  forthgreen
//
//  Created by MACBOOK on 16/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol AddCommentDelegate {
    var newCommentInfo: Box<CommentList> { get set }
    func addComment(request: AddCommentRequest)
}

struct AddCommentViewModel: AddCommentDelegate {
    var newCommentInfo: Box<CommentList> = Box(CommentList())
    
    func addComment(request: AddCommentRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.COMMENTS.add, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(AddCommentResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.newCommentInfo.value = success.data
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
