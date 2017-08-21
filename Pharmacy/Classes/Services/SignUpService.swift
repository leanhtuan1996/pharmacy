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
    
    func signUp(user: UserObject, completionHandler: @escaping (_ isSuccess: Bool, _ token: String?, _ error: String?) -> ()){
        let parameters = [
            "email" : user.email,
            "password" : user.password,
            "address" : user.address,
            "fullname" : user.fullName,
            "phonenumber" : user.phoneNumber
        ]
        
        Alamofire.request("http://35.177.230.252:3000/signup", method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
            .validate()
            .response { (response) in
                if let error = response.error {
                    let errorString = handleError(response: response.response, error: error as NSError)
                    completionHandler(false, nil, errorString)
                    return
                }
                
                //parse data to json
                if let json = (response.data! as NSData).toDictionary() {
                    if let token = (json["token"] as? String) {
                        if !token.isEmpty {
                            completionHandler(true, json["token"] as? String, nil)
                        } else {
                            if let error = json["error"] as? String {
                                completionHandler(false, nil, error)
                            } else {
                                completionHandler(false, nil, "Not found Error")
                            }
                            
                        }
                    }
                } else {
                    print("Response is not corrected formation")
                }
        }
    }
    
}
