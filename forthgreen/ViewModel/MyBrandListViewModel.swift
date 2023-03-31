//
//  MyBrandListViewModel.swift
//  forthgreen
//
//  Created by Rohit Saini on 16/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol MyBrandListDelegate {
    func didReceiveMyBrandListResponse(response:MyBrandResponse)
}


struct MyBrandListViewModel{
    var delegate:MyBrandListDelegate?
    func brandList(myBrandRequest:MyBrandRequest,page:Int){
        let params: [String: Any] = ["page":page]
      
        GCD.USER.myBrands.async {
            APIManager.sharedInstance.I_AM_COOL(params: params, api: API.USER.myBrands, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(MyBrandResponse.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didReceiveMyBrandListResponse(response: success)
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
