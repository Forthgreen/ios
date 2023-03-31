//
//  StatisticsViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 23/06/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol StatisticsDelegate {
    func didReceivedProductStatistics(response: SuccessModel)
     func didReceivedWebsiteStatistics(response: SuccessModel)
}

struct StatisticsViewModel {
    var delegate: StatisticsDelegate?
    
    func getProductStatistics(statisticRequest: StatisticsRequest) {
        let params: [String: Any] = ["productRef": statisticRequest.productRef]
        GCD.REPORT.brandOrReview.async {
            APIManager.sharedInstance.I_AM_COOL(params: params, api: API.Statistics.productVisit, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didReceivedProductStatistics(response: success)
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
    func getWebsiteStatistics(statisticRequest: StatisticsRequest) {
        let params: [String: Any] = ["productRef": statisticRequest.productRef]
        GCD.REPORT.brandOrReview.async {
            APIManager.sharedInstance.I_AM_COOL(params: params, api: API.Statistics.websiteClick, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didReceivedWebsiteStatistics(response: success)
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
