//
//  OrderObject.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/2/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class OrderObject: NSObject {
    
    var id: Int
    var date: String?
    var drugs: [DrugObject]?
    var idPrescription: Int?
    
    init(id: Int) {
        self.id = id
    }
    
    required init?(json: JSON) {
        guard let id:Int = "id" <~~ json else {
            return nil
        }
        
        if let date:String = "date" <~~ json {
            self.date = date.jsonDateToDate()
        }
        
        self.id = id
        self.drugs = "drugs" <~~ json
        self.idPrescription = "prescription_id" <~~ json
    }
}
