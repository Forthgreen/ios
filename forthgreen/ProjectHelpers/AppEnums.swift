//
//  AppEnums.swift
//  forthgreen
//
//  Created by MACBOOK on 14/01/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

//MARK: USER_DEFAULT_KEYS
enum USER_DEFAULT_KEYS: String {
    case currentUser, token, launchCount, myBrandList, badgeCount, lastIndex
}

//MARK: - COLLECTION_VIEW_CELL
enum COLLECTION_VIEW_CELL: String {
    case OnboardingCell, postImageCell
}

//MARK: - TABLE_VIEW_CELL
enum TABLE_VIEW_CELL: String {
    case socialFeedCell, NotificationCell, ProfileInfoCell, UserInfoCell, OtherUserProfileInfoCell, CommentCell, AddCommentCell, ReplyCell, addPostCell, SearchCategoryTVC, FilterSelectedTVC, ReportTypeCell
    case ShopCell
}

//MARK: - MAIN_STORYBOARD
enum MAIN_STORYBOARD: String {
    case WelcomeVC, LoginVC, SignUpVC, ForgotPasswordVC
}

//MARK: - HOME_STORYBOARD
enum HOME_STORYBOARD: String {
    case HomeVC, FilterVC, CategoryFilterVC
}

//MARK: - SOCIAL_FEED_STORYBOARD
enum SOCIAL_FEED_STORYBOARD: String {
    case OtherUserProfileVC, SearchPostVC, SocialFeedVC, PostDetailVC, RepliesVC, AddPostVC, CommentListVC, PostLikeVC, InviteUsersVC, AskLoginPopupVC
}

//MARK: - NOTIFICATION_STORYBOARD
enum NOTIFICATION_STORYBOARD: String {
    case NotificationVC
}

//MARK: - SETTING_STORYBOARD
enum SETTING_STORYBOARD: String {
    case SettingVC, EditProfileVC, ChangePasswordVC, MyReviewsVC, StaticVC, ProfileVC, FollowerListVC
}

//MARK: - MY_BRAND_STORYBOARD
enum MY_BRAND_STORYBOARD: String {
    case MyBrandListVC
}

//MARK: - APP_FONT
enum APP_FONT: String {
    case buenosAiresBook = "BuenosAires-Book"
    case buenosAiresBold = "BuenosAires-Bold"
}

//MARK: - STATIC_LABELS
enum STATIC_LABELS: String {
    case cancel = "Cancel"
    case removePost = "Remove Post"
    case removeComment = "Remove Comment"
    case removeReply = "Remove Reply"
    case reportAbuse = "Report Abuse"
    case report = "Report User"
    case blockUser = "Block User"
    case unblockUser = "Unblock User"
    case reportPost = "Report Post"
    case reportComment = "Report Comment"
    case reportReply = "Report Reply"
    
//    case addPostPlaceholder = "What do you want to share?"
    
    case termsLbl = "Terms & Conditions"
    case privacyPolicy = "Private Policy"
    case tappedNone = "Tapped none"
    case selectDate = "Select Date..."
    
    case imageToast = "Please add your picture"
    case nameToast = "Please enter Name"
    case emailToast = "Please enter email"
    case validEmailToast = "Please enter valid email"
    case usernameToast = "Please enter username"
    case passwordToast = "Please enter Password"
    case bioToast = "Please enter bio"
    case bioLimitToast = "Bio should be of 150 characters only."
    case copyToast = "copied to clipboard"
    
    case okLbl = "OK"
    case verification = "Verification"
    case verificationMsg = "An email has been sent to your inbox. Please verify your email to login."
    
    case emptyPostToast = "Kindly add text, image or video to post."
    case emptySearchMsg = "Nothing matches your search. Please try again."
    case noDataFound = "No Data Found."
    case noFollowUserDataFound = "Follow other users\nand see their updates here"
    case noPosts = "No posts yet."
    case noLikes = "No likes yet."
    case noComments = "No comments yet."
    case noReplies = "No replies yet."
    
//    case newCommentToast = "Comment Added Successfully."
//    case newReplyToast = "Reply Added Successfully."
    case deleteReplyToast = "Reply Deleted Successfully."
    case deleteCommentToast = "Comment Deleted Successfully."
    case deletePostSuccessToast = "Post Deleted Successfully"
    case profileUpdated = "Profile updated successfully"
    
    case noNotifications = "No Notifications yet."
    case blockUserTableMessage = "You’ve blocked this user."
    case blockByOtherUserMessage = "This user has blocked you."
    case noPostExist = "Post Deleted by the user."
    case noCommentExist = "Comment Deleted by the user."
    case noReplyExist = "Reply Deleted by the user."
    
