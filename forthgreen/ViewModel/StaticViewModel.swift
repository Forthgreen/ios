//
//  StaticViewModel.swift
//  forthgreen
//
//  Created by Rohit Saini on 20/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol StaticDataDelegate {
    func didReceivedStaticData(response:StaticResponse)
}

struct StaticViewModel {
    var delegate:StaticDataDelegate?
    func fetchStaticData(){
        let params: [String:Any] = [String:Any]()
        GCD.AddDetails.staticDetails.async {
            APIManager.sharedInstance.I_AM_COOL(params: params, api: API.AddDetails.staticDetails, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(StaticResponse.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didReceivedStaticData(response: success)
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
