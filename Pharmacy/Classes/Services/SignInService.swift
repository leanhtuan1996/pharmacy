//
//  SignInService.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/20/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire
typealias JSON = [String: Any]

class SignInService: NSObject {
    static let shared = SignInService()
    
    let userDefaults = UserDefaults.standard
    
    func signIn(email: String, password: String, completionHandler: @escaping (_ success: Bool, _ user: UserObject?, _ error: String?) -> ()) {
        
        let parameters = [
            "email" : email,
            "password" : password
        ]

        Alamofire.request(UserRouter.signIn(parameters)).validate().response { (res) in
            //Error handle
            if let err = res.error {
                completionHandler(false, nil, NetworkManager.shared.handleError(response: res.response, error: err as NSError))
                return
            }
            
            //try parse data to json
            if let json = (res.data! as NSData).toDictionary() {
                //handle json data
                //print((json["token"] as! [String]).count)
                guard let errs = json["errors"] as? [String], let token = json["token"] as? [String] else {
                    completionHandler(false, nil, "Invalid data format")
                    return
                }
                
                
                //if login not successfully
                if errs.count > 0 || token.count == 0 {
                    completionHandler(false, nil, "Login Error")
                    return
                }
                
                //login successfully
                if let userInfo = Utilities.convertObjectToJson(object: json["userInfo"]! as AnyObject) {
                    print(userInfo)
                    let user = UserObject(email: userInfo["email"] as! String, password: "", fullName: userInfo["fullname"] as! String, address: userInfo["address"] as! String, phoneNumber: userInfo["phonenumber"] as! String, token: token[0])
                    
                    completionHandler(true, user, nil)
                } else {
                    completionHandler(false, nil, "Invalid data format")
                    return
                }
                
            } else {
                completionHandler(false, nil, "Invalid data format")
                return
            }
        }
    }
}



