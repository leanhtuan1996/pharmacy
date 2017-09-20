//
//  DrugObject.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class DrugObject: NSObject, NSCoding, Decodable {
    var id: Int?
    var quantity: Int?
    var name: String?
    
    override init() {}
    
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: "id")
        quantity = aDecoder.decodeInteger(forKey: "quantity")
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        super.init()
    }
    
    required init?(json: JSON) {
        self.id = "id" <~~ json
        
        if let idDrug:Int = "id_drug" <~~ json {
            self.id = idDrug
        }
        
        self.quantity = "quantity" <~~ json
        self.name = "name" <~~ json
    }
    
    func encode(with aCoder: NSCoder) {
        if let idInt = id {
            aCoder.encode(idInt, forKey: "id")
        }
        
        if let quantityInt = quantity {
            aCoder.encode(quantityInt, forKey: "quantity")
        }
        
        if let nameString = name {
            aCoder.encode(nameString, forKey: "name")
        }
    }
    
}
