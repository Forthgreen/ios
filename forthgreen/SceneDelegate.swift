//
//  SceneDelegate.swift
//  forthgreen
//
//  Created by MACBOOK on 01/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        sceneAutoLogin(windowScene: windowScene)
        sceneDisplayingOnboarding(windowScene: windowScene)
    }
    
    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            if notifications.count > 0{
                UserDefaults.standard.set(true, forKey: USER_DEFAULT_KEYS.badgeCount.rawValue)
//                NotificationCenter.default.post(name: NOTIFICATIONS.UpdateBadge, object: nil)
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            }
        }
    }
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        let _ = ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation])
    }
    
    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    // MARK: - App tutorial
    @available(iOS 13.0, *)
    func sceneDisplayingOnboarding(windowScene:UIWindowScene) {
        // Keep count of number of times app has been launched
        let currentCount = UserDefaults.standard.integer(forKey: USER_DEFAULT_KEYS.launchCount.rawValue)
        UserDefaults.standard.set(currentCount+1, forKey: USER_DEFAULT_KEYS.launchCount.rawValue)
        UserDefaults.standard.synchronize()
        log.success("\nLaunch count scene delegate: \(currentCount)\n")/
        if currentCount == 0 {
            KeychainWrapper.standard.removeObject(forKey: KEY_CHAIN.apple.rawValue)
        }
    }
    
    //MARK: - sceneAutoLogin
    @available(iOS 13.0, *)
    func sceneAutoLogin(windowScene:UIWindowScene){
        if UserDefaults.standard.value(forKey: USER_DEFAULT_KEYS.token.rawValue) as? String != "" {
            guard let token = UserDefaults.standard.value(forKey: USER_DEFAULT_KEYS.token.rawValue) as?  String else{
                log.todo("No logged in user found yet")/
                AppModel.shared.isGuestUser = true
                //AppDelegate().sharedDelegate().navigateToDashboard()
                return
            }
            if let savedPerson = UserDefaults.standard.object(forKey: USER_DEFAULT_KEYS.currentUser.rawValue) as? Data {
                let decoder = JSONDecoder()
                if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                    AppModel.shared.currentUser = loadedPerson
                }
            }
            AppModel.shared.token = token
            // Adding the navigation controller into the app
            let navController = UINavigationController(rootViewController: CustomTabBarController())
            navController.navigationBar.isHidden = true
            
            //Setting up the parent window scene
            
            window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window?.windowScene = windowScene
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        }
        else{
            log.todo("No logged in user found yet")/
            AppModel.shared.isGuestUser = true
            //AppDelegate().sharedDelegate().navigateToDashboard()
        }
    }
}

