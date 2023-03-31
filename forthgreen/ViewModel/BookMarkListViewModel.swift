//
//  BookMarkListViewModel.swift
//  forthgreen
//
//  Created by iMac on 10/27/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

import SainiUtils

protocol BookMarkListDelegate {
    var restaurantHasMore: Box<Bool> { get set }
    var restaurantList: Box<[RestaurantListing]> { get set }
    func getBookMarkRestaurantListing(request: BookmarkListRequest)

    var productHasMore: Box<Bool> { get set }
    var productList: Box<[ProductList]> { get set }
    func getBookMarkProductListing(request: BookmarkListRequest)

    var brandHasMore: Box<Bool> { get set }
    var brandList: Box<[Brand]> { get set }
    func getBookMarkBrandListing(request: BookmarkListRequest)
    
//    func didRecieveBookmarkProductListingResponse(response: ProductListResponse)
//    func didRecieveBookmarkBrandListingResponse(response: MyBrandResponse)
//    func didRecieveBookmarkRestaurantListingResponse(response: FollowingRestaurantListingResponse)
}

struct BookMarkListViewModel: BookMarkListDelegate {
    var restaurantList: Box<[RestaurantListing]> = Box([RestaurantListing]())
    var restaurantHasMore: Box<Bool> = Box(Bool())

    var productList: Box<[ProductList]> = Box([ProductList]())
    var productHasMore: Box<Bool> = Box(Bool())

    var brandList: Box<[Brand]> = Box([Brand]())
    var brandHasMore: Box<Bool> = Box(Bool())
    
//    var delegate: BookMarkListDelegate?
    
    func getBookMarkRestaurantListing(request: BookmarkListRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.BOOKMARK.list, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(RestaurantListingResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
//                            self.delegate?.didRecieveBookmarkRestaurantListingResponse(response: success)
                            self.restaurantList.value += success.data
                            self.restaurantHasMore.value = success.hasMore
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
    
    func getBookMarkProductListing(request: BookmarkListRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.BOOKMARK.list, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(ProductListResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
//                            self.delegate?.didRecieveBookmarkProductListingResponse(response: success)
                            self.productList.value += success.data
                            self.productHasMore.value = success.hasMore
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
    
    func getBookMarkBrandListing(request: BookmarkListRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.BOOKMARK.list, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(MyBrandResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
//                            self.delegate?.didRecieveBookmarkBrandListingResponse(response: success)
                            self.brandList.value += success.data
                            self.brandHasMore.value = success.hasMore
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



