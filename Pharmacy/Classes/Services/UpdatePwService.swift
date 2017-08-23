//
//  UpdatePwService.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/23/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire

class UpdatePwService: NSObject {
    static let shared = UpdatePwService()
    
    func updatePw(oldPassword: String, newPassword: String, confirmPw: String, completionHandler: @escaping (_ isSuccess: Bool, _ error: String?) -> ()) {
        
        let parameters: [String : String] = [
            "currentPassword" : oldPassword,
            "newPassword" : newPassword,
            "confirmPassword" : confirmPw
        ]
        
        
        Alamofire.request(UserRouter.updatePw(parameters))
            .validate()
            .response { (res) in
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
                    
                    //update password not successfully
                    if errs.count > 0 {
                        completionHandler(false, errs[0])
                        return
                    }
                    
                    completionHandler(true, "Password has been updated successfully")
                    
                } else {
                    completionHandler(false, "Invalid data format")
                    return
                }
                
        }
        
        
    }
    
}
