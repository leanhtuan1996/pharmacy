//
//  GetAllDrugsService.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire


class DrugsService: NSObject {
    static let shared = DrugsService()
    
    func getDrug(drugId: Int, completionHandler: @escaping (_ isSuccess: Bool, _ Data: DrugObject?, _ Error: String? ) -> Void) {
        Alamofire.request(DrugRouter.getDrug(["drugId": drugId]))
            .validate()
            .response { (res) in
                
                // if request error
                if let err = res.error {
                    completionHandler(false, nil, NetworkManager.shared.handleError(response: res.response, error: err as NSError))
                    return
                }
                
                if let data = res.data {
                    if let json = (data as NSData).toDictionary() {
                        
                        //check error
                        if let error = json["errors"] as? [String] {
                            //print(error)
                            if error.count > 0 {
                                completionHandler(false, nil, error[0])
                                return
                            }
                        }
                        
                        guard let drug = json["drug"] as? [String : Any] else {
                            completionHandler(false, nil, "Invalid data format")
                            return
                        }
                        
                        guard let id = drug["id"] as? Int, let name = drug["name"] as? String, let instructions = drug["instructions"] as? String, let formula = drug["formula"] as? String, let contraindication = drug["contraindication"] as? String, let sideEffect = drug["side_effect"] as? String, let howToUse = drug["how_to_use"] as? String, let price = drug["price"] as? Int else {
                            completionHandler(false, nil, "Invalid data format")
                            return
                        }
                        
                        completionHandler(true, DrugObject(id: id, name: name, instructions: instructions, formula: formula, contraindication: contraindication, sideEffect: sideEffect, howToUse: howToUse, price: price), nil)
                        
                        
                    } else {
                        completionHandler(false, nil, "Invalid data format")
                        return
                    }
                    
                } else {
                    completionHandler(false, nil, "Invalid data format")
                    return
                }
            
        }
    }
    
    func getDrugs(completionHandler: @escaping (_ isSuccess: Bool, _ Data: [DrugObject?], _ Error: String? ) -> Void) {
        Alamofire.request(DrugRouter.listOfDrug())
            .validate()
            .response { (res) in
            
                if let err = res.error {
                    completionHandler(false, [nil], NetworkManager.shared.handleError(response: res.response, error: err as NSError))
                    return
                }
                
                //try parse data to json
                if let json = (res.data! as NSData).toDictionary() {
                    
                    if let err = json["errors"] as? [String]{
                        //print(err)
                        if err.count > 0 {
                            completionHandler(false, [nil], err[0])
                            return
                        }
                    }
                    
                    //convert to array
                    guard let listOfDrugArray = json["listOfDrug"] as? [AnyObject] else {
                        
                        completionHandler(false, [nil], "Invalid data format")
                        return
                    }
                    
                    //print(listOfDrugArray)
                    
                    var drugs: [DrugObject] = []
                    
                    for drugData in listOfDrugArray {
                        if let drugObject = Utilities.convertObjectToJson(object: drugData) {
                            
                            guard let id = drugObject["id"] as? Int, let name = drugObject["name"] as? String, let instructions = drugObject["instructions"] as? String, let formula = drugObject["formula"] as? String, let contraindication = drugObject["contraindication"] as? String, let sideEffect = drugObject["side_effect"] as? String, let howToUse = drugObject["how_to_use"] as? String, let price = drugObject["price"] as? Int else {
                                completionHandler(false, [nil], "Invalid data format")
                                return
                            }
                            
                            //print(name)
                            
                            drugs.append(DrugObject(id: id, name: name, instructions: instructions, formula: formula, contraindication: contraindication, sideEffect: sideEffect, howToUse: howToUse, price: price))
                            
                        } else {
                            completionHandler(false, [nil], "Invalid data format")
                            return
                        }
                    }
                    completionHandler(true, drugs, nil)
                    
                } else {
                    completionHandler(false, [nil], "Invalid data format")
                    return
                }
        }
    }
    
    func addDrug(parameter: DrugObject, completionHandler: @escaping (_ isSuccess: Bool, _ error: String?) -> Void) {
        
        let newDrug: [String: Any] = [
            "name" : parameter.name,
            "instructions" : parameter.instructions,
            "formula" : parameter.formula,
            "contraindication" : parameter.contraindication,
            "sideEffect" : parameter.sideEffect,
            "howToUse" : parameter.howToUse,
            "price" : parameter.price
        ]
        
        
        Alamofire.request(DrugRouter.addNewDrug(newDrug))
        .validate()
        .response { (res) in
            
        }
    }
    
    func updateDrug() {
        
    }
    
    func deleteDrug() {
        
    }
    
}
