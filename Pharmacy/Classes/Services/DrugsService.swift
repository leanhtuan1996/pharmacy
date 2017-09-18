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
    
    func getDrug(drugId: Int, completionHandler: @escaping (_ Data: DrugObject?, _ Error: String? ) -> Void) {
        Alamofire.request(DrugRouter.getDrug(["drugId": drugId]))
            .validate()
            .response { (res) in
                
                // if request error
                if let err = res.error {
                    return completionHandler(nil, Utilities.handleError(response: res.response, error: err as NSError))
                    
                }
                
                if let data = res.data {
                    if let json = data.toDictionary() {
                        
                        //check error
                        if let error = json["errors"] as? [String] {
                            //print(error)
                            if error.count > 0 {
                                return completionHandler(nil, error[0])
                                
                            }
                        }
                        
                        guard let drug = json["drug"] as? [String : Any] else {
                            return completionHandler(nil, "Invalid data format")
                            
                        }
                        
                        guard let id = drug["id"] as? Int, let name = drug["name"] as? String, let instructions = drug["instructions"] as? String, let formula = drug["formula"] as? String, let contraindication = drug["contraindication"] as? String, let sideEffect = drug["side_effect"] as? String, let howToUse = drug["how_to_use"] as? String, let price = drug["price"] as? Int else {
                            return completionHandler(nil, "Invalid data format")
                            
                        }
                        
                        let drugObject = DrugObject()
                        drugObject.id = id
                        drugObject.name = name
                        drugObject.instructions = instructions
                        drugObject.formula = formula
                        drugObject.contraindication = contraindication
                        drugObject.sideEffect = sideEffect
                        drugObject.howToUse = howToUse
                        drugObject.price = price
                        
//                        return completionHandler(true, DrugObject(id: id, name: name, instructions: instructions, formula: formula, contraindication: contraindication, sideEffect: sideEffect, howToUse: howToUse, price: price), nil)
                        return completionHandler(drugObject, nil)
                        
                        
                    } else {
                        return completionHandler(nil, "Invalid data format")
                        
                    }
                    
                } else {
                    return completionHandler(nil, "Invalid data format")
                    
                }
            
        }
    }
    
    func getDrugs(completionHandler: @escaping (_ Data: [DrugObject?], _ Error: String? ) -> Void) {
        Alamofire.request(DrugRouter.listOfDrug())
            .validate()
            .response { (res) in
            
                if let err = res.error {
                    return completionHandler([nil], Utilities.handleError(response: res.response, error: err as NSError))
                    
                }
                
                guard let data = res.data else {
                    return completionHandler([nil], "Invalid data format")
                }
                
                //try parse data to json
                if let json = data.toDictionary() {
                    
                    if let err = json["errors"] as? [String]{
                        //print(err)
                        if err.count > 0 {
                            return completionHandler([nil], err[0])
                            
                        }
                    }
                    
                    //convert to array
                    guard let listOfDrugArray = json["listOfDrug"] as? [AnyObject] else {
                        return completionHandler([nil], "Invalid data format")
                    }
                    
                    //print(listOfDrugArray)
                    
                    var drugs: [DrugObject] = []
                    
                    for drugData in listOfDrugArray {
                        if let drugObject = Utilities.convertObjectToJson(object: drugData) {
                            
                            guard let id = drugObject["id"] as? Int, let name = drugObject["name"] as? String, let instructions = drugObject["instructions"] as? String, let formula = drugObject["formula"] as? String, let contraindication = drugObject["contraindication"] as? String, let sideEffect = drugObject["side_effect"] as? String, let howToUse = drugObject["how_to_use"] as? String, let price = drugObject["price"] as? Int else {
                                return completionHandler([nil], "Invalid data format")
                                
                            }
                            
                            //print(name)
                            let drugObject = DrugObject()
                            drugObject.id = id
                            drugObject.name = name
                            drugObject.instructions = instructions
                            drugObject.formula = formula
                            drugObject.contraindication = contraindication
                            drugObject.sideEffect = sideEffect
                            drugObject.howToUse = howToUse
                            drugObject.price = price
                            
//                            drugs.append(DrugObject(id: id, name: name, instructions: instructions, formula: formula, contraindication: contraindication, sideEffect: sideEffect, howToUse: howToUse, price: price))
                            drugs.append(drugObject)
                            
                        } else {
                            return completionHandler([nil], "Invalid data format")
                            
                        }
                    }
                    return completionHandler(drugs, nil)
                    
                } else {
                    return completionHandler([nil], "Invalid data format")
                    
                }
        }
    }
}
