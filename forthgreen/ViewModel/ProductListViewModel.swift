//
//  ProductListViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 14/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol ProductListDelegate {
    func didRecieveProductListResponse(productListResponse: ProductListResponse)
}

struct ProductListViewModel {
var delegate: ProductListDelegate?
    
    func ProductList(productListRequest: ProductListRequest) {
        
        var api: String = ""
        if AppModel.shared.isGuestUser {
            api = API.PRODUCT.guestListAll
        }
        else {
            api = API.PRODUCT.listAll
        }
        
        GCD.PRODUCT.listAll.async {
            APIManager.sharedInstance.I_AM_COOL(params: productListRequest.toJSON(), api: api, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(ProductListResponse.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveProductListResponse(productListResponse: success)
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
