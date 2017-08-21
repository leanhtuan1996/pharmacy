//
//  SignUpService.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/21/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire

class SignUpService: NSObject {
    static let shared = SignUpService()
    
    let userDefaults = UserDefaults.standard
    
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
                        completionHandler(false, nil, "Sign Up Error")
                        return
                    }
                    
                    //sign up successfully
                    if let userInfo = Utilities.convertObjectToJson(object: json["userInfo"]! as AnyObject) {
                        print(userInfo)
                        let user = UserObject(email: userInfo["email"] as! String, password: "", fullName: userInfo["fullname"] as! String, address: userInfo["address"] as! String, phoneNumber: userInfo["phonenumber"] as! String)
                        
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
