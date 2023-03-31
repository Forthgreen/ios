//
//  AppDelegate.swift
//  forthgreen
//
//  Created by MACBOOK on 01/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import NVActivityIndicatorView
import IQKeyboardManagerSwift
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import UserNotifications
import AuthenticationServices
import Branch
import SideMenu
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    var SocialLoginVM: SocialLoginViewModel = SocialLoginViewModel()
    private var staticVM: StaticViewModel = StaticViewModel()
    var window: UIWindow?
    var customTabbarVc: CustomTabBarController!
    var userFcmToken: String = ""
    var activityLoader : NVActivityIndicatorView!
    var backView: UIView!
    private var pushNotificationType: NOTIFICATION_TYPE = .comment
    let signInConfig = GIDConfiguration.init(clientID: GOOGLE.CLIENT_ID.rawValue)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SocialLoginVM.delegate = self
        
        window?.backgroundColor = WhiteColor
        
        if #available(iOS 15, *) {
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = textAttributes
            appearance.backgroundColor = WhiteColor//UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
            appearance.shadowColor = colorFromHex(hex: "F2F3F4") //.clear  //removing navigationbar 1 px bottom border.
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        //Firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        //IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        //Google login
//        GIDSignIn.sharedInstance().clientID = GOOGLE.CLIENT_ID.rawValue
//        GIDSignIn.sharedInstance().delegate = self
            
        // auto-Login
        autoLogin()
        
        //IOS 13 windows management
        //        if #available(iOS 13.0, *) {
        //
        //        }
        //        else{
        //            displayingOnboarding()
        //        }
        //
        //registering for notifications
        registerForPushNotifications()
        // if you are using the TEST key
        Branch.setUseTestBranchKey(false)
        //
        //        // listener for Branch Deep Link data
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            // do stuff with deep link data (nav to page, display content, etc)
            log.success("\n\n********************")/
            print(params as? [String: AnyObject] ?? {})
            log.success("********************\n\n")/
            if let mappingType = params![BRANCH_IO.INTENT_DEEP_LINK_PAYLOAD_MAPPING] as? String{
                if let payload : [String : Any] = params![BRANCH_IO.INTENT_DEEP_LINK_PAYLOAD] as? [String : Any] {
                    log.success("\(payload)")/
                    var receivedId = ""
                    if let id = payload["_id"] as? String{
                        receivedId = id
                    }
                    //Brand
                    if mappingType == PayloadMappingType.brand.rawValue{
                        
                        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BrandDetailVC") as! BrandDetailVC
                        vc.brandId =  receivedId
                        if let visibleViewController = visibleViewController(){
                            visibleViewController.navigationController?.pushViewController(vc, animated: false)
                        }
                    }
                    //Product
                    else if mappingType == PayloadMappingType.product.rawValue{
                        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
                        vc.productId = receivedId
                        if let visibleViewController = visibleViewController(){
                            visibleViewController.navigationController?.pushViewController(vc, animated: false)
                        }
                    }//home
                    else if mappingType == PayloadMappingType.home.rawValue {
                        let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
                        vc.userId = receivedId
                        if let visibleViewController = visibleViewController(){
                            visibleViewController.navigationController?.pushViewController(vc, animated: false)
                        }
                    }
                    // Restaurant
                    else {
                        let vc = STORYBOARD.RESTAURANT.instantiateViewController(withIdentifier: "RestaurantDetailVC") as! RestaurantDetailVC
                        vc.restaurantId = receivedId
                        if let visibleViewController = visibleViewController(){
                            visibleViewController.navigationController?.pushViewController(vc, animated: false)
                        }
                    }
                }
            }
        }
        
        staticVM.delegate = self
        staticVM.fetchStaticData()
        
        displayingOnboarding()
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
      // pass the url to the handle deep link call
      Branch.getInstance().continue(userActivity)
      return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            if notifications.count > 0{
                UserDefaults.standard.set(true, forKey: USER_DEFAULT_KEYS.badgeCount.rawValue)
                //                NotificationCenter.default.post(name: NOTIFICATIONS.UpdateBadge, object: nil)
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            }
        }
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return handled
    }
    
    //MARK:- sharedDelegate
    func sharedDelegate() -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //MARK: - storyboard
    func storyboard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    //MARK: - navigateToDashboard
    func navigateToDashboard()
    {
        customTabbarVc = self.storyboard().instantiateViewController(withIdentifier: "CustomTabBarController") as? CustomTabBarController
        let navigationController = UINavigationController(rootViewController: customTabbarVc)
        navigationController.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
    
    //MARK:- showLoader
    func showLoader()
    {
        removeLoader()
        backView?.isUserInteractionEnabled = false
        backView = UIView(frame: UIScreen.main.bounds)
        backView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
        activityLoader = NVActivityIndicatorView(frame: CGRect(x: ((backView?.frame.size.width)!-50)/2, y: ((backView?.frame.size.height)!-50)/2, width: 50, height: 50))
        activityLoader.type = .ballScaleMultiple
        activityLoader.color = AppColors.LoaderColor
        backView.addSubview(activityLoader)
        activityLoader.startAnimating()
        UIApplication.shared.keyWindow?.addSubview(backView)
        UIApplication.shared.keyWindow?.bringSubviewToFront(backView)
        
    }
    
    //MARK: - removeLoader
    func removeLoader()
    {
        
        backView?.isUserInteractionEnabled = true
        if activityLoader == nil
        {
            return
        }
        activityLoader.stopAnimating()
        backView.removeFromSuperview()
        activityLoader = nil
    }
    
    func vibrateOnTouch() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("*********** //////////// vibrate ///////////// *************")
    }
    
    //MARK:- autoLogin
    private func autoLogin(){
        if UserDefaults.standard.value(forKey: USER_DEFAULT_KEYS.token.rawValue) as? String != "" {
            guard let token = UserDefaults.standard.value(forKey: USER_DEFAULT_KEYS.token.rawValue) as? String else{
                log.todo("No logged in user found yet")/
                AppModel.shared.isGuestUser = true
                //navigateToDashboard()
                return
            }
            
            if let savedPerson = UserDefaults.standard.object(forKey: USER_DEFAULT_KEYS.currentUser.rawValue) as? Data {
                let decoder = JSONDecoder()
                if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                    AppModel.shared.currentUser = loadedPerson
                }
            }
            AppModel.shared.token = token
            if UserDefaults.standard.value(forKey: USER_DEFAULT_KEYS.token.rawValue) as? String != ""{
                //navigate to home Screen
                log.info("\(AppModel.shared.currentUser?.firstName ?? DocumentDefaultValues.Empty.string) is verified")/
                log.success("\(AppModel.shared.currentUser?.firstName ?? DocumentDefaultValues.Empty.string) is autologin successfully!")/
                log.push("HomeVC")/
                self.navigateToDashboard()
            }
        }
        else{
            log.todo("No logged in user found yet")/
            AppModel.shared.isGuestUser = true
            // navigateToDashboard()
        }
    }
    
    //MARK: - Login Data
    func getLoginUserData() -> [String  :Any]
    {
        if let dict : [String  :Any] = UserDefaults.standard.value(forKey: "LoginData") as? [String  :Any]
        {
            return dict
        }
        return [String  :Any]()
    }
    
    //MARK: - getFcmToken
    func getFcmToken() -> String
    {
        if userFcmToken == ""
        {
            if let token = Messaging.messaging().fcmToken
            {
                userFcmToken = token
            }
        }
        return userFcmToken
    }
    
    // MARK: - App tutorial
    func displayingOnboarding() {
        
        // Keep count of number of times app has been launched
        let currentCount = UserDefaults.standard.integer(forKey: USER_DEFAULT_KEYS.launchCount.rawValue)
        UserDefaults.standard.set(currentCount+1, forKey:USER_DEFAULT_KEYS.launchCount.rawValue)
        UserDefaults.standard.synchronize()
        log.success("\nLaunch count app delegate: \(currentCount)\n")/
        if currentCount == 0 {
            KeychainWrapper.standard.removeObject(forKey: KEY_CHAIN.apple.rawValue)
        }
    }
    
    //MARK: - SetUp of SideMenu
    func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.leftMenuNavigationController = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        
        //
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        // SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        //SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.defaultManager.leftMenuNavigationController?.menuWidth = UIScreen.main.bounds.size.width
        SideMenuManager.defaultManager.leftMenuNavigationController?.presentationStyle = .menuSlideIn
        SideMenuManager.defaultManager.leftMenuNavigationController?.presentationStyle.backgroundColor = .clear
        SideMenuManager.defaultManager.leftMenuNavigationController?.statusBarEndAlpha = 0
        SideMenuManager.defaultManager.leftMenuNavigationController?.alwaysAnimate = true
        SideMenuManager.defaultManager.leftMenuNavigationController?.presentationStyle.presentingEndAlpha = 1 // 0.8
        SideMenuManager.defaultManager.leftMenuNavigationController?.presentationStyle.onTopShadowOpacity = 1 //0.5
        SideMenuManager.defaultManager.leftMenuNavigationController?.presentationStyle.onTopShadowRadius = 5
        SideMenuManager.defaultManager.leftMenuNavigationController?.presentationStyle.onTopShadowColor = .black
        SideMenuManager.defaultManager.leftMenuNavigationController?.pushStyle = .default
        
    }
}

