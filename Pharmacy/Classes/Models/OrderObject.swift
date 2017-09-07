//
//  OrderObject.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/2/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class OrderObject: NSObject, NSCoding {
    
    var id: Int
    var date: String
    var totalPrice: Int
    var drugs: [DrugObject]
    
    init(id: Int, date: String, totalPrice: Int, drugs: [DrugObject]) {
        self.id = id
        self.date = date
        self.totalPrice = totalPrice
        self.drugs = drugs
    }
    
    required convenience init(coder aDecoder: NSCoder){
        let id = aDecoder.decodeObject(forKey: "id")
        let date = aDecoder.decodeObject(forKey: "date")
        let totalPrice = aDecoder.decodeObject(forKey: "totalPrice")
        let drugs = aDecoder.decodeObject(forKey: "drugs")
        self.init(id: id as! Int, date: date as! String, totalPrice: totalPrice as! Int, drugs: drugs as! [DrugObject])
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(totalPrice, forKey: "totalPrice")
        aCoder.encode(drugs, forKey: "drugs")
    }
    
}
