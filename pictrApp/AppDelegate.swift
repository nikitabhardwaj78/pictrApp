//
//  AppDelegate.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 2/27/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import CoreLocation
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import UserNotifications
import UserNotificationsUI


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       Thread.sleep(forTimeInterval : 3)
//        IQKeyboardManager.sharedManager().enable = true
        FirebaseApp.configure()
     
        
        
        
        
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            
            // If your app wasn’t running and the user launches it by tapping the push notification, the push notification is passed to your app in the launchOptions
            
            let aps = notification["aps"] as! [String: AnyObject]
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        registerForPushNotifications()
   
        GMSPlacesClient.provideAPIKey("AIzaSyBTwqrAYACPBmp9E8v3aHha7G-JgUtVoOw")
        GMSServices.provideAPIKey("AIzaSyBTwqrAYACPBmp9E8v3aHha7G-JgUtVoOw")
       
        configureInitialRootViewController(for: window)


        return true
     
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // Override point for customization after application launch.
        //return true
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

 
}
extension AppDelegate {
    func configureInitialRootViewController(for window: UIWindow?) {
        let defaults = UserDefaults.standard
        let initialViewController: UIViewController
        
        if Auth.auth().currentUser != nil,
            let userData = defaults.object(forKey: Constants.UserDefaults.currentUser) as? Data,
            let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? User {
            
            User.setCurrent(user)
            let mainStoryboard = UIStoryboard(name: "Main" , bundle: nil)
            let protectedPage = mainStoryboard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
            window!.rootViewController = protectedPage
             window!.makeKeyAndVisible()
            
        } else {
           print("Login New User")
        }
   
    }
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] (granted, error) in
                print("Permission granted: \(granted)")
                
                guard granted else {
                    print("Please enable \"Notifications\" from App Settings.")
                    self?.showPermissionAlert()
                    return
                }
                
                self?.getNotificationSettings()
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @available(iOS 10.0, *)
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        //UserDefaults.standard.set(token, forKey: DEVICE_TOKEN)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        // If your app was running and in the foreground
        // Or
        // If your app was running or suspended in the background and the user brings it to the foreground by tapping the push notification
        
        print("didReceiveRemoteNotification /(userInfo)")
        
        guard let dict = userInfo["aps"]  as? [String: Any], let msg = dict ["alert"] as? String else {
            print("Notification Parsing Error")
            return
        }
    }
    
    func showPermissionAlert() {
        let alert = UIAlertController(title: "WARNING", message: "Please enable access to Notifications in the Settings app.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) {[weak self] (alertAction) in
            self?.gotoAppSettings()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func gotoAppSettings() {
        
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.openURL(settingsUrl)
        }
    }
}