//MARK: - MessagingDelegate
extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        userFcmToken = fcmToken!
        AppModel.shared.fcmToken = userFcmToken
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END ios_10_data_message]
}

//MARK:- Google Login
extension AppDelegate {
    func signUpWithGoogle(vc: UIViewController) {
        GIDSignIn.sharedInstance.signOut()
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: vc) { user, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                print(user?.userID ?? "")                  // For client-side use only!
                print(user?.authentication.idToken ?? "") // Safe to send to the server
                print(user?.profile?.name ?? "")
                print(user?.profile?.givenName ?? "")
                print(user?.profile?.familyName ?? "")
                print(user?.profile?.email ?? "")
                print(user?.profile?.imageURL(withDimension: 500) ?? "")
                
                
                var userDict : [String : Any] = [String : Any]()
                if let gId = user?.userID {
                    userDict["id"] = gId
                }
                if let email = user?.profile?.email {
                    userDict["email"] = email
                }
                if let first_name = user?.profile?.name {
                    userDict["firstName"] = first_name
                }
                if var last_name = user?.profile?.familyName {
                    let first_name : String = userDict["firstName"] as! String
                    last_name = last_name.replacingOccurrences(of: first_name, with: "")
                    userDict["lastName"] = last_name
                }
                userDict["accessToken"] = user?.authentication.idToken
                
                var GoogleDict : [String : Any] = [String : Any]()
                GoogleDict["socialIdentifier"] = 2
                GoogleDict["socialId"] = userDict["id"]
                GoogleDict["firstName"] = userDict["firstName"]
                if let picture = user?.profile?.imageURL(withDimension: 500)
                {
                    GoogleDict["image"] = picture.absoluteString
                }
                GoogleDict["socialToken"] = userDict["accessToken"]
                GoogleDict["email"] = userDict["email"]
                GoogleDict["fcmToken"] = AppModel.shared.fcmToken
                GoogleDict["device"] = "ios"
                GoogleDict["gender"] = GENDER_TYPE.other.rawValue
                print(GoogleDict)
                self.SocialLoginVM.SocialLogin(params: GoogleDict)
            }
        }
    }
}

