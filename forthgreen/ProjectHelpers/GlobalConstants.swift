//
//  GlobalConstants.swift
//  forthgreen
//
//  Created by MACBOOK on 04/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

//MARK: - STORYBOARD
struct STORYBOARD {
    static let MAIN = UIStoryboard(name: "Main", bundle: nil)
    static let SOCIAL_FEED = UIStoryboard(name: "SocialFeed", bundle: nil)
    static let HOME = UIStoryboard(name: "Home", bundle: nil)
    static let BRAND_LIST = UIStoryboard(name: "BrandList", bundle: nil)
    static let RESTAURANT = UIStoryboard(name: "Restaurants", bundle: nil)
    static let MY_BRAND = UIStoryboard(name: "MyBrand", bundle: nil)
    static let SETTING = UIStoryboard(name: "Setting", bundle: nil)
    static let NOTIFICATION = UIStoryboard(name: "Notification", bundle: nil)
}

//MARK:- AppColors
struct AppColors{
    static let LoaderColor =  UIColor.darkGray
    static let charcol = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let turqoiseGreen = #colorLiteral(red: 0.168627451, green: 0.8392156863, blue: 0.5843137255, alpha: 1)
    static let coolGray = #colorLiteral(red: 0.5921568627, green: 0.6470588235, blue: 0.662745098, alpha: 1)
    static let paleGrey = #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.9568627451, alpha: 1)
}

//MARK:- Notifications
struct NOTIFICATIONS{
    static let Refresh = Notification.Name("Refresh")
    static let RefreshProductReviews = Notification.Name("RefreshProductReviews")
    static let RefreshRestaurantReviews = Notification.Name("RefreshRestaurantReviews")
    static let UpdateBadge = Notification.Name("UpdateBadge")
    static let ProfileRefresh = Notification.Name("ProfileRefresh")
    
    static let BookmarkUpdateList = Notification.Name("BookmarkUpdateList")
    static let LoginSignupTabRedirection = Notification.Name("LoginSignupTabRedirection")
    static let AddPostProgress = Notification.Name("AddPostProgress")
    static let VideoPlay = Notification.Name("VideoPlay")
}

struct TAB {
    static let LOGIN = "Login"
    static let SIGNUP = "Signup"
}

//MARK:- DocumentDefaultValues
struct DocumentDefaultValues{
    struct Empty{
        static let string =  ""
        static let int =  0
        static let bool = false
        static let double = 0.0
    }
}

//MARK: - BRANCH_IO
struct BRANCH_IO{
    static let INTENT_DEEP_LINK_PAYLOAD = "deepLinkPayload"
    static let INTENT_DEEP_LINK_PAYLOAD_MAPPING = "deepLinkPayloadMapping"
    static let INTENT_DEEP_LINK_TIME_STAMP = "timeStamp"
}

//MARK: - FILTER_DATA
struct FILTER_DATA {
    static var RestaurantFilter = [
        FilterStatus(picture: "glutenFree", name: "Gluten-Free", isSelected: false,id:1),
        FilterStatus(picture: "organic", name: "Organic", isSelected: false,id:3),
        FilterStatus(picture: "pizza", name: "Pizza", isSelected: false,id:5),
        FilterStatus(picture: "cake", name: "Bakery", isSelected: false,id:7),
        FilterStatus(picture: "beer", name: "Pub", isSelected: false,id:9),
        FilterStatus(picture: "fast_food", name: "Fast food", isSelected: false,id:2),
        FilterStatus(picture: "juiceBar", name: "Juice bar", isSelected: false,id:4),
        FilterStatus(picture: "macrobiotic", name: "Macrobiotic", isSelected: false,id:6),
        FilterStatus(picture: "salad", name: "Salad bar", isSelected: false,id:8),
        FilterStatus(picture: "taco", name: "Take out", isSelected: false,id:10)]
    
    static var healthFilter = [
        FilterStatus(picture: "", name: "Supplements", isSelected: false, id: 1),
        FilterStatus(picture: "", name: "Sanitiser", isSelected: false, id: 2),
        FilterStatus(picture: "", name: "Other", isSelected: false, id: 3)
    ]
    
