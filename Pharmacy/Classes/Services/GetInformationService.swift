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
    
    func getInformations(_ completionHandler: @escaping(_ data: UserObject?, _ error: String?) -> ()) {
        
        Alamofire.request(UserRouter.getInfo())
            .validate()
            .response { (res) in
                //check errors
                if let err = res.error {
                    return completionHandler(nil, Utilities.handleError(res.response, error: err as NSError))
                }
                
                guard let data = res.data else {
                    return completionHandler(nil, "Invalid data format")
                }
                
                //try parse data to json
                if let json = data.toDictionary() {
                    //check format
                    if let errs = json["errors"] as? [String] {
                        //print(errs)
                        if errs.count > 0 {
                            return completionHandler(nil, errs[0])
                        }
                    }
                    
                    guard let customerInfoObject = json["customerInfo"] else {
                        return completionHandler(nil, "Invalid data format")
                    }
                    
                    //sign up successfully
                    if let userInfo = Utilities.convertObjectToJson(object: customerInfoObject) {
                        //print(userInfo)
                        guard let email = userInfo["email"] as? String, let fullName = userInfo["fullname"] as? String, let address = userInfo["address"] as? String, let phoneNumber = userInfo["phonenumber"] as? String else {
                            return completionHandler(nil, "Invalid data format")
                        }
                        let user = UserObject(email: email, password: "", fullName: fullName, address: address, phoneNumber: phoneNumber)
                        return completionHandler(user, nil)
                    } else {
                        return completionHandler(nil, "Invalid data format")
                    }
                } else {
                    return completionHandler(nil, "Invalid data format")
                }
        }
    }
}
