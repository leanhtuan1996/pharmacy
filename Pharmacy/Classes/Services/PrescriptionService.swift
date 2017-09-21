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
    
    func getPrescriptions(_ completionHandler: @escaping (_ prescription: [PrescriptionObject]?, _ error: String?) -> Void) {
        Alamofire.request(PrescriptionRouter.getAllPrescription())
            .validate()
            .response { (res) in
                if let err = res.error {
                    return completionHandler(nil, Utilities.handleError(res.response, error: err as NSError))
                }
                
                if let data = res.data {
                    if let json = data.toDictionary() {
                        if let error = json["errors"] as? [String] {
                            if error.count > 0 {
                                return completionHandler(nil, error[0])
                            }
                        }
                        //if success
                        guard let prescriptionsJSON = json["prescriptions"] as? [[String : Any]], let prescriptions = [PrescriptionObject].from(jsonArray: prescriptionsJSON) else {
                            return completionHandler(nil, "Invalid data format")
                        }
                        
                        return completionHandler(prescriptions, nil)
                            
                    
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
                    return completionHandler(nil, Utilities.handleError(res.response, error: error as NSError))
                }
                
                if let data = res.data {
                    if let json = data.toDictionary() {
                        if let error = json["errors"] as? [String] {
                            if error.count > 0 {
                                print("0")
                                return completionHandler(nil, error[0])
                            }
                        }
                        
                        if let prescription = PrescriptionObject(json: json) {
                            return completionHandler(prescription, nil)
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
        
        guard let drugOfPrescription = prescription.drugs else {
            return completionHandler("Prescription must have a drug")
        }
        
        for drug in drugOfPrescription {
            
            guard let id = drug.id else {
                return completionHandler("Drug Id not found")
            }
            
            let drugDic: [String : Any] = [
                "id" : id
            ]
            drugs.append(drugDic)
        }
        
        let parameter: [String: Any] = [
            "drugs" : drugs,
            "date" : Date.getDate()
        ]
        
        Alamofire.request(PrescriptionRouter.newPrescription(parameter)).validate().response { (res) in
            
            if let err = res.error {
                return completionHandler(Utilities.handleError(res.response, error: err as NSError))
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
    
    // ** FUNCTIONS FOR ADMIN RULE **
    
    //Get all prescription of customers
    func getListPrescriptions(_ completionHandler: @escaping (_ data: [PrescriptionObject]?, _ error: String?) -> Void) {
        Alamofire.request(PrescriptionRouter.getListPrescription())
            .validate()
            .response { (res) in
                if let err = res.error {
                    return completionHandler(nil, Utilities.handleError(res.response, error: err as NSError))
                }
                
                if let data = res.data {
                    if let json = data.toDictionary() {
                        if let error = json["errors"] as? [String] {
                            if error.count > 0 {
                                return completionHandler(nil, error[0])
                            }
                        }
                        //if success
                        guard let prescriptionsJSON = json["prescriptions"] as? [[String: Any]], let prescriptions = [PrescriptionObject].from(jsonArray: prescriptionsJSON) else {
                            return completionHandler(nil, "Invalid data format")
                        }
                        return completionHandler(prescriptions, nil)
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
    
    //Accept prescription function
    func acceptPrescription(withId id: Int, completionHandler: @escaping (_ error: String?) -> Void) {
        
        let parameter: [String: Any] = [
            "prescriptionID" : id
        ]
        
        Alamofire.request(PrescriptionRouter.appceptPrescription(parameter))
            .validate()
            .response { (res) in
                if let err = res.error {
                    return completionHandler(Utilities.handleError(res.response, error: err as NSError))
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
    
    //Reject prescription function
    func rejectPrescription(withId id: Int, completionHandler: @escaping (_ error: String?) -> Void) {
        let parameter: [String: Any] = [
            "prescriptionID" : id
        ]
        
        Alamofire.request(PrescriptionRouter.rejectPrescription(parameter))
            .validate()
            .response { (res) in
                if let err = res.error {
                    return completionHandler(Utilities.handleError(res.response, error: err as NSError))
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
