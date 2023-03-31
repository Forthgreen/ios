//
//  ReportCommentViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 28/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol ReportCommentDelegate {
    var success: Box<Bool> { get set }
    func reportComment(request: ReportCommentRequest)
}

struct ReportCommentViewModel: ReportCommentDelegate {
    var success: Box<Bool> = Box(Bool())
    
    func reportComment(request: ReportCommentRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.REPORT.comment, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.success.value = true
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
