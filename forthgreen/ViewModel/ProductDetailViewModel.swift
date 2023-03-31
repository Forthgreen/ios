//
//  ProductDetailViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 16/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol ProductDetailDelegate {
    func didRecieveProductDetailResponse(response: ProductDetailResponse)
}

struct ProductDetailViewModel {
    var delegate: ProductDetailDelegate?
    
    func productDetail(productDetailRequest: ProductDetailRequest) {
        let params: [String: Any] = ["productRef": productDetailRequest.productRef]
        let api:String
        if AppModel.shared.isGuestUser {
            api = API.PRODUCT.detailForGuest
        }
        else {
            api = API.PRODUCT.details
        }
        GCD.PRODUCT.details.async {
            APIManager.sharedInstance.I_AM_COOL(params: params, api: api, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(ProductDetailResponse.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveProductDetailResponse(response: success)
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
