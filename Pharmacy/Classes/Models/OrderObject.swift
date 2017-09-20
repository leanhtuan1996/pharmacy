//
//  OrderObject.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/2/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class OrderObject: NSObject, Decodable {
    
    var id: Int?
    var date: String?
    var drugs: [DrugObject]?
    var idPrescription: Int?
    
    override init() { }
    
    required init?(json: JSON) {
        
        if let id:Int = "id" <~~ json {
            self.id = id
        }
        
        if let id: Int = "orderNumber" <~~ json {
            self.id = id
        }
        
        if let date:String = "date" <~~ json {
            self.date = date.jsonDateToDate()
        }
        
        if let drugsJSON: [JSON] = "drugs" <~~ json {
            if let drugs = [DrugObject].from(jsonArray: drugsJSON) {
                self.drugs = drugs
            }
        }
        
//        if let drugs =  [OrderObject].from(jsonArray: "drugs" <~~ json)  {
//            print(drugs.count)
//            self.drugs = drugs
//        }
        
        self.idPrescription = "prescription_id" <~~ json
    }
}
