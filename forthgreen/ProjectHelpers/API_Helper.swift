//
//  API_Helper.swift
//  Trouvaille-ios
//
//  Created by MACBOOK on 01/04/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation


//MARK: - AppImageUrl
struct AppImageUrl {
    
    //Dev
//    static let IMAGE_BASE = "https://forthgreen.s3.us-east-2.amazonaws.com/development/images/"
    
    //Beta
//    static let IMAGE_BASE = "https://forthgreen.s3.us-east-2.amazonaws.com/beta/images/"
    
    //Staging
    static let IMAGE_BASE = "https://forthgreen.s3.us-east-2.amazonaws.com/staging/images/"
    
    static let small = IMAGE_BASE + "small/"
    static let average = IMAGE_BASE + "average/"
    static let best = IMAGE_BASE + "best/"
}

struct AppVideoUrl {
    //Dev
//    static let VIDEO_BASE = "https://forthgreen.s3.us-east-2.amazonaws.com/development/video/"
    
    //Beta
//    static let VIDEO_BASE = "https://forthgreen.s3.us-east-2.amazonaws.com/beta/video/"
    
    //Staging
    static let VIDEO_BASE = "https://forthgreen.s3.us-east-2.amazonaws.com/staging/video/"
}

//MARK: - API
struct API {
    //Development
 //   static let BASE_URL = "https://forthgreen.in.ngrok.io/api/"
    
//    BETA URL
  //    static let BASE_URL = "http://3.15.254.192/development/api/"
    
//    SSL Staging (Live)
    static let BASE_URL = "https://profile.forthgreen.com/staging/api/"
    
    
    struct USER {
        static let signup                 = BASE_URL + "user/signup"
        static let login                  = BASE_URL + "user/login"
        static let resendVerification     = BASE_URL + "user/resendVerification"
        static let socialLogin            = BASE_URL + "user/socialLogin"
        static let update                 = BASE_URL + "user/update"
        static let myBrands               = BASE_URL + "user/myBrands"
        static let details                = BASE_URL + "user/details"
        static let profile                = BASE_URL + "user/profile"
        static let logout                 = BASE_URL + "user/logout"
        static let search                 = BASE_URL + "user/search"
        static let deleteAccount          = BASE_URL + "user/deleteaccount"
    }
    
    struct RATE_AND_REVIEW {
        static let add                    = BASE_URL + "rateAndReview/add"
        static let list                   = BASE_URL + "rateAndReview/list"
        static let myList                 = BASE_URL + "rateAndReview/myList"
    }
    
    struct FOLLOW_BRAND {
        static let update                 = BASE_URL + "followBrand/update"
    }
    
    struct BRAND {
        static let detailForUser          = BASE_URL + "brand/detailsForUser"
        static let detailForGuest         = BASE_URL + "brand/detailsForGuest"
        static let list                   = BASE_URL + "brand/listForUser"
        static let guestList              = BASE_URL + "brand/list"
        static let search                 = BASE_URL + "brand/search"
    }
    
    struct REPORT {
        static let brandOrReview          = BASE_URL + "report/brandOrReview"
        static let post                   = BASE_URL + "report/post"
        static let user                   = BASE_URL + "report/user"
        static let comment                = BASE_URL + "report/comment"
    }
    
    struct PRODUCT {
        static let details                = BASE_URL + "product/details"
        static let listAll                = BASE_URL + "product/listAllForUser"
        static let guestListAll           = BASE_URL + "product/listAll"
        static let detailForGuest         = BASE_URL + "product/detailsGuest"
        static let productHome            = BASE_URL + "product/home"
        static let guestHomeForAll        = BASE_URL + "product/homeForAll"
    }
    
    struct AddDetails{
        static let staticDetails          = BASE_URL + "appDetails/list"
    }
    
    struct Statistics {
        static let productVisit           = BASE_URL + "statistics/productVisit"
        static let websiteClick           = BASE_URL + "statistics/websiteClick"
    }
    
    struct RESTAURANT {
        static let guestList              = BASE_URL + "restaurant/list"
        static let list                   = BASE_URL + "restaurant/listForUser"
        static let restaurantDetails      = BASE_URL + "restaurant/details"
        static let detailForGuest         = BASE_URL + "restaurant/detailsGuest"
        static let map                    = BASE_URL + "restaurant/map"
    }
    
    struct RATE_RESTAURANT {
        static let list                   = BASE_URL + "rateRestaurant/list"
        static let add                    = BASE_URL + "rateRestaurant/add"
    }
    
    struct TAG {
        static let list                   = BASE_URL + "tag/list"
    }
    
    struct BOOKMARK {
        static let list                   = BASE_URL + "bookmark/list"
        static let add                    = BASE_URL + "bookmark/add"
    }
    
    struct FOLLOW_RESTAURANT {
        static let list                   = BASE_URL + "followRestaurant/list"
        static let update                 = BASE_URL + "followRestaurant/update"
    }
    
    struct FOLLOW_PRODUCT {
        static let list                   = BASE_URL + "followProduct/list"
        static let update                 = BASE_URL + "followProduct/update"
    }
    
