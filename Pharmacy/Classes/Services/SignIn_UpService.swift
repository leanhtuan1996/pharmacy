//
//  SignInService.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/20/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire

class SignIn_UpService: NSObject {
    static let shared = SignIn_UpService()
    
    let userDefaults = UserDefaults.standard
    
    // MARK: - SIGN IN
    
    func signIn(_ email: String, password: String, completionHandler: @escaping (_ user: UserObject?, _ error: String?) -> ()) {
        
        let parameters = [
            "email" : email,
            "password" : password
        ]
        
        Alamofire.request(UserRouter.signIn(parameters)).validate().response { (res) in
            //Error handle
            if let err = res.error {
                return completionHandler(nil, Utilities.handleError(res.response, error: err as NSError))
            }
            
            guard let data = res.data else {
                return completionHandler(nil, "Invalid data format")
            }
            
            //try parse data to json
            if let json = data.toDictionary() {
                //handle json data
                guard let errs = json["errors"] as? [String], let token = json["token"] as? [String] else {
                    return completionHandler(nil, "Invalid data format")
                }
                
                //login not successfully
                if errs.count > 0 || token.count == 0 {
                    return completionHandler(nil, errs[0])
                }
                
                //Check cast "userinfo" to [String : String]
                guard let userInfoObject = json["userInfo"] else {
                    return completionHandler(nil, "Invalid data format")
                }
                
                //login successfully
                if let userInfo = Utilities.convertObjectToJson(object: userInfoObject) {
                    print(userInfo)
                    
                    guard let user = UserObject(json: userInfo) else {
                        return completionHandler(nil, "Invalid data format")
                    }
                    
                    if token.count > 0 {
                        user.token = token[0]
                        return completionHandler(user, nil)
                    } else {
                        return completionHandler(nil, "Received with no token")
                        
                    }
                } else {
                   return completionHandler(nil, "Invalid data format")
                }
                
            } else {
                return completionHandler(nil, "Invalid data format")
            }
        }
    }
    
    // MARK: - SIGN UP
    func signUp(_ user: UserObject, completionHandler: @escaping (_ user: UserObject?, _ error: String?) -> ()){
        let parameters: [String: String] = [
            "email" : user.email,
            "password" : user.password ?? "",
            "address" : user.address ?? "",
            "fullname" : user.fullName ?? "",
            "phonenumber" : user.phoneNumber ?? ""
        ]
        
        Alamofire.request(UserRouter.signUp(parameters))
            .validate()
            .response { (res) in
                
                if let err = res.error {
                    return completionHandler(nil, Utilities.handleError(res.response, error: err as NSError))
                    
                }
                
                guard let data = res.data else {
                    return completionHandler(nil, "Invalid data format")
                }
                
                //parse data to json
                if let json = data.toDictionary() {
                    
                    //handle json data
                    guard let errs = json["errors"] as? [String], let token = json["token"] as? [String] else {
                        return completionHandler(nil, "Invalid data format")
                    }
                    
                    
                    //if sign up not successfully
                    if errs.count > 0 || token.count == 0 {
                        return completionHandler(nil, errs[0])
                    }
                    
                    guard let userInfoObject = json["userInfo"] else {
                        return completionHandler(nil, "Invalid data format")
                    }
                    
                    //sign up successfully
                    if let userInfo = Utilities.convertObjectToJson(object: userInfoObject) {
                        //print(userInfo)
                        
                        guard let user = UserObject(json: userInfo) else {
                            return completionHandler(nil, "Invalid data format")
                        }
                        
                        if token.count > 0 {
                            user.token = token[0]
                            return completionHandler(user, nil)
                        } else {
                            return completionHandler(nil, "Sign Up Error")
                        }
                    } else {
                        return completionHandler(nil, "Invalid data format")
                    }
                } else {
                    return completionHandler(nil, "Invalid data format")
                }
        }
    }
}



