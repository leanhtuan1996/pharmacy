//
//  PrescriptionObject.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/13/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

enum Status: String {
    case creating = "can submit"
    case pending = "pending"
    case rejected = "rejected"
    case approved = "can order"
}

class PrescriptionObject: NSObject, NSCoding {
    
    var id: Int = 0
    var name: String = ""
    var status: Status = Status.creating
    var dateCreate: String = ""
    var drugs: [DrugObject] = []
    var totalPrice: Int = 0
    
    override init() { super.init() }
    
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: "id")
        totalPrice = aDecoder.decodeInteger(forKey: "totalPrice")
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        status = Status(rawValue: (aDecoder.decodeObject(forKey: "status") as? String ?? "")) ?? .creating
        dateCreate = aDecoder.decodeObject(forKey: "dateCreate") as? String ?? ""
        drugs = aDecoder.decodeObject(forKey: "drugs") as? [DrugObject] ?? []
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(dateCreate, forKey: "dateCreate")
        aCoder.encode(drugs, forKey: "drugs")
        aCoder.encode(totalPrice, forKey: "totalPrice")
        aCoder.encode(status.rawValue, forKey: "status")
    }

    
}
