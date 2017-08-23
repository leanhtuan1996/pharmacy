//
//  UpdateInfoService.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/23/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire

class UpdateInfoService: NSObject {
    static let shared = UpdateInfoService()
    
    func updateInfo(user: UserObject, completionHandler: @escaping (_ isSuccess: Bool, _ error: String?) -> ()) {
        
        let parameters = [
            "currentPassword" : user.password,
            "address" : user.address,
            "phonenumber" : user.phoneNumber,
            "fullname" : user.fullName
        ]
        
        Alamofire.request(UserRouter.updateInfo(parameters))
        .validate()
        .response { (res) in
            //check errors
            if let err = res.error {
                completionHandler(false, NetworkManager.shared.handleError(response: res.response, error: err as NSError))
                return
            }
            
            //try parse data to json
            if let json = (res.data! as NSData).toDictionary() {
                
                guard let errs = json["errors"] as? [String] else {
                    completionHandler(false, "Invalid data format")
                    return
                }
                
                //update info not successfully
                if errs.count > 0 {
                    completionHandler(false, errs[0])
                    return
                }
                
                completionHandler(true, "Information has been updated successfully")
                
            } else {
                completionHandler(false, "Invalid data format")
                return
            }
            
        }
    }
    
}
