//
//  TagListViewModel.swift
//  forthgreen
//
//  Created by iMac on 10/26/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol TagListDelegate {
    var hasMore: Box<Bool> { get set }
    var tagList: Box<[CommentList]> { get set }
    func getTagListing(request: TagListRequest)
}

struct TagListViewModel { //}: TagListDelegate {
//    var tagList: Box<[CommentList]> = Box([CommentList]())
//    var hasMore: Box<Bool> = Box(Bool())
//    var success: Box<Bool> = Box(Bool())
    
    func getTagListing(request: TagListRequest,_ completion: @escaping (_ response: [TagListModel]) -> Void) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.TAG.list, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(TagListResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            completion(success.data.self)
//                            self.tagList.value += success.data
//                            self.hasMore.value = success.hasMore
//                            self.success.value = true
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
