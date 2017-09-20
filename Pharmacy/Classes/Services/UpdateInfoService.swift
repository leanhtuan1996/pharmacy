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
    
    func updateInfo(_ user: UserObject, completionHandler: @escaping (_ error: String?) -> ()) {
        
        let parameters = [
            "currentPassword" : user.password ?? "",
            "address" : user.address ?? "",
            "phonenumber" : user.phoneNumber ?? "",
            "fullname" : user.fullName ?? ""
        ]
        
        Alamofire.request(UserRouter.updateInfo(parameters))
        .validate()
        .response { (res) in
            //check errors
            if let err = res.error {
                return completionHandler(Utilities.handleError(res.response, error: err as NSError))
            }
            
            guard let data = res.data else {
                return completionHandler("Invalid data format")
            }
            
            //try parse data to json
            if let json = data.toDictionary() {
                
                if let errs = json["errors"] as? [String] {
                    if errs.count > 0 {
                        return completionHandler("Invalid data format")
                    }
                }
                return completionHandler(nil)
                
            } else {
                return completionHandler("Invalid data format")
            }
        }
    }
}
