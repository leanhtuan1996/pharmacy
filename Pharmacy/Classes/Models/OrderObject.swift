//
//  OrderObject.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/2/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class OrderObject: NSObject {
    
    var id: Int
    var date: String = ""
    var drugs: [DrugObject]
    
    init(id: Int, drugs: [DrugObject]) {
        self.id = id
        self.drugs = drugs
    }
}
