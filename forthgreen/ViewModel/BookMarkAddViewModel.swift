//
//  BookMarkAddViewModel.swift
//  forthgreen
//
//  Created by iMac on 10/23/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation


import SainiUtils

protocol BookMarkAddDelegate {
    var success: Box<Bool> { get set }
    var bookmarkInfo: Box<BookmarkModel> { get set }
    func addBookmark(request: BookmarkAddRequest)
}

struct BookMarkAddViewModel: BookMarkAddDelegate {
    var bookmarkInfo: Box<BookmarkModel> = Box(BookmarkModel())
    var success: Box<Bool> = Box(Bool())
    
    func addBookmark(request: BookmarkAddRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.BOOKMARK.add, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(BookmarkResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.success.value = true
                            self.bookmarkInfo.value = success.data ?? BookmarkModel.init()
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
