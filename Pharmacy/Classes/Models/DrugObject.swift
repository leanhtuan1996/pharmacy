//
//  DrugObject.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DrugObject: NSObject, NSCoding {
    var id: Int = 0
    var quantity: Int = 0
    var name: String = ""
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: "id")
        quantity = aDecoder.decodeInteger(forKey: "quantity")
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(quantity, forKey: "quantity")
    }
    
}
