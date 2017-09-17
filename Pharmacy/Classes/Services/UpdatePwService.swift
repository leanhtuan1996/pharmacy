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
    
    func updatePw(oldPassword: String, newPassword: String, confirmPw: String, completionHandler: @escaping (_ error: String?) -> ()) {
        
        let parameters: [String : String] = [
            "currentPassword" : oldPassword,
            "newPassword" : newPassword,
            "confirmPassword" : confirmPw
        ]
        Alamofire.request(UserRouter.updatePw(parameters))
            .validate()
            .response { (res) in
                if let err = res.error {
                    return completionHandler(NetworkManager.shared.handleError(response: res.response, error: err as NSError))
                    
                }
                
                guard let data = res.data else {
                    return completionHandler("Invalid data format")
                }
                
                //try parse data to json
                if let json = (data as NSData).toDictionary() {
                    
                    guard let errs = json["errors"] as? [String] else {
                        return completionHandler("Invalid data format")
                        
                    }
                    //update password not successfully
                    if errs.count > 0 {
                        return completionHandler(errs[0])
                    }
                    return completionHandler(nil)
                    
                } else {
                    return completionHandler("Invalid data format")
                }
        }
    }
}
