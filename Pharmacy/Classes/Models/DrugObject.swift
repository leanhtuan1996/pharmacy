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
    var price: Int = 0
    var quantity: Int = 0
    var name: String = ""
    var instructions: String = ""
    var formula: String = ""
    var contraindication: String = ""
    var sideEffect: String = ""
    var howToUse: String = ""
    
    
//    init(id: Int, name: String, instructions: String, formula: String, contraindication: String, sideEffect: String, howToUse: String, price: Int, quantity: Int = 0) {
//        self.id = id
//        self.name = name
//        self.instructions = instructions
//        self.formula = formula
//        self.contraindication = contraindication
//        self.sideEffect = sideEffect
//        self.howToUse = howToUse
//        self.price = price
//        self.quantity = quantity
//    }
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: "id")
        price = aDecoder.decodeInteger(forKey: "price")
        quantity = aDecoder.decodeInteger(forKey: "quantity")
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        instructions = aDecoder.decodeObject(forKey: "instructions") as? String ?? ""
        formula = aDecoder.decodeObject(forKey: "formula") as? String ?? ""
        contraindication = aDecoder.decodeObject(forKey: "contraindication") as? String ?? ""
        sideEffect = aDecoder.decodeObject(forKey: "sideEffect") as? String ?? ""
        howToUse = aDecoder.decodeObject(forKey: "howToUse") as? String ?? ""
        super.init()
//        self.init(id: id, name: name, instructions: instructions, formula: formula, contraindication: contraindication, sideEffect: sideEffect, howToUse: howToUse, price: price, quantity: quantity)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(quantity, forKey: "quantity")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(instructions, forKey: "instructions")
        aCoder.encode(formula, forKey: "formula")
        aCoder.encode(contraindication, forKey: "contraindication")
        aCoder.encode(sideEffect, forKey: "sideEffect")
        aCoder.encode(howToUse, forKey: "howToUse")
        
    }
    
}
