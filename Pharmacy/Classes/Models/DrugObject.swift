//
//  DrugObject.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DrugObject: NSObject {
    var id: Int
    var name: String
    var instructions: String
    var formula: String
    var contraindication: String
    var sideEffect: String
    var howToUse: String
    var price: Int
    
    init(id: Int, name: String, instructions: String, formula: String, contraindication: String, sideEffect: String, howToUse: String, price: Int) {
        self.id = id
        self.name = name
        self.instructions = instructions
        self.formula = formula
        self.contraindication = contraindication
        self.sideEffect = sideEffect
        self.howToUse = howToUse
        self.price = price
    }    
   
}