    static var foodFilter = [
        FilterStatus(picture: "", name: "Cheese", isSelected: false, id: 1),
        FilterStatus(picture: "", name: "Proteins", isSelected: false, id: 2),
        FilterStatus(picture: "", name: "Sauces", isSelected: false, id: 3),
        FilterStatus(picture: "", name: "Bars", isSelected: false, id: 4),
        FilterStatus(picture: "", name: "Other", isSelected: false, id: 5)
    ]
    
    static var drinkFilter = [
        FilterStatus(picture: "", name: "Beer", isSelected: false, id: 1),
        FilterStatus(picture: "", name: "Wine", isSelected: false, id: 2),
        FilterStatus(picture: "", name: "Soft drinks", isSelected: false, id: 3),
        FilterStatus(picture: "", name: "Spirits", isSelected: false, id: 4),
        FilterStatus(picture: "", name: "Other", isSelected: false, id: 5)
    ]
    
    static var accessoriesForWomen = [
        FilterStatus(picture: "", name: "Watches", isSelected: false, id: 1),
        FilterStatus(picture: "", name: "Backpacks", isSelected: false, id: 2),
        FilterStatus(picture: "", name: "Bags & Purses", isSelected: false, id: 3),
        FilterStatus(picture: "", name: "Jewelery", isSelected: false, id: 4),
        FilterStatus(picture: "", name: "Other", isSelected: false, id: 5)
    ]
    
    static var accessoriesForMen = [
        FilterStatus(picture: "", name: "Watches", isSelected: false, id: 1),
        FilterStatus(picture: "", name: "Backpacks", isSelected: false, id: 2),
        FilterStatus(picture: "", name: "Bags & Purses", isSelected: false, id: 3),
        FilterStatus(picture: "", name: "Jewelery", isSelected: false, id: 4),
        FilterStatus(picture: "", name: "Other", isSelected: false, id: 5)
    ]
    
    static var clothingForWomen = [
        FilterStatus(picture: "", name: "Top", isSelected: false, id: 4),
        FilterStatus(picture: "", name: "Bottoms", isSelected: false, id: 3),
        FilterStatus(picture: "", name: "Trainers and Shoes", isSelected: false, id: 5),
        FilterStatus(picture: "", name: "Active Wear", isSelected: false, id: 1),
        FilterStatus(picture: "", name: "Jackets and Coats", isSelected: false, id: 2)
    ]
    
    static var clothingForMen = [
        FilterStatus(picture: "", name: "Top", isSelected: false, id: 9),
        FilterStatus(picture: "", name: "Bottoms", isSelected: false, id: 8),
        FilterStatus(picture: "", name: "Trainers and Shoes", isSelected: false, id: 10),
        FilterStatus(picture: "", name: "Active Wear", isSelected: false, id: 6),
        FilterStatus(picture: "", name: "Jackets and Coats", isSelected: false, id: 7)
    ]
    
    static var beautyForWomen = [
        FilterStatus(picture: "", name: "Makeup", isSelected: false, id: 1),
        FilterStatus(picture: "", name: "Haircare", isSelected: false, id: 2),
        FilterStatus(picture: "", name: "Face", isSelected: false, id: 3),
        FilterStatus(picture: "", name: "Body", isSelected: false, id: 4),
        FilterStatus(picture: "", name: "Other", isSelected: false, id: 5)
    ]
    
    static var beautyForMen = [
        FilterStatus(picture: "", name: "Makeup", isSelected: false, id: 1),
        FilterStatus(picture: "", name: "Haircare", isSelected: false, id: 2),
        FilterStatus(picture: "", name: "Face", isSelected: false, id: 3),
        FilterStatus(picture: "", name: "Body", isSelected: false, id: 4),
        FilterStatus(picture: "", name: "Other", isSelected: false, id: 5)
    ]
    
    static var miscellaneous = [
        FilterStatus(picture: "", name: "Candles", isSelected: false, id: 1),
        FilterStatus(picture: "", name: "Aromatic oils", isSelected: false, id: 2),
        FilterStatus(picture: "", name: "Other", isSelected: false, id: 3)
    ]
}

//MARK: - REPORT_REASON
struct REPORT_REASON {
    static var reportArray: [String] = ["It’s posting non-vegan products", "It’s pretending to be someone else", "It’s prohibited content", "Other"]
}

//MARK: - SCREEN
struct SCREEN {
    static var WIDTH = UIScreen.main.bounds.size.width
    static var HEIGHT = UIScreen.main.bounds.size.height
}

