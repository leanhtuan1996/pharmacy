//
//  UserManager.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/20/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    static let shared = UserManager()
    
    let userDefault = UserDefaults.standard
    
    var currentUser: UserObject?
    
    func isLoggedIn() -> Bool {
        if userDefault.bool(forKey: "isLoggedIn") {
            return false
        }
        return false
    }
    
    func setToken(token: String) {
        userDefault.set(token, forKey: "token")
    }
    
    func getToken() -> String? {
        if let token = userDefault.object(forKey: "token") as? String {
            return token
        }
        return nil
    }
    
    func delToken() {
        if let _ = userDefault.object(forKey: "token") as? String {
            userDefault.removeObject(forKey: "token")
        }
    }
    
    func setIsLoggedIn() {
        userDefault.set(true, forKey: "isLoggedIn")
    }
    
    func setIsLoggedOut() {
        userDefault.removeObject(forKey: "isLoggedIn")
    }
    
}
