//
//  AppDelegate.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/20/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let manager = NetworkReachabilityManager(host: "www.google.com")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //check network
        manager?.listener = { status in
            
            switch status {
            case .notReachable:
                print("Network not reachable")
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                print("Network was reachable")
            default:
                print("Can't detect network")
            }
            
        }
        manager?.startListening()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
    
    func showMainView() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabController")
        self.window?.rootViewController = vc
    }
    
    func showSignInView() {
        let vc = UIStoryboard(name: "SignInUp", bundle: nil).instantiateViewController(withIdentifier: "navSignInUp")
        self.window?.rootViewController = vc
    }
    
    func showAdminView() {
        let vc = UIStoryboard(name: "Admin", bundle: nil).instantiateViewController(withIdentifier: "tabController")
        self.window?.rootViewController = vc
    }
    
    func signIn_Up(user: UserObject) {
        
        let alert = UIAlertController(title: "Login error", message: "Hiện tại chưa có ứng dụng dành cho admin.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        UserManager.shared.currentUser = user
        
        //set token to NSUserDefault & UserNetwork
        UserManager.shared.setToken(token: user.token)
        authToken = user.token
        
        switch user.role {
        case .admin:
            showAdminView()
        case .customer:
            showMainView()
        }
        
    }
    
    func SignOut() {
        print("SIGNOUT")
        UserManager.shared.currentUser = nil
        UserManager.shared.delToken()
        authToken = nil
        showSignInView()
    }
}

