//
//  NotificationViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 26/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol NotificationDelegate {
    var hasMore: Box<Bool> { get set }
    var listSuccess: Box<Bool> { get set }
    var seenSuccess: Box<Bool> { get set }
    var notificationList: Box<[NotificationList]> { get set }
    func fetchNotiList(page: Int)
    func notificationSeen(request: NotificationSeenRequest)
}

struct NotificationViewModel: NotificationDelegate {
    var hasMore: Box<Bool> = Box(Bool())
    var listSuccess: Box<Bool> = Box(Bool())
    var seenSuccess: Box<Bool> = Box(Bool())
    var notificationList: Box<[NotificationList]> = Box([])
    
    func fetchNotiList(page: Int) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: ["page": page], api: API.NOTIFICATION.list, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(NotificationResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.notificationList.value = success.data
                            self.hasMore.value = success.hasMore
                            self.listSuccess.value = true
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
    
    func notificationSeen(request: NotificationSeenRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.NOTIFICATION.seen, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.seenSuccess.value = true
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
    
    func deleteNotification(postRef: String) {
            notificationList.value = notificationList.value.filter({ $0.id != postRef })
    }
}