    case loadMoreBtnTitle = "LOAD MORE"
    case loadingBtnTitle = "LOADING..."
    case followBtnTitle = "FOLLOW"
    case followingBtnTitle = "FOLLOWING"
    case viewProducts = "VIEW PRODUCTS"
    case viewRestaurants = "VIEW RESTAURANTS"
    case allBtnTitle = "ALL"
    case clearBtnTitle = "CLEAR"
    case categories = "Categories"
    case filter = "Filter"
    case invite = "INVITE"
    case invited = "INVITED"
    
//    case commentToast = "Kindly add your comment"
//    case replyToast = "Kindly add your reply"
    
    case atTheRate = "@"
    case currencySymbol = "£"
    case canonicalIdentifier = "content/12345"
    
    case appTitle = "Forthgreen"
    case shareProfile = "Follow this profile in Forthgreen! "
    
    case thanksLblForProduct = "Thank you for your feedback. We appreciate your vote."
    case thanksLblForUser = "Thank you for your feedback. We will review as soon as possible."
    
    case invitationSent = "Invitation sent"
    case invitationNotSend = "Couldn’t send the invitation. Try again later "
    case loginToContinue = "Login to Continue"
    case loginToContinueMessage = "It looks like you're not currently logged in. If you want to continue, you'll need to either Login or Create an Account."
    case login = "Login"
    case blockNotification = "This users will no longer be able to follow you, and you will not see notifications from this user."
    case block = "Block"
}

//MARK: - STATIC_URLS
enum STATIC_URLS: String {
    case termsAndConditions = "https://forthgreen.com/terms-and-conditions.html"
    case privacyPolicy = "https://forthgreen.com/privacy-policy.html"
    case aboutUs = "https://forthgreen.com/about.html"
    case leaveReview = "https://docs.google.com/forms/d/1L0_XD8zrM6YmQ2NUkFGRiwXZYX-zChlsQwlW-BxXA38/viewform?edit_requested=true"
}

//MARK: - DATE_STRINGS
enum DATE_STRINGS: String {
    case dob = "MM-dd-yyyy"
    case dobLbl = "dd/MM/yyyy"
}

//MARK: - PASSWORD_EYE_IMAGES
enum PASSWORD_EYE_IMAGES: String {
    case hide = "ic_hide"
    case show = "ic_show"
}

//MARK: - SAVE_BTN_TYPE
enum SAVE_BTN_TYPE: String {
    case save, unsave
    
    func getUperCased() -> String{
        return self.rawValue.uppercased()
    }
}

//MARK: - KEY_CHAIN
enum KEY_CHAIN:String{
    case apple
}

//MARK: - ONBOARDING_HEADING
enum ONBOARDING_HEADING: String, CaseIterable {
    case vegan = "Vegan Community"
    case explore = "Vegan Brands"
    case restaurant = "Vegan Restaurants"
    case planet = "Good for the Animals"
}

//MARK: - ONBOARDING_IMAGES
enum ONBOARDING_IMAGES: String, CaseIterable {
    case onboarding1, onboarding2, onboarding3, onboarding4
}

//MARK: - ONBOARDING_TEXT
enum ONBOARDING_TEXT: String, CaseIterable {
    case vegan = "Join the Forthgreen community to share and connect with others, follow, post and much more!"
    case veganBrands = "Cruelty-free foods, cosmetics, fashion, we’ve got it all. Simply browse, select, and shop on the brand’s website."
    case restaurant = "Discover the best vegan restaurants in your location. You can follow, rate and share Restaurants with friends."
    case planet = "Our carefully curated list showcases companies that are truly devoted to the ethos of veganism and cruelty-free."
}

//MARK: - POST_TYPES
enum POST_TYPES: Int, Encodable {
    case image = 1
    case text = 2
    case textWithImage = 3
    case user = 4
    case video = 5
    case textWithVideo = 6
}

//MARK: - GLOBAL_IMAGES
enum GLOBAL_IMAGES: String {
    case placeholderForBrands = "placeholder"
    case placeholderForProducts = "rectange"
    case placeholderForProfile = "ic_placeholder"
    case placeholderForVideo = "video_load"
}

//MARK: - STATIC_DATA
enum STATIC_DATA:Int{
    case terms = 1
    case privacy = 2
    case about = 3
}

//MARK: - GENDER_TYPE
enum GENDER_TYPE: Int {
    case male = 1
    case female = 2
    case other = 3
}

//MARK: - GuestUserType
enum GuestUserType:Int{
    case BrandDetailFollow = 1
    case ProductDetailReview = 2
    case BrandListing = 3
    case Setting = 4
    case none = 5
}

//MARK: - ShowNavBarView
enum ShowNavBarView{
    case Yes, No
}

//MARK: - isSameVC
enum isSameVC{
    case Yes, No
}

//MARK: - DisplayPopUpType
enum DisplayPopUpType: Int {
    case Follow = 1
    case Review = 2
    case Setting = 3
}

//MARK: - FILTER_TYPE
enum FILTER_TYPE {
    case restaurants, food, health, miscellaneous, drink
}

//MARK: - FILTER_BTN_TYPE
enum FILTER_BTN_TYPE {
    case all, clear
}

