//
//  ReportBrandViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 16/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol ReportDelegate {
    func didRecieveReportResponse(response: SuccessModel)
}

struct ReportViewModel {
    var delegate: ReportDelegate?
    
    func report(reportRequest: ReportRequest) {
        let params: [String: Any] = ["reportType":reportRequest.reportType,
                                     "reviewRef": reportRequest.reviewRef,
                                     "brandRef": reportRequest.brandRef,
                                     "brandReportType": reportRequest.brandReportType,
                                     "feedback": reportRequest.feedback]
        GCD.REPORT.brandOrReview.async {
            APIManager.sharedInstance.I_AM_COOL(params: params, api: API.REPORT.brandOrReview, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveReportResponse(response: success)
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
