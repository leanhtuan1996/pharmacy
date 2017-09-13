//
//  PrescriptionObject.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/13/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

enum Status: String {
    case pending = "pending"
    case rejected = "rejected"
    case approved = "approved"
}

class PrescriptionObject: NSObject, NSCoding {
    
    var id: Int
    var name: String
    var status: Status
    var drugs: [DrugObject]
    
    init(id: Int, name: String, drugs: [DrugObject]) {
        self.id = id
        self.name = name
        self.drugs = drugs
        self.status = Status.pending
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        if let name = aDecoder.decodeObject(forKey: "name") as? String, let drugs = aDecoder.decodeObject(forKey: "drugs") as? [DrugObject] {
            self.init(id: id, name: name, drugs: drugs)
        } else {
            self.init(id: 0, name: "", drugs: [])
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(drugs, forKey: "drugs")
    }

    
}
