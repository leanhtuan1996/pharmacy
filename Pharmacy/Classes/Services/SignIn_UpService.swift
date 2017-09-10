//
//  SignInService.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/20/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire
typealias JSONString = [String: Any]

class SignIn_UpService: NSObject {
    static let shared = SignIn_UpService()
    
    let userDefaults = UserDefaults.standard
    
    // MARK: - SIGN IN
    
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
                
                //login not successfully
                if errs.count > 0 || token.count == 0 {
                    completionHandler(false, nil, errs[0])
                    return
                }
                
                //Check cast "userinfo" to [String : String]
                guard let userInfoObject = json["userInfo"] as? AnyObject else {
                    completionHandler(false, nil, "Invalid data format")
                    return
                }
                
                //login successfully
                if let userInfo = Utilities.convertObjectToJson(object: userInfoObject) {
                    print(userInfo)
                    
                    guard let email = userInfo["email"] as? String, let fullName = userInfo["fullname"] as? String, let address = userInfo["address"] as? String, let phoneNumber = userInfo["phonenumber"] as? String, let roleString = userInfo["role"] as? String else {
                        completionHandler(false, nil, "Invalid data format")
                        return
                    }
                    
                    guard let role = userRole(rawValue: roleString) else {
                        completionHandler(false, nil, "Role not found")
                        return
                    }
                    
                    let user = UserObject(email: email, password: "", fullName: fullName, address: address, phoneNumber: phoneNumber)
                    
                    user.role = role
                    
                    if token.count != 0 {
                        user.token = token[0]
                        print(user.token)
                        completionHandler(true, user, nil)
                    } else {
                        completionHandler(false, nil, "Received with no token")
                        return
                    }
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
    
    // MARK: - SIGN UP
    func signUp(user: UserObject, completionHandler: @escaping (_ isSuccess: Bool, _ user: UserObject?, _ error: String?) -> ()){
        let parameters = [
            "email" : user.email,
            "password" : user.password,
            "address" : user.address,
            "fullname" : user.fullName,
            "phonenumber" : user.phoneNumber
        ]
        
        Alamofire.request(UserRouter.signUp(parameters))
            .validate()
            .response { (res) in
                
                if let err = res.error {
                    completionHandler(false, nil, NetworkManager.shared.handleError(response: res.response, error: err as NSError))
                    return
                }
                
                //parse data to json
                if let json = (res.data! as NSData).toDictionary() {
                    
                    //handle json data
                    
                    guard let errs = json["errors"] as? [String], let token = json["token"] as? [String] else {
                        completionHandler(false, nil, "Invalid data format")
                        return
                    }
                    
                    
                    //if sign up not successfully
                    if errs.count > 0 || token.count == 0 {
                        completionHandler(false, nil, errs[0])
                        return
                    }
                    
                    //sign up successfully
                    if let userInfo = Utilities.convertObjectToJson(object: json["userInfo"]! as AnyObject) {
                        //print(userInfo)
                        
                        guard let email = userInfo["email"] as? String, let fullName = userInfo["fullname"] as? String, let address = userInfo["address"] as? String, let phoneNumber = userInfo["phonenumber"] as? String else {
                            completionHandler(false, nil, "Invalid data format")
                            return
                        }
                        
                        let user = UserObject(email: email, password: "", fullName: fullName, address: address, phoneNumber: phoneNumber)
                        
                        if token.count != 0 {
                            user.token = token[0]
                            completionHandler(true, user, nil)
                        } else {
                            completionHandler(false, nil, "Sign Up Error")
                            return
                        }
                        
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