//MARK:- Facebook Login
extension AppDelegate {
    //==============FACEBOOK LOGIN====================
    func loginWithFacebook()
    {
        let fbLoginManager = LoginManager()
        fbLoginManager.logOut()
        
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: window?.rootViewController) { (result, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let token = result?.token else {
                return
            }
            
            let accessToken = token.tokenString 
            
            let request : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields" : "picture.width(500).height(500), email, id, name, first_name"])
            self.showLoader()
            let connection : GraphRequestConnection = GraphRequestConnection()
            
            connection.add(request, completionHandler: { (connection, result, error) in
                self.removeLoader()
                if result != nil
                {
                    let dict = result as! [String : AnyObject]
                    print(dict)
                    
                    var userDict : [String : Any] = [String : Any]()
                    
                    if let fbId = dict["id"]
                    {
                        userDict["id"] = fbId as! String
                    }
                    
                    if let email = dict["email"]
                    {
                        userDict["email"] = email as! String
                    }
                    
                    if let name = dict["name"]
                    {
                        userDict["firstName"] = name
                    }
                    
                    userDict["accessToken"] = accessToken
                    
                    
                    var facebookDict : [String : Any] = [String : Any]()
                    facebookDict["socialIdentifier"] = 1
                    facebookDict["socialId"] =  userDict["id"]
                    facebookDict["firstName"] = userDict["firstName"]
                    if let picture = dict["picture"] as? [String : Any]
                    {
                        if let data = picture["data"] as? [String : Any]
                        {
                            if let url = data["url"]
                            {
                                facebookDict["picture"] = url as! String
                            }
                        }
                    }
                    facebookDict["socialToken"] = userDict["accessToken"]
                    facebookDict["email"] = userDict["email"]
                    facebookDict["fcmToken"] = AppModel.shared.fcmToken
                    facebookDict["device"] = "ios"
                    facebookDict["gender"] = GENDER_TYPE.other.rawValue
                    print(facebookDict)
                    self.SocialLoginVM.SocialLogin(params: facebookDict)
                }
                else
                {
                    print(error?.localizedDescription ?? "error")
                }
            })
            connection.start()
        }
    }
}

