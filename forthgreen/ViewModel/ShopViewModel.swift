//
//  ShopVM.swift
//  forthgreen
//
//  Created by ARIS Pvt Ltd on 31/05/23.
//  Copyright © 2023 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol ShopViewDelegate {
    var shopHasMore: Box<Bool> { get set }
    var shopData: Box<[ShopData]> { get set }
}

struct ShopViewModel: ShopViewDelegate {

    var shopHasMore: Box<Bool> = Box(Bool())
    var shopData: Box<[ShopData]> = Box([ShopData]())
    
    func getShopList(request: ShopPageRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(),
                                                api: API.PRODUCT.productShop, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(ShopObject.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            if request.page == 1 {
                                self.shopData.value.removeAll()
                            }
                            self.shopData.value += success.data ?? []
                            self.shopHasMore.value = success.hasMore ?? false
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
