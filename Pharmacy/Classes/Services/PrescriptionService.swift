//
//  PrescriptionService.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/16/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire

class PrescriptionService: NSObject {
    static let shared = PrescriptionService()
    
    func getPrescriptions(completionHandler: @escaping (_ prescription: [PrescriptionObject]?, _ error: String?) -> Void) {
        Alamofire.request(PrescriptionRouter.getAllPrescription())
            .validate()
            .response { (res) in
                if let err = res.error {
                    return completionHandler(nil, NetworkManager.shared.handleError(response: res.response, error: err as NSError))
                }
                
                if let data = res.data {
                    if let json = (data as NSData).toDictionary() {
                        if let error = json["errors"] as? [String] {
                            if error.count > 0 {
                                return completionHandler(nil, error[0])
                            }
                        }
                        //if success
                        if let prescriptions = json["prescriptions"] as? [AnyObject] {
                            var pre : [PrescriptionObject] = []
                            
                            for preObject in prescriptions {
                                
                                //convert preObject to Dictionary
                                if let preDic = Utilities.convertObjectToJson(object: preObject) {
                                    guard let id = preDic["id"] as? Int, let dateCreate = preDic["date"] as? String, let status = preDic["accepted"] as? Int else {
                                        return completionHandler(nil, "Invalid data format")
                                    }
                                    
                                    let temp = PrescriptionObject()
                                    temp.id = id
                                    temp.dateCreate = Utilities.convertJsonDateToDate(with: dateCreate)
                                    temp.name = "Toa thuốc"
                                    
                                    switch status {
                                    case 0 :
                                        temp.status = Status.pending
                                    case 1:
                                        temp.status = Status.approved
                                    case 2:
                                        temp.status = Status.rejected
                                    default:
                                        break
                                    }
                                    //Get detail prescription from id
                                    
                                    //Appen temp to array
                                    pre.append(temp)
                                }
                            }
                            return completionHandler(pre, nil)
                            
                        } else {
                            print("1")
                            return completionHandler(nil, "Invalid data format")
                        }
                    } else {
                        print("2")
                        return completionHandler(nil, "Invalid data format")
                    }
                } else {
                    print("3")
                    return completionHandler(nil, "Invalid data format")
                    
                }
        }
    }
    
    func submitPrescription(with prescription: PrescriptionObject, completionHandler: @escaping (_ error: String?) -> Void) {
        
        var drugs: [[String: Any]] = []
        
        for drug in prescription.drugs {
            let drugDic: [String : Any] = [
                "id" : drug.id
            ]
            drugs.append(drugDic)
        }
        
        let parameter: [String: Any] = [
            "drugs" : drugs,
            "date" : Utilities.getDate()
        ]
        
        Alamofire.request(PrescriptionRouter.newPrescription(parameter)).validate().response { (res) in
            
            if let err = res.error {
                return completionHandler(NetworkManager.shared.handleError(response: res.response, error: err as NSError))
            }
            
            if let data = res.data {
                if let json = (data as NSData).toDictionary() {
                    if let error = json["errors"] as? [String] {
                        if error.count > 0 {
                            return completionHandler(error[0])
                        } else {
                            return completionHandler(nil)
                        }
                    } else {
                        return completionHandler("Invalid data format")
                    }
                } else {
                    return completionHandler("Invalid data format")
                }
            } else {
                return completionHandler("Invalid data format")
                
            }
        }
        
    }
}