    struct POST {
        static let add                    = BASE_URL + "post/add"
        static let delete                 = BASE_URL + "post/delete"
        static let like                   = BASE_URL + "post/like"
        static let homeFeed               = BASE_URL + "post/feed"
        static let guestFeed              = BASE_URL + "post/guestFeed"
        static let likeList               = BASE_URL + "post/likeList"
        static let feedfollowing          = BASE_URL + "post/feedfollowing"
    }
    
    struct COMMENTS {
        static let add                    = BASE_URL + "comment/add"
        static let delete                 = BASE_URL + "comment/delete"
        static let like                   = BASE_URL + "comment/like"
        static let list                   = BASE_URL + "comment/list"
    }
    
    struct FOLLOW_USER {
        static let user                   = BASE_URL + "follow/user"
        static let list                   = BASE_URL + "follow/list"
    }
    
    struct NOTIFICATION {
        static let list                   = BASE_URL + "notification/list"
        static let seen                   = BASE_URL + "notification/seen"
        static let details                = BASE_URL + "notification/details"
    }
}

//MARK:- GCD
//MultiThreading
struct GCD{
    struct USER {
        static let signup = DispatchQueue(label: "com.app.USER_signup", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent) //1
        static let login = DispatchQueue(label: "com.app.USER_login", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent) //2
        static let resendVerification = DispatchQueue(label: "com.app.USER_resendVerification", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent) //3
        static let socialLogin = DispatchQueue(label: "com.app.USER_socialLogin", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent) //4
        static let update = DispatchQueue(label: "com.app.USER_update", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent) //5
        static let myBrands = DispatchQueue(label: "com.app.USER_myBrands", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent) //6
        static let details = DispatchQueue(label: "com.app.USER_details", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent) //7
        static let deleteAccount = DispatchQueue(label: "com.app.USER_deleteAccount", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent) //8
    }
    
    struct RATE_AND_REVIEW {
        static let add = DispatchQueue(label: "com.app.RATE_AND_REVIEW_add", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent)  //1
        static let list = DispatchQueue(label: "com.app.RATE_AND_REVIEW_list", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent)  //2
        static let myList = DispatchQueue(label: "com.app.RATE_AND_REVIEW_myList", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent)  //3
    }
    
    struct FOLLOW_BRAND {
        static let update = DispatchQueue(label: "com.app.FOLLOW_BRAND_update", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent)   //1
    }
    
    struct BRAND {
        static let detailForUser = DispatchQueue(label: "com.app.BRAND_detailForUser", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent)    //1
        static let detailForGuest = DispatchQueue(label: "com.app.BRAND_detailForGuest", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent)    //2
        static let list = DispatchQueue(label: "com.app.BRAND_list", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent)    //3
        static let search = DispatchQueue(label: "com.app.BRAND_search", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent)    //3
    }
    
    struct REPORT {
        static let brandOrReview = DispatchQueue(label: "com.app.REPORT_brandOrReview", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent)   //1
    }
    
    struct PRODUCT {
        static let details = DispatchQueue(label: "com.app.PRODUCT_details", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent)  //1
        static let listAll = DispatchQueue(label: "com.app.PRODUCT_listAll", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent)  //2
    }
    
    struct AddDetails{
        static let staticDetails = DispatchQueue(label: "com.app.staticDetails", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent)  //2
    }
    
    struct Statistics {
        static let productVisit = DispatchQueue(label: "com.app.STATISTICS_productVisit", qos: DispatchQoS.background, attributes: .concurrent) //1
        static let websiteClick = DispatchQueue(label: "com.app.STATISTICS_websiteClick", qos: DispatchQoS.background, attributes: .concurrent)
    }
    
    struct RESTAURANT {
        static let list = DispatchQueue(label: "com.app.Restaurant_list", qos: DispatchQoS.utility, attributes: .concurrent) //1
        static let restaurantDetails = DispatchQueue(label: "com.app.Restaurant_restaurantDetails", qos: DispatchQoS.background, attributes: .concurrent) //2
        static let detailForGuest = DispatchQueue(label: "com.app.Restaurant_detailForGuest", qos: .background, attributes: .concurrent)    //3
    }
    
    struct RATE_RESTAURANT {
        static let list = DispatchQueue(label: "com.app.RATE_Restaurant_list", qos: DispatchQoS.utility, attributes: .concurrent) //1
        static let add = DispatchQueue(label: "com.app.RATE_Restaurant_add", qos: DispatchQoS.background, attributes: .concurrent) //2
    }
    
    struct FOLLOW_RESTAURANT {
        static let list = DispatchQueue(label: "com.app.FOLLOW_Restaurant_list", qos: DispatchQoS.utility, attributes: .concurrent) //1
        static let update = DispatchQueue(label: "com.app.FOLLOW_Restaurant_update", qos: DispatchQoS.background, attributes: .concurrent) //2
    }
    
    struct FOLLOW_PRODUCT {
        static let list = DispatchQueue(label: "com.app.FOLLOW_PRODUCT_list", qos: DispatchQoS.utility, attributes: .concurrent) //1
        static let update = DispatchQueue(label: "com.app.FOLLOW_PRODUCT_update", qos: DispatchQoS.background, attributes: .concurrent) //2
    }
}