extension AppDelegate{
    //MARK: - ============= LOGIN WITH APPLE ================
    
    func LoginWithApple(appleUser: AppleUser,socialToken:String) {
        let appleParams: [String: Any] = ["socialId": appleUser.id,
                                          "socialToken": socialToken,
                                          "socialIdentifier": 3,
                                          "device": "ios" ,
                                          "fcmToken": AppModel.shared.fcmToken,
                                          "gender":GENDER_TYPE.other.rawValue,
                                          "firstName":appleUser.firstName,
                                          "lastName":appleUser.lastName,
                                          "email":appleUser.email]
        self.SocialLoginVM.SocialLogin(params: appleParams)
    }
}

//MARK: - SocialLoginDelegate
extension AppDelegate: SocialLoginDelegate {
    func DidRecieveSocialResponse(loginResponse: LoginResponse?) {
        AppModel.shared.currentUser = loginResponse?.data?.user
        AppModel.shared.currentUser?.isSocialUser = true
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(AppModel.shared.currentUser) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: USER_DEFAULT_KEYS.currentUser.rawValue)
        }
        UserDefaults.standard.set(loginResponse?.data?.accessToken, forKey: USER_DEFAULT_KEYS.token.rawValue)
        AppModel.shared.token = loginResponse?.data!.accessToken ?? DocumentDefaultValues.Empty.string
        AppModel.shared.isGuestUser = false
        switch AppModel.shared.guestUserType{
        case .BrandListing:
            NotificationCenter.default.post(name: NOTIFICATIONS.Refresh, object: nil)
            if let visibleViewController = visibleViewController(){
                visibleViewController.navigationController?.popToRootViewController(animated: true)
            }
            break
        case .BrandDetailFollow:
            NotificationCenter.default.post(name: NOTIFICATIONS.Refresh, object: nil)
            if let visibleViewController = visibleViewController(){
                visibleViewController.navigationController?.dismiss(animated: true, completion: nil)
            }
            break
        case .ProductDetailReview:
            NotificationCenter.default.post(name: NOTIFICATIONS.Refresh, object: nil)
            if let visibleViewController = visibleViewController(){
                visibleViewController.navigationController?.dismiss(animated: true, completion: nil)
            }
            break
        case .Setting:
            NotificationCenter.default.post(name: NOTIFICATIONS.Refresh, object: nil)
            if let visibleViewController = visibleViewController(){
                visibleViewController.navigationController?.dismiss(animated: true, completion: nil)
            }
            break
        default:
            AppDelegate().sharedDelegate().navigateToDashboard()
            break
        }
    }
}

extension AppDelegate:StaticDataDelegate{
    func didReceivedStaticData(response: StaticResponse) {
        AppModel.shared.staticData = response.data
    }
}

//MARK:- Firebase Notifications Setup
//**************************************************************************************************************************************************
//MARK:- Notifications Setup START **********************************************************************************************************************************************************************
extension AppDelegate{
    
    //MARK:- Asking for user Permission to send notifications
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            [weak self] granted, error in
            
            log.success("Permission granted: \(granted)")/
            guard granted else { return }
            UNUserNotificationCenter.current().delegate = self
            self?.getNotificationSettings()
        }
    }
    
    //MARK:- Notification Settings
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            log.info("Notification settings: \(settings)")/
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

