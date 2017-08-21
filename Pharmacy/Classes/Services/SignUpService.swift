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
        
        Alamofire.request(UserRouter.signUp(parameters))
            .validate()
            .response { (res) in
                
                if let err = res.error {
                    completionHandler(false, nil, NetworkManager.shared.handleError(response: res.response, error: err as NSError))
                    return
                }
                
                //parse data to json
                if let json = (res.data! as NSData).toDictionary() {
                    
                } else {
                    completionHandler(false, nil, "Invalid data format")
                    return
                }
        }
    }
    
}
