//
//  ProductHomeViewModel.swift
//  forthgreen
//
//  Created by iMac on 1/24/22.
//  Copyright © 2022 SukhmaniKaur. All rights reserved.
//

import Foundation


protocol ProductHomeListDelegate {
    var success: Box<Bool> { get set }
    var productList: Box<[ProductCategoryList]> { get set }
    func getProductList()
}

struct ProductHomeViewModel: ProductHomeListDelegate {
    var productList: Box<[ProductCategoryList]> = Box([ProductCategoryList]())
    var success: Box<Bool> = Box(Bool())
    
    func getProductList() {
        DispatchQueue.global().async {
            
            var api : String = String()
            if AppModel.shared.isGuestUser {
                api = API.PRODUCT.guestHomeForAll
            }
            else{
                api = API.PRODUCT.productHome
            }
            
            APIManager.sharedInstance.I_AM_COOL(params: [String: Any](), api: api, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(ProductHomeResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.success.value = true
                            self.productList.value += success.data
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
    
//    func followUser(userId: String, followStatus: Bool) {
//        for index in 0..<productList.value.count where productList.value[index].id == userId {
//            productList.value[index].isBookmark = followStatus
//        }
//    }
    
}
