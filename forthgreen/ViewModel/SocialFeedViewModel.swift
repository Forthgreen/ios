//
//  SocialFeedViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 13/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol SocialFeedDelegate {
    var hasMore: Box<Bool> { get set }
    var postListSuccess: Box<Bool> { get set }
    var newPostAdded: Box<Bool> { get set }
    var postList: Box<[SocialFeed]> { get set }
    var successForAddPost: Box<Bool> { get set }
    func fetchPosts(page: Int)
//    func addNewPost(request: AddPostRequest, imageData: [UploadImageInfo], video : UploadImageInfo?)
}

struct SocialFeedViewModel: SocialFeedDelegate {
    var hasMore: Box<Bool> = Box(Bool())
    var hasFollowingMore: Box<Bool> = Box(Bool())
    var newPostAdded: Box<Bool> = Box(Bool())
    var postListSuccess: Box<Bool> = Box(Bool())
    var postListFollowingSuccess: Box<Bool> = Box(Bool())
    var successForAddPost: Box<Bool> = Box(Bool())
    var postList: Box<[SocialFeed]> = Box([SocialFeed]())
    var postFollowingList: Box<[SocialFeed]> = Box([SocialFeed]())
    
    func fetchPosts(page: Int) {
        DispatchQueue.global().async {
            let api:String
            if AppModel.shared.isGuestUser {
                api = API.POST.guestFeed
            }
            else {
                api = API.POST.homeFeed
            }
            APIManager.sharedInstance.I_AM_COOL(params: ["page": page], api: api, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SocialFeedResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            if page == 1 {
                                self.postList.value.removeAll()
                            }
                            self.postList.value += success.data
                            self.hasMore.value = success.hasMore
                            self.postListSuccess.value = true
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
    
    func fetchFollowingPosts(page: Int) {
        DispatchQueue.global().async {
            let api:String
            if AppModel.shared.isGuestUser {
                api = API.POST.guestFeed
            } else {
                api = API.POST.feedfollowing
            }
            APIManager.sharedInstance.I_AM_COOL(params: ["page": page], api: api, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SocialFeedResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            if page == 1 {
                                self.postFollowingList.value.removeAll()
                            }
                            self.postListFollowingSuccess.value = true
                            self.postFollowingList.value += success.data
                            self.hasFollowingMore.value = success.hasMore
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
    
    func addNewPost(request: AddPostRequest, imageData: [UploadImageInfo], video : UploadImageInfo?, _ completionProgress: @escaping (_ progress : Double) -> Void, _ completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            var arrMedia = [UploadImageInfo]()
            if imageData.count > 0 {
                arrMedia = imageData
            }
            if video?.url != nil {
                arrMedia.append(video!)
                var thumbnail = UploadImageInfo.init()
                thumbnail.data = video?.image?.jpegData(compressionQuality: 1.0)
                thumbnail.name = "thumbnailImage"
                arrMedia.append(thumbnail)
            }
            
            APIManager.sharedInstance.uploadVideoWithProgress(arrMedia, param: request.toJSON(), api: API.POST.add, login: true) { progress in
                completionProgress(progress)
            } _: { response in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(AddPostResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            guard let newPostData = success.data else { return }
                            self.addFeedLocally(feed: newPostData)
                            self.successForAddPost.value = true
                            completion()
                            break
                        default:
                            log.error("\(Log.stats()) \(success.message)")/
                        }
                    }
                    catch let err {
                        NotificationCenter.default.post(name: NOTIFICATIONS.AddPostProgress, object: nil)
                        log.error("ERROR OCCURED WHILE DECODING: \(Log.stats()) \(err)")/
                    }
                }
            }
        }
    }
    
    func addFeedLocally(feed: SocialFeed) {
        self.newPostAdded.value = true
        self.postList.value.insert(feed, at: 0)
    }
    
    func deletePostLocally(id: String) {
        self.postList.value = postList.value.filter({ $0.id != id })
        self.postFollowingList.value = postFollowingList.value.filter({ $0.id != id })
    }
    
    func likePost(postRef: String, status: Bool) {
        for index in 0..<postList.value.count where postList.value[index].id == postRef {
            postList.value[index].isLike = status
            if status {
                postList.value[index].likes += 1
            } else {
                postList.value[index].likes -= 1
            }
        }
        
        for index in 0..<postFollowingList.value.count where postFollowingList.value[index].id == postRef {
            postFollowingList.value[index].isLike = status
            if status {
                postFollowingList.value[index].likes += 1
            } else {
                postFollowingList.value[index].likes -= 1
            }
        }
    }
    
    func followUser(userId: String, followStatus: Bool) {
        for index in 0..<postList.value.count where postList.value[index].id == userId {
            postList.value[index].isFollow = followStatus
        }
        
        for index in 0..<postFollowingList.value.count where postFollowingList.value[index].id == userId {
            postFollowingList.value[index].isFollow = followStatus
        }
    }
}
