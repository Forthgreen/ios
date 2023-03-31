//
//  FollowProductViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 17/01/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation
import UIKit

protocol FollowProductDelegate {
    func didRecieveFollowProductResponse(response: SuccessModel)
}

struct FollowProductViewModel {
    var delegate: FollowProductDelegate?
    
    func SaveProduct(request: FollowProductRequest) {
        GCD.FOLLOW_PRODUCT.update.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.FOLLOW_PRODUCT.update, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveFollowProductResponse(response: success)
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