//MARK:- Notifications Delegate Methods
extension AppDelegate:UNUserNotificationCenterDelegate{
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        log.success("Device Token: \(token)")/
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.error("Failed to register: \(error)")/
    }
    
    //MARK:- This Method is responsible for Receieve Notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        log.info("userInfo: \n\(userInfo)")/
        //MARK:- Badge Count
        
        UserDefaults.standard.set(true, forKey: USER_DEFAULT_KEYS.badgeCount.rawValue)
        NotificationCenter.default.post(name: NOTIFICATIONS.UpdateBadge, object: nil)
        completionHandler([.alert,.badge,.sound])
    }
    
    //MARK:- If you wanna receive silent notifications you need to comment the above delegate method (willPresent notification)
    //MARK:- Handling Silent Notifications
    func application( _ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void ) {
        log.info("\(userInfo)")/
        
        UserDefaults.standard.set(true, forKey: USER_DEFAULT_KEYS.badgeCount.rawValue)
        NotificationCenter.default.post(name: NOTIFICATIONS.UpdateBadge, object: nil)
        completionHandler(.newData)
    }
    
    //MARK:- Handling Notifications on Tap Actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        log.info("\(userInfo)")/
        if let payload = userInfo["gcm.notification.payload"] as? String {
            let payloadDict : [String : Any] = convertToDictionary(text: payload) ?? [String : Any]()
            guard let notificationType : Int = payloadDict["refType"] as? Int else { return }
            pushNotificationType = NOTIFICATION_TYPE(rawValue: Int(notificationType))!
            if pushNotificationType == .following {
                guard let sourceId : String = payloadDict["userRef"] as? String else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.OtherUserProfileVC.rawValue) as! OtherUserProfileVC
                    vc.userId = sourceId
                    if let visibleViewController = visibleViewController(){
                        visibleViewController.navigationController?.pushViewController(vc, animated: false)
                    }
                }
            }
            else {
                guard let sourceId : String = payloadDict["notificationId"] as? String else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.PostDetailVC.rawValue) as! PostDetailVC
                    vc.ref = sourceId
                    vc.refType = self.pushNotificationType
                    if let visibleViewController = visibleViewController(){
                        visibleViewController.navigationController?.pushViewController(vc, animated: false)
                    }
                }
            }
        }
        completionHandler()
    }
}
//MARK:- Notifications Setup END **********************************************************************************************************************************************************************


extension UIApplication {
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

extension AppDelegate {
    
    public func showErrorToast(message: String, _ isSuccess : Bool? = false) {
        if message == "" {
            return
        }
        
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            
            let toastLbl = UILabel()
            if isSuccess! {
                toastLbl.text = message
            }else{
                toastLbl.text = "SOMETHING WENT WRONG.\n" + message
            }
            
            toastLbl.textAlignment = .left
            toastLbl.font = UIFont.systemFont(ofSize: 14)
            toastLbl.textColor = colorFromHex(hex: "FFFFFF")
            toastLbl.numberOfLines = 0
            
            
            let textSize = toastLbl.intrinsicContentSize
            let labelHeight = ( textSize.width / window.frame.width ) * 30
            let labelWidth = min(textSize.width, window.frame.width - 80)
            let adjustedHeight = max(labelHeight, textSize.height + 20)
            
            
            let toastView = UIView(frame: CGRect(x: 16, y: (window.frame.height - 90 ) - adjustedHeight, width: SCREEN.WIDTH-32, height: adjustedHeight + 10))
            toastView.backgroundColor = UIColor.black
            toastLbl.frame = CGRect(x: 10, y: 5, width: toastView.frame.size.width-20, height: adjustedHeight)
            toastView.center.x = window.center.x
            toastView.addSubview(toastLbl)
            
            window.addSubview(toastView)
            
            delay(2.0) {
                UIView.animate(withDuration: 3.0, animations: {
                    toastView.alpha = 0
                }) { (_) in
                    toastView.removeFromSuperview()
                }
            }
        }
    }
}

extension AppDelegate {
    func addPost(request: AddPostRequest, imageData: [UploadImageInfo], video : UploadImageInfo?) {
        let socialFeedVM = SocialFeedViewModel.init()
        socialFeedVM.addNewPost(request: request, imageData: imageData, video: video) { progress in
            //progress
            print(progress)
            NotificationCenter.default.post(name: NOTIFICATIONS.AddPostProgress, object: ["progress" : progress])
        } _: {
            //finish
            NotificationCenter.default.post(name: NOTIFICATIONS.AddPostProgress, object: ["progress" : 100.0])
        }
    }
}
