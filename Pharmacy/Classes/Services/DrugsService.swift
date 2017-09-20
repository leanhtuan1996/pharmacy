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
    
    func getDrug(_ drugId: Int, completionHandler: @escaping (_ Data: DrugObject?, _ Error: String? ) -> Void) {
        
        let parameter: [String : Any] = [
            "drugId": drugId
        ]
        
        Alamofire.request(DrugRouter.getDrug(parameter))
            .validate()
            .response { (res) in
                
                // if request error
                if let err = res.error {
                    return completionHandler(nil, Utilities.handleError(res.response, error: err as NSError))
                    
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
                        
                        guard let drugObject = json["drug"] else {
                            return completionHandler(nil, "Invalid data format")
                        }
                        
                        if let drugJSON = Utilities.convertObjectToJson(drugObject) {
                            if let drug = DrugObject(json: drugJSON) {
                                return completionHandler(drug, nil)
                            }
                            return completionHandler(nil, "Invalid data format")
                        } else {
                            return completionHandler(nil, "Invalid data format")
                        }
                       
                    } else {
                        return completionHandler(nil, "Invalid data format")
                    }
                } else {
                    return completionHandler(nil, "Invalid data format")
                }
        }
    }
    
    func getDrugs(_ completionHandler: @escaping (_ Data: [DrugObject]?, _ Error: String? ) -> Void) {
        Alamofire.request(DrugRouter.listOfDrug())
            .validate()
            .response { (res) in
            
                if let err = res.error {
                    return completionHandler(nil, Utilities.handleError(res.response, error: err as NSError))
                    
                }
                
                guard let data = res.data else {
                    return completionHandler(nil, "Invalid data format")
                }
                
                //try parse data to json
                if let json = data.toDictionary() {
                    if let err = json["errors"] as? [String]{
                        //print(err)
                        if err.count > 0 {
                            return completionHandler(nil, err[0])
                        }
                    }
                    
                    //convert to array
                    guard let listOfDrugArray = json["listOfDrug"] as? [AnyObject] else {
                        return completionHandler(nil, "Invalid data format")
                    }
                    
                    //print(listOfDrugArray)
                    
                    var drugs: [DrugObject] = []
                    
                    for drugData in listOfDrugArray {
                        if let drugObject = Utilities.convertObjectToJson(object: drugData) {
                            
                            guard let drug = DrugObject(json: drugObject) else {
                                return completionHandler(nil, "Invalid data format")
                            }
                            
                            drugs.append(drug)
                            
                        } else {
                            return completionHandler(nil, "Invalid data format")
                        }
                    }
                    return completionHandler(drugs, nil)
                } else {
                    return completionHandler(nil, "Invalid data format")
                    
                }
        }
    }
    
    func addDrug(_ drug: DrugObject, completionHandler: @escaping(_ error: String?) -> Void ) {
        
        guard let name = drug.name else {
            return completionHandler("Name can not empty")
        }
        
        let parameter: [String: String] = [
            "name" : name
        ]
        
        Alamofire.request(DrugRouter.addNewDrug(parameter))
            .validate()
            .response { (res) in
                if let err = res.error {
                    return completionHandler(Utilities.handleError(res.response, error: err as NSError))
                }
                
                guard let data = res.data else {
                    return completionHandler("Invalid data format")
                }
                
                //try parse data to json
                if let json = data.toDictionary() {
                    
                    if let err = json["errors"] as? [String]{
                        //print(err)
                        if err.count > 0 {
                            return completionHandler(err[0])
                        }
                    }
                    return completionHandler(nil)
                    
                } else {
                    return completionHandler("Invalid data format")
                }
        }
        
    }
    
    func editDrug(_ drug: DrugObject, completionHandler: @escaping (_ error: String?) -> Void ) {
        
        guard let id = drug.id, let name = drug.name else {
            return completionHandler("drug id or name is empty")
        }
        
        let parameter: [String: Any] = [
            "drugId" : id,
            "name" : name
        ]
        
        Alamofire.request(DrugRouter.updateDrug(parameter))
            .validate()
            .response { (res) in
                if let err = res.error {
                    return completionHandler(Utilities.handleError(res.response, error: err as NSError))
                }
                
                guard let data = res.data else {
                    return completionHandler("Invalid data format")
                }
                
                //try parse data to json
                if let json = data.toDictionary() {
                    
                    if let err = json["errors"] as? [String]{
                        //print(err)
                        if err.count > 0 {
                            return completionHandler(err[0])
                        }
                    }
                    return completionHandler(nil)
                } else {
                    return completionHandler("Invalid data format")
                }
        }
    }
    
    func deleteDrug(with id: Int, completionHandler: @escaping (_ error: String?) -> Void ) {
        let parameter: [String: Any] = [
            "drugId" : id
        ]
        
        Alamofire.request(DrugRouter.deleteDrug(parameter))
            .validate()
            .response { (res) in
                if let err = res.error {
                    return completionHandler(Utilities.handleError(res.response, error: err as NSError))
                }
                
                guard let data = res.data else {
                    return completionHandler("Invalid data format")
                }
                
                //try parse data to json
                if let json = data.toDictionary() {
                    
                    if let err = json["errors"] as? [String] {
                        //print(err)
                        if err.count > 0 {
                            return completionHandler(err[0])
                        }
                    }
                    return completionHandler(nil)
                    
                } else {
                    return completionHandler("Invalid data format")
                    
                }
        }
    }
    
}