//MARK: - SELECTED_FILTER_GENDER
enum SELECTED_FILTER_GENDER: Encodable, CaseIterable {
    func encode(to encoder: Encoder) throws { }
    
    case women, men
    
    func getIntValue() -> Int{
        switch self {
        case .women:
            return 2
        case .men:
            return 1
        }
    }
}

//MARK: - SELECTED_FILTER_CATEGORY
enum SELECTED_FILTER_CATEGORY {
    case clothing, beauty, Accessories
}

//MARK: - REVIEW_TYPE
enum REVIEW_TYPE {
    case product, restaurant, none, brand, post, comment, user, reply
}

//MARK: - PayloadMappingType
enum PayloadMappingType: String{
    case brand = "1"
    case product = "2"
    case restaurant = "3"
    case home = "4"
}

//MARK: - GOOGLE
enum GOOGLE: String {
    case CLIENT_ID = "700251019899-dpfuf52caef5h9qeb35vut963ivll9mo.apps.googleusercontent.com"
}

//MARK: - LIKE_POST_IMAGES
enum LIKE_POST_IMAGES: String {
    case liked = "iconHeartSolid"
    case notLiked = "iconHeartOutline"
}

//MARK: - LIKE_POST_IMAGES_SMALL
enum LIKE_POST_IMAGES_SMALL: String {
    case liked = "iconHeartSolidSmall"
    case notLiked = "iconHeartOutlineSmall"
}

//MARK: - COMMENT_TYPE
enum COMMENT_TYPE: String, Encodable {
    case comment, reply
}

//MARK: - FOLLOW_LIST_TYPE
enum FOLLOW_LIST_TYPE: String, Encodable {
    case follower, following
}

//MARK: - REPORT_TYPE
enum REPORT_TYPE: Int, Encodable {
    case none = 0
    case postingNonVegan = 1
    case someoneElse = 2
    case prohibitedContent = 3
    case others = 4
}

//MARK: - NOTIFICATION_TYPE
enum NOTIFICATION_TYPE: Int {
    case comment = 1
    case replyComment = 2
    case postLike = 3
    case commentLike = 4
    case following = 5
    case replyLike = 6
}

//MARK: - USER_IS_FROM
enum USER_IS_FROM {
    case home, selfProfile, otherUserProfile, postDetail
}

//MARK: - PRODUCT_CATEGORIES
enum PRODUCT_CATEGORIES: Int, CaseIterable {
    case CLOTHING = 1
    case BEAUTY = 2
    case ACCESSORIES = 7
    case FOOD = 4
    case DRINK = 5
    case HEALTH = 3
    case MISCELLANEOUS = 6
    
    static var list: [Int] {
      return PRODUCT_CATEGORIES.allCases.map { $0.rawValue }
    }
    
    func getString() -> String {
        switch self {
        case .CLOTHING               : return "Clothing"
        case .BEAUTY                 : return "Beauty"
        case .HEALTH                 : return "Health"
        case .FOOD                   : return "Food"
        case .ACCESSORIES            : return "Accessories"
        case .MISCELLANEOUS          : return "Miscellaneous"
        case .DRINK                  : return "Drinks"
        }
    }
    
    func getStringUppercased() -> String {
        switch self {
        case .CLOTHING               : return "CLOTHING"
        case .BEAUTY                 : return "BEAUTY"
        case .HEALTH                 : return "HEALTH"
        case .FOOD                   : return "FOOD"
        case .ACCESSORIES            : return "ACCESSORIES"
        case .MISCELLANEOUS          : return "MISCELLANEOUS"
        case .DRINK                  : return "DRINKS"
        }
    }
    
    func getImage() -> String {
        switch self {
        case .CLOTHING               : return "clothing"
        case .BEAUTY                 : return "beauty"
        case .HEALTH                 : return "health"
        case .FOOD                   : return "drink"
        case .ACCESSORIES            : return "accessory"
        case .MISCELLANEOUS          : return "misse"
        case .DRINK                  : return "food"
        }
    }
}

//MARK: - SORT_ARR
enum SORT_ARR: Int, CaseIterable {
    case SORT1 = 1, SORT2, SORT3
    
    func getString() -> String {
        switch self {
        case .SORT1 : return "Newest first"
        case .SORT2 : return "Price low to high"
        case .SORT3 : return "Price high to low"
        }
    }
}

//MARK: - LIKE_TYPE
enum LIKE_TYPE: Int, CaseIterable   {
    case POST = 1
    case COMMENT = 2
}


//MARK: - POST_TYPES
enum BOOKMARK_TYPES: Int, Encodable {
    case PRODUCT = 1
    case BRAND = 2
    case RESTAURANT = 3
}


//MARK: - POST_TYPES
enum TAG_TYPES: Int, Encodable {
    case USERS = 1
    case BRAND = 2
    case RESTAURANTS = 3
}
