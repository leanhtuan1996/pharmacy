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
    
    func getPrescriptions(completionHandler: @escaping (_ prescription: PrescriptionObject?, _ error: String?) -> Void) {
        Alamofire.request(PrescriptionRouter.getAllPrescription())
            .validate()
            .response { (res) in
                if let err = res.error {
                    return completionHandler(nil, Utilities.handleError(response: res.response, error: err as NSError))
                }
                
                if let data = res.data {
                    if let json = data.toDictionary() {
                        if let error = json["errors"] as? [String] {
                            if error.count > 0 {
                                return completionHandler(nil, error[0])
                            }
                        }
                        //if success
                        if let prescriptions = json["prescriptions"] as? [AnyObject] {
                            
                            for preObject in prescriptions {
                                
                                //convert preObject to Dictionary
                                if let preDic = Utilities.convertObjectToJson(object: preObject) {
                                    guard let id = preDic["id"] as? Int, let dateCreate = preDic["date"] as? String, let status = preDic["status"] as? Int else {
                                        return completionHandler(nil, "Invalid data format")
                                    }
                                    print(id)
                                    let pre = PrescriptionObject()
                                    pre.id = id
                                    pre.dateCreate = dateCreate.jsonDateToDate()
                                    pre.name = "Toa thuốc"
                                    
                                    switch status {
                                    case 0 :
                                        pre.status = Status.pending
                                    case 1:
                                        pre.status = Status.approved
                                    case 2:
                                        pre.status = Status.rejected
                                    default:
                                        break
                                    }
                                    //Get detail prescription from id
//                                    self.getDetailPrescription(with: id, completionHandler: { (prescripion, error) in
//
//                                        if let error = error {
//                                            print(error)
//                                            return completionHandler(nil, "Invalid data format")
//                                        }
//                                        
//                                        //get drugs
//                                        if let preObject = prescripion {
//                                            pre.drugs = preObject.drugs
//                                        }
//                                        completionHandler(pre, nil)
//                                    })
                                    completionHandler(pre, nil)
                                }
                            }
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
    
    func getDetailPrescription(with id: Int, completionHandler: @escaping(_ prescription: PrescriptionObject?, _ error: String?) -> Void) {
        let parameter: [String: Any] = [
            "prescriptionID" : id
        ]
        
        Alamofire.request(PrescriptionRouter.getDetailPrescription(parameter))
            .validate()
            .response { (res) in
                if let error = res.error {
                    return completionHandler(nil, Utilities.handleError(response: res.response, error: error as NSError))
                }
                
                if let data = res.data {
                    if let json = data.toDictionary() {
                        if let error = json["errors"] as? [String] {
                            if error.count > 0 {
                                print("0")
                                return completionHandler(nil, error[0])
                            }
                        }
                        //if success
                        guard let idPre = json["id"] as? Int, let drugs = json["drugs"] as? [AnyObject] else {
                            print("1")
                            return completionHandler(nil, "Invalid data format")
                        }
                        
                        var drugsArray: [DrugObject] = []
                        var flag = 0
                        for drug in drugs {
                            if let drugJson = Utilities.convertObjectToJson(object: drug) {
                                //print(drugJson["DrugID"])
                                if let id = drugJson["DrugID"] as? Int {
                                    
                                    //get detail drug
                                    DrugsService.shared.getDrug(drugId: id, completionHandler: { (drug, error) in
                                        flag += 1
                                        if let error = error {
                                            return completionHandler(nil, "Get detail drug error: \(error)")
                                        }
                                        
                                        if let drug = drug {
                                            drugsArray.append(drug)
                                        }
                                        
                                        if flag == drugs.count {
                                            let pre = PrescriptionObject()
                                            pre.drugs = drugsArray
                                            pre.id = idPre
                                            return completionHandler(pre, nil)
                                        }
                                    })
                                }
                            }
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
            "date" : Date.getDate()
        ]
        
        Alamofire.request(PrescriptionRouter.newPrescription(parameter)).validate().response { (res) in
            
            if let err = res.error {
                return completionHandler(Utilities.handleError(response: res.response, error: err as NSError))
            }
            
            if let data = res.data {
                if let json = data.toDictionary() {
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
