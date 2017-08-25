//
//  GetInformationService.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/25/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire

class GetInformationService: NSObject {
    static let shared = GetInformationService()
    
    func getInformations(completionHandler: @escaping(_ isSuccess: Bool, _ data: UserObject?, _ error: String?) -> ()) {
        
        Alamofire.request(UserRouter.getInfo())
            .validate()
            .response { (res) in
                //check errors
                if let err = res.error {
                    completionHandler(false, nil, NetworkManager.shared.handleError(response: res.response, error: err as NSError))
                    return
                }
                
                //try parse data to json
                if let json = (res.data! as NSData).toDictionary() {
                    
                    //check format
                    guard let errs = json["errors"] as? [String] else {
                        completionHandler(false, nil, "Invalid data format")
                        return
                    }
                    
                    //check error
                    if errs.count > 0 {
                        completionHandler(false, nil, errs[0])
                        return
                    }
                    
                    //sign up successfully
                    if let userInfo = Utilities.convertObjectToJson(object: json["customerInfo"]! as AnyObject) {
                        //print(userInfo)
                        
                        guard let email = userInfo["email"] as? String, let fullName = userInfo["fullname"] as? String, let address = userInfo["address"] as? String, let phoneNumber = userInfo["phonenumber"] as? String else {
                            completionHandler(false, nil, "Invalid data format")
                            return
                        }
                        
                        let user = UserObject(email: email, password: "", fullName: fullName, address: address, phoneNumber: phoneNumber)
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
        
        
        //completionHandler(false, nil, "ERROR")
    }
    
}
