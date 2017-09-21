//
//  PrescriptionObject.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/13/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

enum Status: Int {
    case creating = -1
    case pending = 0
    case rejected = 2
    case approved = 1
}

class PrescriptionObject: NSObject, NSCoding, Decodable {
    
    var id: Int?
    var name: String?
    var status: Status?
    var dateCreate: String?
    var drugs: [DrugObject]?
    
    override init() { super.init() }
    
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: "id")
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        status = Status(rawValue: (aDecoder.decodeInteger(forKey: "status")))
        dateCreate = aDecoder.decodeObject(forKey: "dateCreate") as? String ?? ""
        drugs = aDecoder.decodeObject(forKey: "drugs") as? [DrugObject] ?? []
        super.init()
    }
    
    required init?(json: JSON) {
        self.name = "Tên thuốc"
        
        guard let id: Int =  "id" <~~ json else {
            return nil
        }
        
        self.id = id
        
        if let status: Status = "status" <~~ json {
            self.status = status
        }
        
        
        if let date: String = "date" <~~ json {
            self.dateCreate = date.jsonDateToDate()
        }
        
        if let drugJSON: [JSON] = "drugs" <~~ json {
            if let drugs = [DrugObject].from(jsonArray: drugJSON) {
                self.drugs = drugs
            }
        }
    }
    
    func encode(with aCoder: NSCoder) {
        if let idInt = id {
            aCoder.encode(idInt, forKey: "id")
        }
        
        if let nameString = name {
            aCoder.encode(nameString, forKey: "name")
        }
        
        if let status = status {
            aCoder.encode(status.rawValue, forKey: "status")
        }
        
        if let dateCreateString = dateCreate {
            aCoder.encode(dateCreateString, forKey: "dateCreate")
        }
        
        if let drugs = drugs {
            aCoder.encode(drugs, forKey: "drugs")
        }
    }
    
    
}
